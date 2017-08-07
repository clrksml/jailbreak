AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "FAMAS"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_famas", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_rif_famas.mdl")
SWEP.WorldModel				= Model("models/weapons/w_rif_famas.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_FAMAS.Reload")
SWEP.IronSightsPos			= Vector(-6.25, 0.000, 1.000)
SWEP.IronSightsAng			= Vector(0.000, 0.000, 0.000)

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Damage			= 29
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.09
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
