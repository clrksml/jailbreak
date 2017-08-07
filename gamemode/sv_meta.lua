local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

local net = net

local colors, color = { Color(242, 38, 19), Color(102, 51, 153), Color(37, 116, 169), Color(30, 130, 76), Color(242, 121, 53) }

function Player:SendData()
	local time = 5
	
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		time = ROUND_TIMELIMIT
	end
	
	net.Start("GameData")
		net.WriteFloat(GAMEMODE:GetPhase())
		net.WriteFloat(GAMEMODE:GetRound()[1])
		net.WriteFloat(GAMEMODE:GetRound()[2])
		net.WriteFloat(time)
		net.WriteFloat(GAMEMODE.Ratio)
		net.WriteFloat(ROUND_WIN)
	net.Send(self)
end

function Player:SendLR()
	local num = 0
	
	for id, val in pairs(GAMEMODE.LastRequests) do
		net.Start("SendLastRequests")
			net.WriteString(val.ID)
			net.WriteString(val.Name)
			net.WriteFloat(num)
			net.WriteBool(val.CustomSpawns)
		net.Send(self)
		
		num = num + 1
	end
end

function Player:SendPing()
	if !self.LastPing then self.LastPing = CurTime() end
	if self.LastPing >= CurTime() then return end
	
	color = table.FindNext(colors, color)
	
	net.Start("WardenPings")
		net.WriteVector(self:GetEyeTraceNoCursor().HitPos)
		net.WriteVector(self:GetEyeTraceNoCursor().HitNormal)
		net.WriteColor(color)
	net.Broadcast()
	
	self.LastPing = CurTime() + 0.3
end

function Player:SendMaps()
	if GAMEMODE.NextMap then return end
	
	net.Start("UpdateMapVote")
		net.WriteTable(GAMEMODE.MapList)
	net.Send(self)
end
