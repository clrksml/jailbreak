AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "Steyr Scout"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_scout", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel				= Model("models/weapons/w_snip_scout.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_Scout.Reload")
SWEP.IronSightsPos			= Vector(-6.68, -8.04, 2.48)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Damage			= 74
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2
SWEP.Primary.Cone			= 0.0035
SWEP.Primary.Delay			= 1.25
SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"
