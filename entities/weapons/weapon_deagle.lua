AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "Desert Eagle"
SWEP.Slot					= 1
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_deagle", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "pistol"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_pist_deagle.mdl")
SWEP.WorldModel				= Model("models/weapons/w_pist_deagle.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_Deagle.Reload")
SWEP.IronSightsPos			= Vector(-6.361, 0, 2.16)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_Deagle.Single")
SWEP.Primary.Damage			= 52
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Cone			= 0.018
SWEP.Primary.Delay			= 0.25
SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 21
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
