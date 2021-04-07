
local game = game
local team = team
local math = math
local hook = hook
local timer = timer
local cvars = cvars
local player = player
local string = string
local pairs = pairs

ROUND_PREP = 0
ROUND_PLAY = 1
ROUND_END = 2
ROUND_WAIT = 3
ROUND_PHASE = ROUND_WAIT
ROUND_NUM = 1
ROUND_TIME = 0
ROUND_WIN = 0
ROUND_LIMIT = GetConVar("jb_round_limit"):GetInt()
ROUND_TIMELIMIT = GetConVar("jb_time_limit"):GetInt()

cvars.AddChangeCallback("jb_round_limit", function( convar_name, value_old, value_new )
	ROUND_LIMIT = GetConVar("jb_round_limit"):GetInt()

	for _, ply in pairs(player.GetAll()) do
		ply:SendData()
	end
end)

cvars.AddChangeCallback("jb_time_limit", function( convar_name, value_old, value_new )
	ROUND_TIMELIMIT = GetConVar("jb_time_limit"):GetInt()

	for _, ply in pairs(player.GetAll()) do
		ply:SendData()
	end
end)

cvars.AddChangeCallback("jb_ratio", function( convar_name, value_old, value_new )
	GAMEMODE.Ratio = math.Round(GetConVar("jb_ratio"):GetInt())

	for _, ply in pairs(player.GetAll()) do
		ply:SendData()
	end
end)

function GM:GetPhase()
	return ROUND_PHASE
end

function GM:SetPhase( phase )
	ROUND_PHASE = phase

	for _, ply in pairs(player.GetAll()) do
		ply:SendData()
	end
end

function GM:GetRound()
	return { [1] = ROUND_NUM, [2] = ROUND_LIMIT }
end

function GM:AddRound()
	ROUND_NUM = ROUND_NUM + 1
end

function GM:GetRoundLimit()
	return ROUND_LIMIT
end

function GM:GetRoundTime()
	return ROUND_TIME
end

function GM:SetRoundTime( num )
	ROUND_TIME = num
end

function GM:StartRound()
	if GAMEMODE:GetPhase() == ROUND_PREP and GAMEMODE:GetPhase() == ROUND_PLAY then return end

	for _, ply in pairs(player.GetAll()) do
		if !ply:IsSpec() then
			ply:UnSpectate()
		end

		ply:RemoveAllItems()
	end

	ROUND_WIN = 0

	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		if IsValid(ent:GetOwner()) then
			ent:Remove()
		else
			local wep = ents.Create(ent:GetClass())
			wep:SetPos(ent:GetPos())
			wep:SetAngles(ent:GetAngles())
			ent:Remove()
			wep:Spawn()

			if IsValid(wep:GetPhysicsObject()) then
				wep:GetPhysicsObject():EnableMotion(false)
				wep:GetPhysicsObject():Sleep()
			end
		end
	end

	local pl, g, p = #player.GetAll(), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)

	for key, ply in pairs(GAMEMODE.SwapGuard) do
		if IsValid(ply) then
			if ((pl % GAMEMODE.Ratio) == 0) and ((game.MaxPlayers() / GAMEMODE.Ratio) > g) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_GUARD)
				GAMEMODE.SwapGuard[key] = nil
			end
		else
			GAMEMODE.SwapGuard[key] = nil
		end
	end

	for key, ply in pairs(GAMEMODE.SwapInmate) do
		if IsValid(ply) then
			GAMEMODE:PlayerJoinTeam(ply, TEAM_INMATE)
			GAMEMODE.SwapInmate[key] = nil
		else
			GAMEMODE.SwapInmate[key] = nil
		end
	end

	g, p = team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)

	for _, ply in pairs(player.GetAll()) do
		if !ply:IsSpec() then
			if ply:IsDeadGuard() then
				ply:SetTeam(TEAM_GUARD)
			end

			if ply:IsDeadInmate() then
				ply:SetTeam(TEAM_INMATE)
			end

			ply:Spawn()
			ply:SetMoveType(MOVETYPE_WALK)
			--ply:SetCustomCollisionCheck(true)
			--ply:CollisionRulesChanged()
			ply:Freeze(true)
			ply:SetKills(0)

			GAMEMODE:AddNotice(4, ply:GetPhrase("roundprep"), ply)

			GAMEMODE:PlayerLoadout(ply)
		end
	end

	GAMEMODE.SwapGuard = {}
	GAMEMODE.SwapInmate = {}

	GAMEMODE:SetPhase(ROUND_PREP)
	hook.Run("RoundPrep")

	if g < 1 then
		for _, ply in pairs(player.GetAll()) do
			ply:Freeze(false)
		end

		return
	end

	timer.Simple(5, function()
		if ((ROUND_LIMIT != 0) and (ROUND_NUM > ROUND_LIMIT)) then return end

		for _, ply in pairs(player.GetAll()) do
			if ply:IsGuard() and !ply:Alive() then
				ply:Spawn()
			end

			if ply:IsInmate() and !ply:Alive() then
				ply:Spawn()
			end

			GAMEMODE:PlayerLoadout(ply)

			if ply:IsInmate() and GAMEMODE.LastRequest == "zombie" then
				ply:SetModel("models/player/zombie_classic.mdl")
			end
		end
		
		if GAMEMODE.LastRequest != "" then
			GAMEMODE.LastRequest = ""
		end

		GAMEMODE:SetPhase(ROUND_PLAY)
		GAMEMODE:SetRoundTime(CurTime())
		hook.Run("RoundStart")

		GAMEMODE:AddLogs("ROUND " .. GAMEMODE:GetRound()[1] .. " START.")
		GAMEMODE:AddRound()

		for _, ply in pairs(player.GetAll()) do
			ply:Freeze(false)

			GAMEMODE:AddNotice(4, ply:GetPhrase("roundstart"), ply)

			if ply:IsGuard() then
				ply:EmitSound("radio.letsgo")
			end
		end
	end)

	timer.Simple(20, function()
		if ((ROUND_LIMIT != 0) and (ROUND_NUM > ROUND_LIMIT)) then return end

		for _, ply in pairs(player.GetAll()) do
			ply:ChatPrint(ply:GetPhrase("speak"))
		end

		if GAMEMODE:CanLR() then
			GAMEMODE:PrepLR()

			net.Start("JB_LR")
				net.WriteInt(0, 32)
			net.Broadcast()
		end
	end)
end

function GM:EndRound()
	if (GAMEMODE:GetPhase() == ROUND_END) then return end

	GAMEMODE:SetPhase(ROUND_END)
	hook.Run("RoundEnd", ROUND_WIN)

	GAMEMODE:AddLogs("ROUND " .. GAMEMODE:GetRound()[1] .. " END.")
	GAMEMODE:EndLR()

	net.Start("JB_LR")
		net.WriteInt(2, 32)
	net.Broadcast()

	if ((ROUND_LIMIT != 0) and (ROUND_NUM >= ROUND_LIMIT)) then
		if !GAMEMODE.NextMap then
			GAMEMODE:SetRoundTime(CurTime())

			net.Start("JB_DrawMapVote")
				net.WriteTable(GAMEMODE.MapList)
			net.Broadcast()

			timer.Simple(35, function()
				GAMEMODE:LoadNextMap()
			end)
		end

		GAMEMODE:SaveLogs()
	end

	timer.Simple(5, function()
		for _, ply in pairs(player.GetAll()) do
			ply:SetWarden(false)
			ply:SetLR(false)
			ply:SetGravity(1)
			ply:SetFrags(0)
			ply:SetDeaths(0)
			ply:UnSpectate()
			ply:RemoveAllItems()

			GAMEMODE:AddNotice(4, ply:GetPhrase("roundend"), ply)
		end

		game.CleanUpMap()

		GAMEMODE:StartRound()
	end)
end

function GM:ThinkRound()
	if (GAMEMODE:GetPhase() == ROUND_END) then return end

	local pl, g, p = #player.GetAll(), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)

	if (g < 1) and (p > 0) then
		if (GAMEMODE:GetPhase() != ROUND_WAIT) then
			for _, ply in pairs(player.GetAll()) do
				GAMEMODE:AddNotice(4, ply:GetPhrase("needguard"), ply)
			end

			GAMEMODE:SetPhase(ROUND_WAIT)
		end

		if (GAMEMODE:GetPhase() == ROUND_WAIT) then
			if #GAMEMODE.SwapGuard > 0 then
				for key, ply in pairs(GAMEMODE.SwapGuard) do
					if IsValid(ply) then
						if (g > 1) and ((pl % GAMEMODE.Ratio) == 0) and ((game.MaxPlayers() / GAMEMODE.Ratio) > g) then
							ply:SetTeam(TEAM_GUARD_DEAD)
							GAMEMODE.SwapGuard[key] = nil
						end
					else
						GAMEMODE.SwapInmate[key] = nil
					end
				end
			end

			if #GAMEMODE.SwapInmate > 0 then
				for key, ply in pairs(GAMEMODE.SwapInmate) do
					if IsValid(ply) then
						ply:SetTeam(TEAM_INMATE_DEAD)
						GAMEMODE.SwapInmate[key] = nil
					else
						GAMEMODE.SwapInmate[key] = nil
					end
				end
			end
			return
		end
	end

	if (g >= 1) and (p >= 1) and (GAMEMODE:GetPhase() == ROUND_WAIT) then
		GAMEMODE:StartRound()
	end

	g, p = team.NumPlayers(TEAM_GUARD), team.NumPlayers(TEAM_INMATE)

	if (pl > 1) and GAMEMODE:GetPhase() != ROUND_END and GAMEMODE:GetPhase() != ROUND_WAIT then
		if (g >= 1) and (p <= 0) then
			ROUND_WIN = 1

			GAMEMODE:EndRound()
		end

		if (g <= 0) and (p >= 1) then
			ROUND_WIN = 2

			GAMEMODE:EndRound()
		end

		if (GAMEMODE:GetRoundTime() + ROUND_TIMELIMIT) <= CurTime() then
			ROUND_WIN = 0

			GAMEMODE:EndRound()
		end
	end
	
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		if GAMEMODE.LastRequest == "zf" then
			for _, ply in pairs(player.GetAll()) do
				if !ply.Emit then ply.Emit = 0 end
				
				if ply:IsInmate() and ply.Emit > CurTime() then
					ply:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1,14) .. ".wav")
					
					ply.Emit = CurTime() +  math.random(5,30)
				end
			end
		end
	end

	if GAMEMODE.Markers and #GAMEMODE.Markers >= 1 and GAMEMODE.MarkerDuration > 0 then
		for key, val in pairs(GAMEMODE.Markers) do
			if val.Time < CurTime() then
				table.remove(GAMEMODE.Markers, key)
			end
		end
	end
end
