local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

function Player:CanLR()
	return team.NumPlayers(TEAM_INMATE) and (GAMEMODE:GetWarden() != false) and (self == team.GetPlayers(TEAM_INMATE)[1])
end

function Player:GetLR()
	return self:GetNWBool("lr", false)
end

function Player:SetLR( bool )
	self:SetNWBool("lr", bool)
end

function Player:CanBecomeWarden()
	if !self:IsGuard() or self:IsGuardBan() and !self:IsWarden() then
		return false
	end
	
	for _, ply in pairs(player.GetAll()) do
		if ply != self and ply:GetNWBool("warden") then
			return false
		end
	end
	
	return true
end

function Player:SetWarden( bool )
	self:SetNWBool("warden", bool)
end

function Player:IsWarden()
	return self:GetNWBool("warden", false)
end

function Player:IsGuard()
	return self:Team() == TEAM_GUARD
end

function Player:IsDeadGuard()
	return self:Team() == TEAM_GUARD_DEAD
end

function Player:IsInmate()
	return self:Team() == TEAM_INMATE
end

function Player:IsDeadInmate()
	return self:Team() == TEAM_INMATE_DEAD
end

function Player:IsSpec()
	return self:Team() == TEAM_SPECTATOR
end

function Player:IsGuardBan()
	return false
end

function Player:HasPrimary()
	for _, wep in pairs(self:GetWeapons()) do
		if wep:IsPrimary() then
			return true
		end
	end
	
	return false
end

function Player:HasSecondary()
	for _, wep in pairs(self:GetWeapons()) do
		if wep:IsSecondary() then
			return true
		end
	end
	
	return false
end

function Player:HasMelee()
	for _, wep in pairs(self:GetWeapons()) do
		if wep:IsMelee() then
			return true
		end
	end
	
	return false
end

function Player:HasMisc()
	for _, wep in pairs(self:GetWeapons()) do
		if wep:IsMisc() then
			return true
		end
	end
	
	return false
end

function Entity:IsPrimary()
	return self.Slot == 0
end

function Entity:IsSecondary()
	return self.Slot == 1
end

function Entity:IsMelee()
	return self.Slot == 2
end

function Entity:IsMisc()
	return self.Slot == 3
end
