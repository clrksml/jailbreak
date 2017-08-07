AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "MP5A1"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_mp5navy", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_smg_mp5.mdl")
SWEP.WorldModel				= Model("models/weapons/w_smg_mp5.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_MP5Navy.Reload")
SWEP.IronSightsPos			= Vector(-5.321, -6.835, 2.16)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.55
SWEP.Primary.Cone			= 0.018
SWEP.Primary.Delay			= 0.077
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
