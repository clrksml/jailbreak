
net.Receive("SendKeys", function(len, ply)
	local key, str = net.ReadString(), net.ReadString()
	
	ply:SetKey(key, str)
end)

net.Receive("VoteMap", function(len, ply)
	if GAMEMODE.NextMap then return end
	
	local num = tonumber(net.ReadFloat())
	
	if !ply.Vote then
		GAMEMODE.MapList[num][3] = GAMEMODE.MapList[num][3] + 1
		
		ply.Vote = num
	elseif ply.Vote != num then
		if GAMEMODE.MapList[ply.Vote][3] >= 1 then
			GAMEMODE.MapList[ply.Vote][3] = GAMEMODE.MapList[ply.Vote][3] - 1
		else
			GAMEMODE.MapList[ply.Vote][3] = 0
		end
		
		GAMEMODE.MapList[num][3] = GAMEMODE.MapList[num][3] + 1
		
		ply.Vote = num
	end
	
	net.Start("UpdateMapVote")
		net.WriteTable(GAMEMODE.MapList)
	net.Broadcast()
	
	if GAMEMODE:GetRoundTime() >= CurTime() + 35 then
		GAMEMODE:LoadNextMap()
	end
end)
