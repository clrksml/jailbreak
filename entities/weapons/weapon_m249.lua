AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "M249"
SWEP.Slot				= 0
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_m249", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.WorldModel				= Model("models/weapons/w_mach_m249para.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_M249.Reload")
SWEP.IronSightsPos			= Vector(-5.961, -6.433, 2.319)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Damage			= 31
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Cone			= 0.03
SWEP.Primary.Delay			= 0.05
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
