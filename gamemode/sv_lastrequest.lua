GM.LastRequest = ""
GM.LastRequests = {}

function GM:CanLR()
	if team.NumPlayers(TEAM_INMATE) == 1 then
		return true
	end
	
	return false
end

function GM:GetLastRequests()
	return self.LastRequests
end

function GM:GetLR()
	return self.LastRequest
end

function GM:AddLR(lr)
	self.LastRequests[#self.LastRequests + 1] = lr
end

function GM:PrepLR()
	local inmate = team.GetPlayers(TEAM_INMATE)
	
	if inmate and IsValid(inmate[1]) then
		inmate = inmate[1]
		
		inmate:ChatPrint(Format(inmate:GetPhrase("lastrequest"), inmate:GetKey("gm_showteam")))
		
		for _, ply in pairs(player.GetAll()) do
			ply:ChatPrint(Format(ply:GetPhrase("lastrequest2"), inmate:Nick()))
		end
	end
	
	local str = file.Read("data/jailbreak/maps/" .. game.GetMap() .. ".txt", "GAME")
	
	if str then
		local tbl = util.JSONToTable(str)
		
		if tbl then
			for name, val in pairs(tbl) do
				GAMEMODE.LRPos[name] = val
			end
		end
	end
end

function GM:StartLR( id )
	local inmate, guard = team.GetPlayers(TEAM_INMATE)[1], table.Random(team.GetPlayers(TEAM_GUARD))
	
	for k, v in pairs(GAMEMODE.LastRequests) do
		if v.ID == id then
			id = k
		end
	end
	
	self.LastRequest = self.LastRequests[id].ID
	
	self:SetLRPlayers(inmate, guard)
	
	for _, ply in pairs(player.GetAll()) do
		GAMEMODE:AddLogs(inmate:Nick() .. " has choosen " .. self.LastRequests[id].Name .. " as their last request.")
		
		ply:ChatPrint(Format(ply:GetPhrase("lastrequest3"), inmate:Nick(), self.LastRequests[id].Name))
		ply:SendData()
	end
	
	self.LastRequests[id]:Init()
	
	self:SetRoundTime(CurTime())
end

function GM:EndLR()
	self.LastRequest = ""
	
	if IsValid(self.inmate) and IsValid(self.guard) then
		for _, ply in pairs(player.GetAll()) do
			if self.inmate:Alive() then
				GAMEMODE:AddLogs(self.inmate:Nick() .. " beat " .. self.guard:Nick() .. ".")
				ply:ChatPrint(Format(ply:GetPhrase("lastrequest4"), self.inmate:Nick(), self.guard:Nick()))
			elseif self.guard:Alive() then
				GAMEMODE:AddLogs(self.guard:Nick() .. " beat " .. self.inmate:Nick() .. ".")
				ply:ChatPrint(Format(ply:GetPhrase("lastrequest4"), self.guard:Nick(), self.inmate:Nick()))
			end
		end
	end
	
	self.inmate = nil
	self.guard = nil
end

function GM:GetLRPlayers()
	return { [1] = self.inmate, [2] = self.guard }
end

function GM:SetLRPlayers( i, g )
	self.inmate = i
	self.guard = g
end
