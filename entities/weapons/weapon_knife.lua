AddCSLuaFile()
DEFINE_BASECLASS("weapon_jbbase")

SWEP.PrintName			= "Knife"
SWEP.Slot				= 2
SWEP.SlotPos			= 1

if CLIENT then
	killicon.AddFont("weapon_knife", "CSKillIcons", "t", Color(255, 80, 0, 255))
end

SWEP.HoldType				= "knife"
SWEP.ViewModel				= Model("models/weapons/v_knife_t.mdl")
SWEP.WorldModel				= Model("models/weapons/w_knife_t.mdl")
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
SWEP.Melee					= true

SWEP.Primary.Sound			= Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage			= 34
SWEP.Primary.NumShots		= 0
SWEP.Primary.Recoil			= 0
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.5
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.Damage			= 51
SWEP.Secondary.NumShots			= 0
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Cone				= 0
SWEP.Secondary.ClipSize			= 0
SWEP.Secondary.DefaultClip		= 0
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= ""
