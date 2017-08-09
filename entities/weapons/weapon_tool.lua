AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "LR Tool"
SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/v_pistol.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pistol.mdl")
SWEP.UseHands				= true
SWEP.AllowDrop				= false
SWEP.ViewModelFlip			= false
SWEP.SwayScale				= 0
SWEP.BobScale				= 0
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Spawnable				= true
SWEP.AdminOnly				= true
SWEP.Scope					= false
SWEP.Melee					= false
SWEP.ReloadSound 			= Sound("Weapon_Pistol.Reload")
SWEP.IronSightsPos			= Vector(0, 0, 0)
SWEP.IronSightsAng			= Vector(0, 0, 0)
SWEP._guard, SWEP._inmate	= false, false

SWEP.Primary.Sound			= Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.3
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

local cent, mode, ang = {}, {}, 0

function SWEP:SetupDataTables()
	self:NetworkVar("String", 1, "Mode")
	self:NetworkVar("Float", 1, "Angle")
end

function SWEP:PreDrop( ply )
	for k, v in pairs(cent) do
		for key, val in pairs(v) do
			SafeRemoveEntity(val.Ent)
			
			if type(k) == "table" then
			cent[k.ID][key] = nil
			else
				cent[k][key] = nil
			end
		end
	end
	
	net.Start("ToolTable")
		net.WriteTable(cent)
	net.Send(ply)
end

function SWEP:Equip( ply )
	if SERVER then
		if !table.HasValue(GAMEMODE.ToolAccess, ply:SteamID()) then
			ply:ChatPrint("You don't have access to this tool.")
			ply:StripWeapon("weapon_tool")
			return
		end
		
		for key, val in pairs(cent) do
			for k, v in pairs(val) do
				SafeRemoveEntity(v.Ent)
			end
		end
		
		for key, val in pairs(cent) do
			cent[key] = {}
		end
		
		local str = file.Read("data/jailbreak/maps/" .. game.GetMap() .. ".txt", "GAME")
		
		if str then
			local tbl = util.JSONToTable(str)
			
			if tbl then
				cent = tbl
				
				for key, val in pairs(cent) do
					for k, v in pairs(val) do
						if key != "gspawns" and key != "ispawns" then
							local ent = ents.Create("prop_physics")
							ent:SetPos(v.Pos)
							ent:SetAngles(v.Ang)
							ent:SetModel("models/player/swat.mdl")
							ent:Spawn()
							ent:SetSequence(ent:LookupSequence("idle"))
							
							if v.Team == 1 then
								ent:SetModel("models/player/swat.mdl")
								
								cent[key][k] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
							else
								ent:SetModel("models/player/phoenix.mdl")
								
								cent[key][k] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
							end
							
							ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
							ent:GetPhysicsObject():EnableMotion(false)
							ent:GetPhysicsObject():Sleep()
						else
							local ent = ents.Create("prop_physics")
							ent:SetPos(v.Pos)
							ent:SetAngles(v.Ang)
							ent:SetModel("models/player/urban.mdl")
							ent:Spawn()
							ent:SetSequence(ent:LookupSequence("idle"))
							
							if v.Team == 1 then
								ent:SetModel("models/player/urban.mdl")
								
								cent[key][k] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
							else
								ent:SetModel("models/player/arctic.mdl")
								
								cent[key][k] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
							end
							
							ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
							ent:GetPhysicsObject():EnableMotion(false)
							ent:GetPhysicsObject():Sleep()
						end
					end
					
					mode = val
				end
			end
		end
		
		ply:SendLR()
		
		for key, val  in pairs(GAMEMODE.LastRequests) do
			if val.CustomSpawns then
				mode = val
				cent[val.ID] = {}
			end
		end
		
		net.Start("ToolTable")
			net.WriteTable(cent)
		net.Send(ply)
	end
end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() >= CurTime()
end

function SWEP:PrimaryAttack()
	if !SERVER then return end
	if self:CanPrimaryAttack() then return end
	
	if type(mode) == "table" and cent[mode.ID] then
		if !cent[mode.ID][1] then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(self:GetOwner():GetEyeTrace().HitNormal.x, ang, self:GetOwner():GetEyeTrace().HitNormal.z))
			ent:SetModel("models/player/urban.mdl")
			ent:Spawn()
			ent:SetColor(Color(255, 255, 255, 200))
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][1] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Guard pos for " .. mode.Name .. " set.")
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(self:GetOwner())
			
			return
		end
		
		if !cent[mode.ID][2] then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(self:GetOwner():GetEyeTrace().HitNormal.x, ang, self:GetOwner():GetEyeTrace().HitNormal.z))
			ent:SetModel("models/player/arctic.mdl")
			ent:Spawn()
			ent:SetColor(Color(255, 255, 255, 200))
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][2] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Inmate pos for " .. mode.Name .. " set.")
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(self:GetOwner())
			
			return
		end
		
		if #cent[mode.ID][1] > 0 and #cent[mode.ID][2] > 0 then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Both positions are already set for " .. mode.Name .. ".")
		end
	else
		local key = 0
		
		if cent[mode] then
			key = #cent[mode]
		else
			cent[mode] = {}
		end
		
		if mode == "gspawns" and #cent[mode] < (game.MaxPlayers() / GAMEMODE.Ratio) then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(self:GetOwner():GetEyeTrace().HitNormal.x, ang, self:GetOwner():GetEyeTrace().HitNormal.z))
			ent:SetModel("models/player/urban.mdl")
			ent:Spawn()
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode][key + 1] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Guard spawn pos set " .. #cent[mode] .. "/" .. game.MaxPlayers() / GAMEMODE.Ratio .. " set.")
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(self:GetOwner())
			
			return
		end
		
		if mode == "ispawns" and #cent[mode] < game.MaxPlayers() then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(self:GetOwner():GetEyeTrace().HitNormal.x, ang, self:GetOwner():GetEyeTrace().HitNormal.z))
			ent:SetModel("models/player/arctic.mdl")
			ent:Spawn()
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode][key + 1] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Inmate spawn pos set " .. #cent[mode] .. "/" .. game.MaxPlayers() .. " set.")
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(self:GetOwner())
			
			return
		end
		
		if type(mode) == "table" and cent[mode.ID] and cent[mode.ID][1] and cent[mode.ID][2] then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Both positions are already set for " .. mode.Name .. ".")
		end
		
		if type(mode) == "string" then
			if mode == "gspawns" and #cent[mode] < (game.MaxPlayers() / GAMEMODE.Ratio) then
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
				self:GetOwner():ChatPrint("All Team Spawn positions are already set for " .. self:GetOwner():GetPhrase("guards") .. ".")
			end
			
			if mode == "ispawns" and #cent[mode] < game.MaxPlayers() then
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
				self:GetOwner():ChatPrint("Both positions are already set for " .. self:GetOwner():GetPhrase("inmates") .. ".")
			end
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(self:GetOwner())
		end
	end
end

function SWEP:SecondaryAttack()
	if !table.HasValue(GAMEMODE.ToolAccess, self:GetOwner():SteamID()) then return end
	
	if CLIENT then
		local angles = { 0, 45, 90, 135, 180, 225, 270, 315 }
		
		local SelectionMenu = DermaMenu()
		local LRMenu = SelectionMenu:AddSubMenu("Last Request")
		
		for k, v in pairs(GAMEMODE.LastRequests) do
			if v[3] then
				LRMenu:AddOption(v[2], function()
					net.Start("ToolAction")
						net.WriteString("mode")
						net.WriteString(v[1])
					net.SendToServer()
				end)
			end
		end
		
		if GAMEMODE.CustomSpawns then
			local TeamSpawnMenu = SelectionMenu:AddSubMenu("Team Spawns")
			
			TeamSpawnMenu:AddOption("Guard Spawns", function()
				net.Start("ToolAction")
					net.WriteString("spawns")
					net.WriteString("gspawns")
				net.SendToServer()
			end)
			
			TeamSpawnMenu:AddOption("Inmate Spawns", function()
				net.Start("ToolAction")
					net.WriteString("spawns")
					net.WriteString("ispawns")
				net.SendToServer()
			end)
		end
		
		local AngleMenu = SelectionMenu:AddSubMenu("Angle")
		
		for k, v in pairs(angles) do
			AngleMenu:AddOption(v, function()
				net.Start("ToolAction")
					net.WriteString("ang")
					net.WriteString(v)
				net.SendToServer()
			end)
		end
		
		SelectionMenu:AddOption("Save", function()
			net.Start("ToolAction")
				net.WriteString("save")
			net.SendToServer()
		end)
		
		local UndoMenu = SelectionMenu:AddSubMenu("Undo")
		
		UndoMenu:AddOption("Current", function()
			net.Start("ToolAction")
				net.WriteString("current")
			net.SendToServer()
		end)
		
		UndoMenu:AddOption("All", function()
			net.Start("ToolAction")
				net.WriteString("all")
			net.SendToServer()
		end)
		
		
		local RemoveMenu = SelectionMenu:AddOption("Remove", function()
			net.Start("ToolAction")
				net.WriteString("remove")
			net.SendToServer()
		end)
		
		SelectionMenu:Open()
		SelectionMenu:SetPos(ScrW() / 2 - 60, ScrH() / 2 + 100)
	end
end

function SWEP:Reload()
	return false
end

hook.Add("PostDrawTranslucentRenderables", "DrawCircles", function()
	for k, v in pairs(cent) do
		for key, val in pairs(v) do
			render.SetMaterial(Material("sgm/playercircle"))
			render.DrawQuadEasy(val.Pos + Vector(0, 0, 1), Vector(0, 0, 1), 36, 36, team.GetColor(val.Team))
		end
	end
end)

net.Receive("ToolTable", function( len, ply )
	cent = net.ReadTable()
end)

if CLIENT then return end

util.AddNetworkString("ToolAction")
util.AddNetworkString("ToolTable")

net.Receive("ToolAction", function( len, ply )
	local action, action2 = net.ReadString(), net.ReadString()
	
	if action == "save" then
		local json = util.TableToJSON(cent)
		
		for name, val in pairs(cent) do
			if name == "ispawns" or name == "gspawns" then
				GAMEMODE.SpawnPos[name] = val
			else
				GAMEMODE.LRPos[name] = val
			end
		end
		
		if !file.IsDir("jailbreak", "DATA") then
			file.CreateDir("jailbreak")
		end
		
		if !file.IsDir("jailbreak/maps", "DATA") then
			file.CreateDir("jailbreak/maps")
		end
		
		file.Write("jailbreak/maps/" .. game.GetMap() .. ".txt", json)
		
		ply:ChatPrint("Exported Last Requests positions.")
	elseif action == "current" then
		if type(mode) == "table" then
			for key, val in pairs(cent[mode.ID]) do
				SafeRemoveEntity(val.Ent)
				
				cent[mode.ID][key] = nil
			end
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(ply)
			
			ply:ChatPrint("Removed " .. mode.Name .. " Last Request positions.")
		else
			for key, val in pairs(cent[mode]) do
				SafeRemoveEntity(val.Ent)
				
				cent[mode][key] = nil
			end
			
			net.Start("ToolTable")
				net.WriteTable(cent)
			net.Send(ply)
			
			if mode == "gspawns" then
				ply:ChatPrint("Removed " .. ply:GetPhrase("guard") .. " Team Spawn positions.")
			else
				ply:ChatPrint("Removed " .. ply:GetPhrase("inmate") .. " Team Spawn positions.")
			end
		end
	elseif action == "all" then
		for k, v in pairs(cent) do
			for key, val in pairs(v) do
				SafeRemoveEntity(val.Ent)
				
				if type(k) == "table" then
					cent[k.ID][key] = nil
				else
					cent[k][key] = nil
				end
			end
		end
		
		net.Start("ToolTable")
			net.WriteTable(cent)
		net.Send(ply)
		
		ply:ChatPrint("Removed all Last Requests & Team Spawn positions.")
	elseif action == "ang" then
		ang = action2
		
		ply:ChatPrint("Angle Yaw set to " .. ang .. ".")
	elseif action == "mode" then
		for k, v in pairs(GAMEMODE.LastRequests) do
			if v.ID == action2 and v.CustomSpawns then
				mode = v
				
				ply:ChatPrint("Last Request changed to " .. mode.Name .. ".")
				
				break
			end
		end
	elseif action == "spawns" then
		if action2 == "gspawns" then
			mode = action2
			
			ply:ChatPrint("Team Spawns changed to " .. ply:GetPhrase("guards") .. ".")
		elseif action2 == "ispawns" then
			mode = action2
			
			ply:ChatPrint("Team Spawns changed to " .. ply:GetPhrase("inmates") .. ".")
		end
	elseif action == "remove" then
		for _, wep in pairs(ply:GetWeapons()) do
			if wep:GetClass() == "weapon_tool" then
				wep:PreDrop(ply)
			end
		end
		
		ply:StripWeapon("weapon_tool")
		ply:ChatPrint("Removed LR Tool.")
	end
end)
