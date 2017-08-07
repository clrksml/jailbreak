AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "TMP"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_tmp", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "smg"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_smg_tmp.mdl")
SWEP.WorldModel				= Model("models/weapons/w_smg_tmp.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_TMP.Reload")
SWEP.IronSightsPos			= Vector(-6.961, -8.643, 2.96)
SWEP.IronSightsAng			= Vector(0, 0, 1)

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.09
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
