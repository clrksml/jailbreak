
local net = net
local team = team
local pairs = pairs

net.Receive("JB_SendKeys", function(len, ply)
	local key, str = net.ReadString(), net.ReadString()

	ply:SetKey(key, str)
end)

net.Receive("JB_VoteMap", function(len, ply)
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

	net.Start("JB_UpdateMapVote")
		net.WriteTable(GAMEMODE.MapList)
	net.Broadcast()

	if GAMEMODE:GetRoundTime() >= CurTime() + 35 then
		GAMEMODE:LoadNextMap()
	end
end)

net.Receive("JB_LastRequest", function(len, ply)
	if !ply.LastLR then ply.LastLR = 0 end
	if ply.LastLR > CurTime() then return end

	local lr, pl = net.ReadString(), net.ReadString()

	if ply:IsInmate() and ply:CanLR() then
		if lr and pl then
			for k, v in pairs(team.GetPlayers(TEAM_GUARD)) do
				if pl == v:UniqueID() then
					pl = v
				end
			end
			if IsValid(pl) and pl:IsPlayer() then
				for k, v in pairs(GAMEMODE.LastRequests) do
					if v.ID == lr then
						GAMEMODE:SetLRPlayers(ply, pl)

						net.Start("JB_LR")
							net.WriteInt(1, 32)
							net.WriteString(lr)
						net.Broadcast()

						GAMEMODE:StartLR(lr, pl)
						ply:SetLR(false)
					end
				end
			else
				ply:SetLR(true)
			end
		end
	end
end)

net.Receive("JB_Marker", function(len, ply)
	if ply:IsGuard() and ply:Alive() and ply:IsWarden() then
		local type = net.ReadInt(32)

		if type != 0 then
			ply:AddMarker(type)
		else
			ply:RemoveMarker()
		end
	end
end)

net.Receive("JB_SpawnProp", function(len, ply)
	if ply:IsGuard() and ply:Alive() and ply:IsWarden() then
		local type = net.ReadInt(32)

		if type != 0 then
			ply:SpawnProp(type)
		else
			ply:RemoveProp()
		end
	end
end)
