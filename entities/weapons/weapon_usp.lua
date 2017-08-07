AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "USP Tactical"
SWEP.Slot					= 1
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_usp", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_pist_usp.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pist_usp.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_USP.Reload")
SWEP.IronSightsPos			= Vector(-5.921, -7.237, 2.559)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.9
SWEP.Primary.Cone			= 0.0125
SWEP.Primary.Delay			= 0.1
SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
