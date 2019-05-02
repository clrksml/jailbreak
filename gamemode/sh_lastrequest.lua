
local team = team
local util = util
local file = file
local game = game
local pairs = pairs
local Format = Format

GM.LastRequest = ""
GM.LastRequests = {}

function GM:CanLR()
	if team.NumPlayers(TEAM_INMATE) == 1 and team.NumPlayers(TEAM_GUARD) >= 0 then
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

	if SERVER then
		if inmate and IsValid(inmate[1]) then
			inmate = inmate[1]

			inmate:ChatPrint(Format(inmate:GetPhrase("lastrequest"), inmate:GetKey("gm_showteam")))

			for _, ply in pairs(player.GetAll()) do
				if ply != inmate then 
					ply:ChatPrint(Format(ply:GetPhrase("lastrequest2"), inmate:Nick()))
				end
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
end

function GM:StartLR( id, guard )
	local inmate = team.GetPlayers(TEAM_INMATE)[1]

	for k, v in pairs(GAMEMODE.LastRequests) do
		if v.ID == id then
			id = k
		end
	end

	self.LastRequest = self.LastRequests[id].ID

	if SERVER then
		for _, ply in pairs(player.GetAll()) do
			GAMEMODE:AddLogs(inmate:Nick() .. " has choosen " .. self.LastRequests[id].Name .. " as their last request.")

			ply:ChatPrint(Format(ply:GetPhrase("lastrequest3"), inmate:Nick(), self.LastRequests[id].Name))
			ply:SendData()

			GAMEMODE:AddNotice(4, Format(ply:GetPhrase("lastrequest3"), inmate:Nick(), self.LastRequests[id].Name), ply)
		end
		self:SetRoundTime(CurTime())
	end

	self.LastRequests[id]:Init(inmate, guard)
end

function GM:EndLR()
	if SERVER then
		if IsValid(self.inmate) and IsValid(self.guard) then
			for _, ply in pairs(player.GetAll()) do
				if self.inmate:Alive() then
					GAMEMODE:AddLogs(self.inmate:Nick() .. " beat " .. self.guard:Nick() .. ".")
					GAMEMODE:AddNotice(4, Format(ply:GetPhrase("lastrequest4"), self.inmate:Nick(), self.guard:Nick()), ply)
				elseif self.guard:Alive() then
					GAMEMODE:AddLogs(self.guard:Nick() .. " beat " .. self.inmate:Nick() .. ".")
					GAMEMODE:AddNotice(4, Format(ply:GetPhrase("lastrequest4"), self.guard:Nick(), self.inmate:Nick()), ply)
				end
			end
		end

		self.inmate = nil
		self.guard = nil
	end
end

function GM:GetLRPlayers()
	return { [1] = self.inmate, [2] = self.guard }
end

function GM:SetLRPlayers( i, g )
	self.inmate = i
	self.guard = g

	if SERVER then
		i:SetLR(true)
		g:SetLR(true)
	end
end
