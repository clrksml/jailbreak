AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "AWP"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_awp", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_snip_awp.mdl")
SWEP.WorldModel				= Model("models/weapons/w_snip_awp.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_AWP.Reload")
SWEP.IronSightsPos			= Vector(-7.401, -7.237, 0.6)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Primary.Damage			= 114
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 1.41
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"
