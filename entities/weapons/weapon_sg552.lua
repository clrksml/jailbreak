AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "SG 552"
SWEP.Slot				= 0
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_sg552", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "ar2"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_rif_sg552.mdl")
SWEP.WorldModel				= Model("models/weapons/w_rif_sg552.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_SG552.Reload")
SWEP.IronSightsPos			= Vector(-7.881, -8.242, 1.399)
SWEP.IronSightsAng			= Vector(0, 0, 0)

SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.Delay			= 0.1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
