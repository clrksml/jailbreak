AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

if CLIENT then
end

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
SWEP._guard, SWEP._inmate = false, false

SWEP.Primary.Sound			= Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.3
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

local cent, mode, ang = {}, {}, 0

function SWEP:SetupDataTables()
	self:NetworkVar("String", 1, "Mode")
	self:NetworkVar("Float", 1, "Angle")
end

function SWEP:Equip( ply )
	if !SERVER then return end
	
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
	
	if !cent["gspawns"] then
		cent["gspawns"] = {}
	end
	
	if !cent["ispawns"] then
		cent["ispawns"] = {}
	end
	
	for key, val in pairs(GAMEMODE.LastRequests) do
		if !cent[val.ID] and val.CustomSpawns then
			cent[val.ID] = {}
			mode = val
		end
	end
	
	ply:SendLR()
end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() >= CurTime()
end

function SWEP:PrimaryAttack()
	if !SERVER then return end
	if self:CanPrimaryAttack() then return end
	
	if cent[mode.ID] then
		if !cent[mode.ID][1] then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(0, ang, 0))
			ent:SetModel("models/player/urban.mdl")
			ent:Spawn()
			ent:SetColor(Color(255, 255, 255, 100))
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][1] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Guard pos for " .. mode.Name .. " set.")
			
			return
		end
		
		if !cent[mode.ID][2] then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(0, ang, 0))
			ent:SetModel("models/player/arctic.mdl")
			ent:Spawn()
			ent:SetColor(Color(255, 255, 255, 100))
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][2] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Inmate pos for " .. mode.Name .. " set.")
			
			return
		end
		
		if #cent[mode.ID][1] > 0 and #cent[mode.ID][2] > 0 then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Both positions are already set for " .. mode.Name .. ".")
		end
	else
		/*if #cent[mode.ID][1] < (game.MaxPlayers() / GAMEMODE.Ratio) then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(0, ang, 0))
			ent:SetModel("models/player/urban.mdl")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][1] = { Ent = ent, Team = TEAM_GUARD, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Guard spawn pos set " .. #cent[mode.id][1] .. "/" .. game.MaxPlayers() / GAMEMODE.Ratio .. " set.")
			
			return
		end
		
		if #cent[mode.ID][1] < game.MaxPlayers() then
			local ent = ents.Create("prop_physics")
			ent:SetPos(self:GetOwner():GetEyeTrace().HitPos)
			ent:SetAngles(Angle(0, ang, 0))
			ent:SetModel("models/player/arctic.mdl")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][2] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Inmate spawn pos set " .. #cent[mode.id][2] .. "/" .. game.MaxPlayers() .. " set.")
			
			return
		end*/
		
		if cent[mode.ID][1] and cent[mode.ID][2] then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Both positions are already set for " .. mode.Name .. ".")
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
		
		SelectionMenu:Open()
		SelectionMenu:SetPos(ScrW() / 2 - 60, ScrH() / 2 + 100)
	end
end

function SWEP:Reload()
	return false
end

if CLIENT then return end

util.AddNetworkString("ToolAction")

net.Receive("ToolAction", function( len, ply )
	local action, action2 = net.ReadString(), net.ReadString()
	
	if action == "save" then
		local json = util.TableToJSON(cent)
		
		if !file.IsDir("jailbreak", "DATA") then
			file.CreateDir("jailbreak")
		end
		
		if !file.IsDir("jailbreak/maps", "DATA") then
			file.CreateDir("jailbreak/maps")
		end
		
		file.Write("jailbreak/maps/" .. game.GetMap() .. ".txt", json)
		
		ply:ChatPrint("Exported Last Requests positions.")
	elseif action == "current" then
		for key, val in pairs(cent[mode.ID]) do
			SafeRemoveEntity(val.Ent)
			
			cent[mode.ID][key] = nil
		end
		
		ply:ChatPrint("Removed " .. mode.Name .. " Last Request positions.")
	elseif action == "all" then
		for k, v in pairs(cent) do
			for key, val in pairs(v) do
				SafeRemoveEntity(val.Ent)
				cent[mode.ID][key] = nil
			end
		end
		
		ply:ChatPrint("Removed all Last Requests positions.")
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
	end
end)
