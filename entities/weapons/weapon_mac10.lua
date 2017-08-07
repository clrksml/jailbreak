AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "MAC 10"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_mac10", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "smg"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_smg_mac10.mdl")
SWEP.WorldModel				= Model("models/weapons/w_smg_mac10.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_MAC10.Reload")
SWEP.IronSightsPos			= Vector(-9.29, -4.624, 2.68)
SWEP.IronSightsAng			= Vector(1, -5, -7)

SWEP.Primary.Sound			= Sound("Weapon_MAC10.Single")
SWEP.Primary.Damage			= 28
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.06
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
