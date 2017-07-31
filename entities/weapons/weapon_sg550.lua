AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "SG 550"
SWEP.Slot				= 0
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_sg550", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_snip_sg550.mdl")
SWEP.WorldModel				= Model("models/weapons/w_snip_sg550.mdl")
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
SWEP.Scope					= true
SWEP.Melee					= false
SWEP.ReloadSound 			= Sound("Weapon_SG550.Reload")
SWEP.IronSightsPos			= Vector(-7.441, -8.04, 0.439)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_SG550.Single")
SWEP.Primary.Damage			= 69
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2
SWEP.Primary.Cone			= 0.0065
SWEP.Primary.Delay			= 0.65
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar"
