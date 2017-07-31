AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "G3SG1"
SWEP.Slot				= 0
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_g3sg1", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_snip_g3sg1.mdl")
SWEP.WorldModel				= Model("models/weapons/w_snip_g3sg1.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_G3SG1.Reload")
SWEP.IronSightsPos			= Vector(-6.12, -7.237, 1.08)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_G3SG1.Single")
SWEP.Primary.Damage			= 79
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2
SWEP.Primary.Cone			= 0.0225
SWEP.Primary.Delay			= 0.65
SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "a2"
