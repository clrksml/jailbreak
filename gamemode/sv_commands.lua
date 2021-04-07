
local chat = chat
local team = team
local game = game
local table = table
local string = string
local concommand = concommand
local pairs = pairs

concommand.Add("jb_team", function(ply, cmd, args)
	if !ply.LastChange then ply.LastChange = CurTime() end
	if ply.LastChange > CurTime() then return end
	if !args[1] then return end

	local TEAM = tonumber(args[1])

	local pl, g, p = #player.GetAll(), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)

	if ply:HasGuardBan() then
		ply:ChatPrint(ply:GetPhrase("guardban"))

		return false
	end

	ply.LastChange = CurTime() + 1

	if TEAM == TEAM_INMATE and !table.HasValue(GAMEMODE.SwapInmate, ply) then
		table.insert(GAMEMODE.SwapInmate, ply)
		ply:ChatPrint(Format(ply:GetPhrase("swaplist"), ply:GetPhrase("inmate")))
	elseif TEAM == TEAM_GUARD and !table.HasValue(GAMEMODE.SwapGuard, ply) then
		table.insert(GAMEMODE.SwapGuard, ply)
		ply:ChatPrint(Format(ply:GetPhrase("swaplist"), ply:GetPhrase("guard")))
	else
		GAMEMODE:PlayerJoinTeam(ply, TEAM_SPECTATOR)
		return
	end

	if GAMEMODE:GetPhase() == ROUND_WAIT then
		for key, ply in pairs(GAMEMODE.SwapGuard) do
			if (g == 0) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_GUARD)
				GAMEMODE.SwapGuard[key] = nil
			end

			if (g > 1) and ((pl % GAMEMODE.Ratio) == 0) and ((game.MaxPlayers() / GAMEMODE.Ratio) > g) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_GUARD)
				GAMEMODE.SwapGuard[key] = nil
			end
		end

		for key, ply in pairs(GAMEMODE.SwapInmate) do
			GAMEMODE:PlayerJoinTeam(ply, TEAM_INMATE)
			GAMEMODE.SwapInmate[key] = nil
		end
	end
end)

concommand.Add("jb_drop", function(ply, cmd, args)
	if !IsValid(ply:GetActiveWeapon()) then return end

	if ply:GetActiveWeapon():GetClass() != "weapon_hands" or ply:GetActiveWeapon():GetClass() != "weapon_fists" then
		local wep = ply:GetActiveWeapon()

		ply:GetActiveWeapon():PreDrop(ply)
		ply:DropWeapon(ply:GetActiveWeapon())
		wep:SetOwner(ply)
	end
end)

concommand.Add("jb_tp", function(ply, cmd, args)
	if ply:IsGuard() or ply:IsInmate() then
		ply:ThirdPerson()
	end
end)

concommand.Add("jb_language", function(ply, cmd, args)
	local language = args[1] or "english"

	for k, v in pairs(GAMEMODE:GetLanguages()) do
		if k == language or v.Alias == language then
			ply:SetNWString("lang", lang)
		end
	end
end)
