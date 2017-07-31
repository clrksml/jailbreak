local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

local net = net

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
		net.Send(self)
		
		num = num + 1
	end
end
