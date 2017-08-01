
local game = game
local timer = timer
local team = team
local player = player
local string = string
local math = math
local cvars = cvars

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

function GM:GetRoundTimeLimit()
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
	
	ROUND_WIN = 0
	
	game.CleanUpMap()
	
	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		if IsValid(ent) then
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
			if ((pl % GAMEMODE.Ratio) == 0) then
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
		ply:UnSpectate()
		ply:StripAmmo()
		ply:StripWeapons()
		
		if ply:IsDeadGuard() then
			ply:SetTeam(TEAM_GUARD)
		end
		
		if ply:IsDeadInmate() then
			ply:SetTeam(TEAM_INMATE)
		end
		
		ply:Give("weapon_hands")
		ply:Spawn()
		ply:SetMoveType(MOVETYPE_WALK)
		ply:SetCustomCollisionCheck(true)
		ply:CollisionRulesChanged()
		ply:Freeze(true)
		
		ply:ChatPrint("Round prep!")
		
		GAMEMODE.SwapGuard = {}
		GAMEMODE.SwapInmate = {}
	end
	
	GAMEMODE:SetPhase(ROUND_PREP)
	hook.Run("RoundPrep")
	
	if g < 1 then
		for _, ply in pairs(player.GetAll()) do
			ply:ChatPrint("Need a guard in order to play.")
			ply:Freeze(false)
		end
		
		return
	end
	
	timer.Simple(5, function()
		GAMEMODE:SetPhase(ROUND_PLAY)
		GAMEMODE:SetRoundTime(CurTime())
		hook.Run("RoundStart")
		
		GAMEMODE:AddLogs("ROUND " .. GAMEMODE:GetRound()[1] .. " START.")
		GAMEMODE:AddRound()
		
		for _, ply in pairs(player.GetAll()) do
			ply:Freeze(false)
			
			ply:ChatPrint("Round start!")
			ply:EmitSound("radio.letsgo")
		end
	end)
	
	timer.Simple(20, function()
		for _, ply in pairs(player.GetAll()) do
			ply:ChatPrint("Inmates can now talk.")
		end
		
		if GAMEMODE:CanLR() then
			GAMEMODE:PrepLR()
		end
	end)
end

local map = game.GetMap()
function GM:EndRound()
	if (GAMEMODE:GetPhase() == ROUND_END) then return end
	
	GAMEMODE:SetPhase(ROUND_END)
	hook.Run("RoundEnd", ROUND_WIN)
	
	GAMEMODE:AddLogs("ROUND " .. GAMEMODE:GetRound()[1] .. " END.")
	GAMEMODE:EndLR()
	
	if (ROUND_NUM == 1) then
		map = table.FindNext(GAMEMODE.MapList, game.GetMap())
	end
	
	if (ROUND_NUM > ROUND_LIMIT) then
		if !GAMEMODE.NextMap then 
			game.ConsoleCommand("changelevel " .. map .. " \n")
		end
		
		GAMEMODE:SaveLogs()
	end
	
	for _, ply in pairs(player.GetAll()) do
		ply:SetWarden(false)
		ply:SetLR(false)
		ply:ChatPrint("Round end!")
	end
	
	timer.Simple(5, function()
		GAMEMODE:StartRound()
	end)
end

function GM:ThinkRound()
	if (GAMEMODE:GetPhase() == ROUND_END) then return end
	
	local pl, g, p = #player.GetAll(), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)
	
	if (g < 1) and (p > 0) then
		if (GAMEMODE:GetPhase() != ROUND_WAIT) then
			for _, ply in pairs(player.GetAll()) do
				ply:ChatPrint("Need a guard in order to play.")
			end
			
			GAMEMODE:SetPhase(ROUND_WAIT)
		end
		
		if (GAMEMODE:GetPhase() == ROUND_WAIT) then
			if #GAMEMODE.SwapGuard > 0 then
				for key, ply in pairs(GAMEMODE.SwapGuard) do
					if IsValid(ply) then
						if g > 1 and ((pl % GAMEMODE.Ratio) == 0) then
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
						if ((pl % GAMEMODE.Ratio) != 0) then
							ply:SetTeam(TEAM_INMATE_DEAD)
							GAMEMODE.SwapInmate[key] = nil
						end
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
end
