AddCSLuaFile()

SWEP.PrintName = "Fists"
SWEP.Author = "Kilburn, robotboy655, MaxOfS2D & Tenrys"
SWEP.Purpose = "Well we sure as hell didn't use guns! We would just wrestle Hunters to the ground with our bare hands! I used to kill ten, twenty a day, just using my fists."

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType("normal")
	self.LastReload = CurTime() + 1
end

function SWEP:Reload()
	if self.LastReload > CurTime() then return end

	if self:GetHoldType() == "fist" then
		self:SetHoldType("normal")
	else
		self:SetHoldType("fist")
	end
	self.LastReload = CurTime() + 1

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( self:GetHoldType() ) )


	if CLIENT then
		self.Owner:EmitSound(Sound("Grenade.Blip"))
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )
end

function SWEP:PrimaryAttack( right )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )

	self:SetNextPrimaryFire( CurTime() + 0.9 )
	self:SetNextSecondaryFire( CurTime() + 0.9 )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

function SWEP:DealDamage()
	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 8, 12 ) )

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( 12, 24 ) )
		end

		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true
	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
	local speed = 1.4

	local vm = self.Owner:GetViewModel() or false
	if vm and IsValid(vm) then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "melee" ) )
		vm:SetPlaybackRate( speed )

		self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
		self:UpdateNextIdle()


		if SERVER then
			self:SetCombo( 0 )
		end
	else
		if SERVER then
			// no more Sequence errors
			local ply = self.Owner

			ply:StripWeapon("weapon_hands")

			timer.Simple(1, function()
				ply:Give("weapon_hands")
				ply:SelectWeapon("weapon_hands")
			end)
		end
	end

	return true
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )

		self:UpdateNextIdle()
	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then
		self:DealDamage()
		self:SetNextMeleeAttack( 0 )
	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then
		self:SetCombo( 0 )
	end
end

function SWEP:PreDrop( ply )
end
