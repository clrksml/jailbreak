AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "LR Tool"
SWEP.Slot				= 2
SWEP.SlotPos			= 1

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

local cent, tbl, mode, ang = {}, {}, {}, 0

function SWEP:Equip()
	if !SERVER then return end
	
	if !table.HasValue(GAMEMODE.ToolAccess, self:GetOwner():SteamID()) then
		self:GetOwner():ChatPrint("You don't have access to this tool.")
		self:GetOwner():StripWeapon("weapon_lr")
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
	
	for key, val in pairs(GAMEMODE.LastRequests) do
		if !cent[val.ID] and val.CustomSpawns then
			cent[val.ID] = {}
			mode = val
			tbl[key] = val
		end
	end
	
	self:GetOwner():ChatPrint("---------------------------------------------")
	self:GetOwner():ChatPrint("Primary Attack to place positions.")
	self:GetOwner():ChatPrint("Secondary Attack to change LR game.")
	self:GetOwner():ChatPrint("Reload to undo current LR game positions.")
	self:GetOwner():ChatPrint("Speed + Reload to undo all LR game positions.")
	self:GetOwner():ChatPrint("---------------------------------------------")
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
			ent:GetPhysicsObject():EnableMotion(false)
			ent:GetPhysicsObject():Sleep()
			
			cent[mode.ID][2] = { Ent = ent, Team = TEAM_INMATE, Pos = ent:GetPos(), Ang = ent:GetAngles() }
			
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Inmate pos for " .. mode.Name .. " set.")
			
			return
		end
		
		if cent[mode.ID][1] and cent[mode.ID][2] then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:GetOwner():ChatPrint("Both positions are already set for " .. mode.Name .. ".")
		end
	end
end

function SWEP:SecondaryAttack()
	if !SERVER then return end
	
	if self:GetOwner():KeyDown(IN_SPEED) then
		if ang == 0 then
			ang = 45
		elseif ang == 45 then
			ang = 90
		elseif ang == 90 then
			ang = 135
		elseif ang == 135 then
			ang = 180
		elseif ang == 180 then
			ang = 225
		elseif ang == 225 then
			ang = 270
		elseif ang == 270 then
			ang = 315
		else
			ang = 0
		end
		
		self:GetOwner():ChatPrint("Angle Yaw set to " .. ang .. ".")
	else
		for k, v in pairs(cent) do
			SafeRemoveEntity(v)
		end
		
		mode = table.FindNext(tbl, mode)
		
		self:GetOwner():ChatPrint("Last Request tool changed to " .. mode.Name .. ".")
	end
end

function SWEP:Reload()
	if !SERVER then return end
	
	if self:GetOwner():KeyDown(IN_SPEED) then
		if self:CanPrimaryAttack() then return end
		
		for key, val in pairs(cent) do
			for k, v in pairs(val) do
				SafeRemoveEntity(v.Ent)
			end
		end
		
		for key, val in pairs(cent) do
			cent[key] = {}
		end
		PrintTable(cent)
		
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	elseif self:GetOwner():KeyDown(IN_ZOOM) then
		if self:CanPrimaryAttack() then return end
		
		local tab = util.TableToJSON(cent)
		
		if !file.IsDir("jailbreak", "DATA") then
			file.CreateDir("jailbreak")
		end
		
		if !file.IsDir("jailbreak/maps", "DATA") then
			file.CreateDir("jailbreak/maps")
		end
		
		file.Write("jailbreak/maps/" .. game.GetMap() .. ".txt", tab )
		self:GetOwner():ChatPrint("Exported LR game positions now.")
		
		self:SetNextPrimaryFire(CurTime() + 3)
	else
		if self:CanPrimaryAttack() then return end
		
		for k, v in pairs(cent[mode.ID]) do
			cent[mode.ID][k] = nil
			SafeRemoveEntity(v.Ent)
		end
		
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end
