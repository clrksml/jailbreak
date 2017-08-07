AddCSLuaFile()
DEFINE_BASECLASS("weapon_base")

if CLIENT then
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 80
	SWEP.CSMuzzleFlashes	= true
	
	surface.CreateFont("CSKillIcons", {font = "csd", size = ScreenScale(30), weight = 500, additive = true})
end

SWEP.Category				= "JB"
SWEP.Spawnable				= true
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.AllowDrop				= true

SWEP.Primary.Sound			 = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipMax		= -1

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipMax		= -1

SWEP.DeploySpeed			= 1.4

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 1, "Ironsights")
	self:NetworkVar("Float", 1, "StoredAmmo")
	self:NetworkVar("Float", 2, "ClipAmmo")
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(self.DeploySpeed)
	
	self:SetStoredAmmo(self.Primary.ClipSize * 2)
	self:SetClipAmmo(self.Primary.ClipSize)
end

if SERVER then
	function SWEP:Equip( ply )
		if self:IsOnFire() then
			self:Extinguish()
		end
		
		self:SetIronsights(false)
		self.Owner:DrawViewModel(true)
		
		ply:RemoveAmmo(ply:GetAmmoCount(self.Primary.Ammo), self.Primary.Ammo)
		
		local ammo, clip = self:GetStoredAmmo(), self:GetClipAmmo()
		
		if ammo > 0 then
			ply:GiveAmmo(ammo, self.Primary.Ammo, true)
			self:SetStoredAmmo(0)
		end
		
		if clip > 0 then
			self:SetClip1(clip)
			self:SetClipAmmo(0)
		else
			self:SetClip1(0)
		end
	end
	
	function SWEP:Holster()
		self:SetIronsights(false)
		return true
	end
	
	function SWEP:EquipAmmo( ply )
		return false
	end
	
	function SWEP:PreDrop( ply )
		if IsValid(ply) and !self.Melee and self.Primary.Ammo != "none" then
			local ammo, clip = self:Ammo1(), self:Clip1()
			
			if ammo > 0 then
				self:SetStoredAmmo(ammo)
				ply:RemoveAmmo(ammo, self.Primary.Ammo)
			end
			
			if clip >= 0 then
				self:SetClipAmmo(clip)
			end
		end
	end
else
	function SWEP:TranslateFOV( fov )
		if self:GetIronsights() then
			if self.Scope then
				return fov - 50
			else
				return fov - 25
			end
		else
			return fov
		end
	end
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self.Weapon:EmitSound(self.Primary.Sound)
	
	if self.Melee then 
		self:ShootBullet(self.Primary.Damage, 0, 0, 0)
		
		return
	else
		self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
	end
	
	if SERVER then
		if GAMEMODE:GetLR() == "s4s" then
			local inmate, guard = GAMEMODE:GetLRPlayers()[1], GAMEMODE:GetLRPlayers()[2]
			
			if inmate:Alive() and guard:Alive() then
				if inmate == self:GetOwner() then
					guard:GetWeapons()[1]:SetClip1(1)
					inmate:StripAmmo()
				else
					inmate:GetWeapons()[1]:SetClip1(1)
					guard:StripAmmo()
				end
			end
		end
	end
	
	self:TakePrimaryAmmo(1)
	
	local owner = self.Owner
	if !IsValid(owner) or owner:IsNPC() or (!owner.ViewPunch) then return end
	
	if !self.Melee then
		if self:GetIronsights() and self.Scope then
			owner:ViewPunch(Angle(math.Rand(-0.4,-0.8) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		else
			owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		end
	end
end

function SWEP:CanPrimaryAttack()
	if !IsValid(self.Owner) then return end
	
	if SERVER then
		if GAMEMODE:GetLR() == "s4s" then
			local inmate, guard = GAMEMODE:GetLRPlayers()[1], GAMEMODE:GetLRPlayers()[2]
			
			if inmate:Alive() and guard:Alive() then
				if inmate:GetAmmoCount("pistol") > 0 then
					return true
				end
				
				if guard:GetAmmoCount("pistol") > 0 then
					return true
				end
			end
		end
	end
	
	if self.Melee then 
		return true
	end
	
	if self:Clip1() <= 0 then
		return false
	end
	
	return true
end

function SWEP:CanSecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then
		return false
	end
	
	return true
end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return end
	
	if self.Melee then
		self.Weapon:EmitSound(self.Primary.Sound)
		
		self:ShootBullet(self.Secondary.Damage, 0, 0, 0)
		
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return
	end
	
	if !self.IronSightsPos then return end
	
	if self:GetIronsights() then
		self:SetIronsights(false)
		
		if self.Scope then
			if CLIENT then
				self.Owner:DrawViewModel(true)
			end
		end
	else
		self:SetIronsights(true)
		
		if self.Scope then
			if CLIENT then
				self.Owner:DrawViewModel(false)
			end
		end
	end
	
	self:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
	if !self.Melee then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:MuzzleFlash()
		self.Owner:DoAttackEvent()
	else
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:DoAttackEvent()
	end
	
	local sights = self:GetIronsights()
	
	numbul = numbul or 1
	cone = cone or 0.01
	
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( cone, cone, 0 )
	bullet.Tracer = 4
	bullet.TracerName = "Tracer"
	bullet.Force = 10
	bullet.Damage = dmg
	
	if self.Melee then
		bullet.Distance = 80
	end
	
	bullet.Callback = function ( attacker, tr, dmginfo )
		if self.Melee then
			if IsValid(tr.Entity) then
				if dmg < 51 then
					self:EmitSound("Weapon_Knife.Slash")
				else
					self:EmitSound("Weapon_Knife.Stab")
				end
			else
				self:EmitSound("Weapon_Knife.HitWall")
			end
		else
			self.Weapon:BulletCallback(attacker, tr, dmginfo, -1)
		end
	end
	
	self.Owner:FireBullets( bullet )
	
	if self.Melee then return end
end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone or 0.2
	
	return self:GetIronsights() and (cone * 0.85) or cone
end

function SWEP:Deploy()
	if self:IsMelee() then
		self:EmitSound("Weapon_Knife.Deploy")
	end
	
	self:SetIronsights(false)
	
	return true
end

function SWEP:Reload()
	if (self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then return end
	
	if self:GetIronsights() then
		self:SetIronsights(false)
		
		if CLIENT and self.Scope then
			self.Owner:DrawViewModel(true)
		end
	end
	
	self:DefaultReload(ACT_VM_RELOAD)
	
	local Anim = self.Owner:GetViewModel():SequenceDuration()
	
	self:SetNextPrimaryFire(CurTime() + Anim)
	self:SetNextSecondaryFire(CurTime() + Anim)
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self.Weapon:GetPrimaryAmmoType())
end

function SWEP:GetIronsights()
	return self.ironsights
end

function SWEP:SetIronsights( bool )
	self.ironsights = bool
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end

if CLIENT then
	function SWEP:DrawHUD()
		if !IsValid(LocalPlayer()) then return end
		
		if self:GetIronsights() and self.Scope then
			local x = ScrW() / 2.0
			local y = ScrH() / 2.0
			local w = (x - (ScrH() / 2)) + 2
			
			surface.SetDrawColor(Color(0, 0, 0, 255))
			
			surface.DrawRect(0, 0, w, ScrH())
			surface.DrawRect(x + (ScrH() / 2) - 2, 0, w, ScrH())
			
			surface.SetTexture(surface.GetTextureID("sprites/scope"))
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRectRotated(x, y, ScrH(), ScrH(), 0)
			
			local scale = math.max(0.2,  10 * self:GetPrimaryCone())
			local LastShootTime = self:LastShootTime()
			
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			local gap = 20 * scale * (self:GetIronsights() and 0.8 or 1)
			local length = ScrW()
			
			surface.SetDrawColor(Color(255, 255, 255))
			surface.DrawLine(x - length - 1, y, x - gap - 1, y)
			surface.DrawLine(x + length, y, x + gap, y)
			surface.DrawLine(x - 1, y - length, x - 1, y - gap)
			surface.DrawLine(x - 1, y + length, x - 1, y + gap)
		end
		
		if !self:GetIronsights() then
			local x = ScrW() / 2
			local y = ScrH() / 2
			local scale = 0.25
			local LastShootTime = self:LastShootTime()
			
			scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
			
			local gap = 20 * scale * (self:GetIronsights() and 0.8 or 1)
			local length = gap + (25 * 1) * scale
			
			surface.SetDrawColor(Color(255, 255, 255))
			surface.DrawLine(x - length - 1, y, x - gap - 1, y)
			surface.DrawLine(x + length, y, x + gap, y)
			surface.DrawLine(x - 1, y - length, x - 1, y - gap)
			surface.DrawLine(x - 1, y + length, x - 1, y + gap)
		end
	end
end

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )
	if !self.IronSightsPos then
		return pos, ang
	end
	
	local bIron = self:GetIronsights()
	
	if bIron != self.bLastIron then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
		
		if bIron then
			self.SwayScale = 0.3
			self.BobScale = 0.1
		else
			self.SwayScale = 1.0
			self.BobScale = 1.0
		end
	end
	
	local fIronTime = self.fIronTime or 0
	
	if (!bIron) and fIronTime < CurTime() - IRONSIGHT_TIME then
		return pos, ang
	end
	
	local mul = 1.0
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
		mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if !bIron then mul = 1 - mul end
	end
	
	local offset = self.IronSightsPos + vector_origin
	
	if self.IronSightsAng then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), self.IronSightsAng.x * mul )
		ang:RotateAroundAxis( ang:Up(), self.IronSightsAng.y * mul )
		ang:RotateAroundAxis( ang:Forward(),  self.IronSightsAng.z * mul )
	end
	
	pos = pos + offset.x * ang:Right() * mul
	pos = pos + offset.y * ang:Forward() * mul
	pos = pos + offset.z * ang:Up() * mul
	
	return pos, ang
end

function SWEP:BulletCallback( attacker, tr, dmginfo, bounce )
	if( !self or !IsValid( self.Weapon ) ) then return end
	
	self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 )
	
	return { damage = true, effect = true, effects = true }
end

function SWEP:GetPenetrationDistance( mat_type )
	if ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
		return 65
	end
	
	return 33
end

function SWEP:GetPenetrationDamageLoss( mat_type, distance, damage )
	if( mat_type == MAT_GLASS ) then
		return damage
	elseif ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
		return damage - distance
	elseif( mat_type == MAT_DIRT ) then
		return damage - ( distance * 1.2 )
	end
	
	return damage - ( distance * 1.95 )
end

function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )
	if ( !self or !IsValid( self.Weapon ) ) then return end
	
	if ( bounce > 3 ) then return false end
	
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
	
	local PeneTrace = {}
	PeneTrace.endpos = tr.HitPos
	PeneTrace.start = tr.HitPos + PeneDir
	PeneTrace.mask = MASK_SHOT
	PeneTrace.filter = { self.Owner }
	
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	if ( PeneTrace.StartSolid || PeneTrace.Fraction >= 1.0 || tr.Fraction <= 0.0 ) then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length()
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() )
	
	if ( new_damage > 0 ) then
		local bullet = {
			Num				 = 1,
			Src				 = PeneTrace.HitPos,
			Dir				 = tr.Normal,
			Spread			 = Vector( 0, 0, 0 ),
			Tracer			 = 4,
			Force			  = 5,
			Damage			 = new_damage,
			AmmoType		  = "Pistol",
		}
		
		bullet.Callback = function( a, b, c ) if ( self.BulletCallback ) then return self:BulletCallback( a, b, c, bounce + 1 ) end end
		 
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos )
		effectdata:SetNormal( PeneTrace.Normal )
		util.Effect( "Impact", effectdata ) 
		
		if IsValid(attacker) then
			attacker:FireBullets(bullet, true)
		end
	end
end
