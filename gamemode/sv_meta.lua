local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

local net = net
local util = util
local table = table
local player = player
local pairs = pairs
local Color = Color
local Format = Format

function Player:SendData()
	local time = 5

	if GAMEMODE:GetPhase() == ROUND_PLAY then
		time = ROUND_TIMELIMIT
	end

	net.Start("JB_GameData")
		net.WriteFloat(GAMEMODE:GetPhase())
		net.WriteFloat(GAMEMODE:GetRound()[1])
		net.WriteFloat(GAMEMODE:GetRound()[2])
		net.WriteFloat(time)
		net.WriteFloat(GAMEMODE.Ratio)
		net.WriteFloat(ROUND_WIN)
	net.Send(self)
end

function Player:AddMarker( icon )
	if !self.LastMarker then self.LastMarker = 0 end
	if self.LastMarker >= CurTime() then return end
	if !GAMEMODE.Markers then GAMEMODE.Markers = {} end
	if #GAMEMODE.Markers >= GAMEMODE.MarkerMax and GAMEMODE.MarkerMax != 0 then return end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	
	GAMEMODE.Markers[#GAMEMODE.Markers + 1] = { Time = CurTime() + GAMEMODE.MarkerDuration, Pos = self:GetEyeTraceNoCursor().HitPos, Ang = ang, Icon = icon  }
	
	local tbl = util.Compress(util.TableToJSON(GAMEMODE.Markers))
	net.Start("JB_Marker")
		net.WriteData(tbl, tbl:len())
	net.Broadcast()

	self.LastMarker = CurTime() + 0.3
end

function Player:RemoveMarker()
	if !self.LastMarker then self.LastMarker = 0 end
	if self.LastMarker >= CurTime() then return end
	if #GAMEMODE.Markers == 0 then return end
	
	table.remove(GAMEMODE.Markers, #GAMEMODE.Markers)
	
	local tbl = util.Compress(util.TableToJSON(GAMEMODE.Markers))
	net.Start("JB_Marker")
		net.WriteData(tbl, tbl:len())
	net.Broadcast()

	self.LastMarker = CurTime() + 0.3
end

function Player:SpawnProp( mdl )
	if !self.LastProp then self.LastProp = 0 end
	if self.LastProp >= CurTime() then return end
	if !GAMEMODE.Props then GAMEMODE.Props = {} end

	
	local prop = ents.Create("prop_physics")
	prop:SetModel(GAMEMODE.WardenProps[mdl])
	prop:SetPos(self:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 5))
	prop:Spawn()

	GAMEMODE.Props[#GAMEMODE.Props + 1] = prop

	self.LastProp = CurTime() + 0.3
end

function Player:RemoveProp()
	if !self.LastProp then self.LastProp = 0 end
	if self.LastProp >= CurTime() then return end
	if #GAMEMODE.Props == 0 then return end
	
	GAMEMODE.Props[#GAMEMODE.Props]:Remove()
	table.remove(GAMEMODE.Props, #GAMEMODE.Props)
	

	self.LastProp = CurTime() + 0.3
end

function Player:SendMaps()
	if GAMEMODE.NextMap then return end

	net.Start("JB_UpdateMapVote")
		net.WriteTable(GAMEMODE.MapList)
	net.Send(self)
end

function Player:SetLR( bool )
	self:SetNWBool("lr", bool)
end

function Player:SetRebel( bool )
	if !self:IsInmate() then return end
	
	self:SetNWBool("rebel", bool)

	for _, pl in pairs(player.GetAll()) do
		GAMEMODE:AddNotice(4, Format(pl:GetPhrase("isrebel"), self:Nick()), pl)
	end
end

function Player:SetKills( num )
	self:SetNWInt("kills", num)
end

function Player:GetKills()
	return self:GetNWInt("kills", 0)
end

function Player:SetGuardBan( bool )
	self:SetNWBool("guardban", bool)
end

function Player:CanBecomeWarden()
	if !self:IsGuard() and !self:IsWarden() then
		return false
	end

	for _, ply in pairs(player.GetAll()) do
		if ply:IsWarden() and ply != self then
			if ply:IsDeadGuard() then
				ply:SetWarden(false)
				return true
			else
				return false
			end
		end
	end

	return true
end

function Player:SetWarden( bool )
	self:SetNWBool("warden", bool)
end

function Player:ThirdPerson()
	self:SetNWBool("thirdperson", !self:GetNWBool("thirdperson"))
end
