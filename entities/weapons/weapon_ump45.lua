AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName				= "UMP"
SWEP.Slot					= 0
SWEP.SlotPos				= 1

if CLIENT then
	killicon.AddFont("weapon_ump45", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "smg"
SWEP.ViewModel				= Model("models/weapons/cstrike/c_smg_ump45.mdl")
SWEP.WorldModel				= Model("models/weapons/w_smg_ump45.mdl")
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
SWEP.ReloadSound 			= Sound("Weapon_UMP45.Reload")
SWEP.IronSightsPos			= Vector(-8.681, -8.643, 3.4)
SWEP.IronSightsAng			= Vector(0, 0, -2)

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Damage			= 29
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 0.56
SWEP.Primary.Cone			= 0.0215
SWEP.Primary.Delay			= 0.081
SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
