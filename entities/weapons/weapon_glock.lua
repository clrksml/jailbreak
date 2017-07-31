AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "Glock 18"
SWEP.Slot				= 1
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_glock", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_pist_glock18.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pist_glock18.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_Glock.Reload")
SWEP.IronSightsPos			= Vector(-5.801, 0, 2.88)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_Glock.Single")
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.9
SWEP.Primary.Cone			= 0.014
SWEP.Primary.Delay			= 0.13
SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
