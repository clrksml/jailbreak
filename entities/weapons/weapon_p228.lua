AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "P228"
SWEP.Slot				= 1
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_p228", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_pist_p228.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pist_p228.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_P228.Reload")
SWEP.IronSightsPos			= Vector(-5.961, -7.035, 2.64)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_P228.Single")
SWEP.Primary.Damage			= 39
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.9
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.11
SWEP.Primary.ClipSize		= 13
SWEP.Primary.DefaultClip	= 39
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
