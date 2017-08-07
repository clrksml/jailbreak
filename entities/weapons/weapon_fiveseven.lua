AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "Five Seven"
SWEP.Slot					= 1
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_fiveseven", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_pist_fiveseven.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pist_fiveseven.mdl")
SWEP.UseHands				= true
SWEP.AllowDrop				= true
SWEP.ViewModelFlip			= false
SWEP.SwayScale				= 0
SWEP.BobScale				= 0
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Spawnable				= true
SWEP.AdminOnly				= false
SWEP.Scope					= false
SWEP.Melee					= false
SWEP.ReloadSound 			= Sound("Weapon_FiveSeven.Reload")
SWEP.IronSightsPos			= Vector(-5.961, 0, 2.799)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.75
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.13
SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
