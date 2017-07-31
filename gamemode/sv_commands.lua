local concommand = concommand
local string = string
local chat = chat

concommand.Add("jb_lr", function(ply, cmd, args)
	if !ply.LastLR then ply.LastLR = CurTime() end
	if ply.LastLR > CurTime() then return end
	
	local lr = args[1]
	
	if ply:IsInmate() and ply:CanLR() then
		if lr then
			for k, v in pairs(GAMEMODE.LastRequests) do
				if v.ID == lr then
					GAMEMODE:StartLR(lr)
					ply:SetLR(false)
				end
			end
		end
	end
	
	ply.LastLR = CurTime() + 5
end)

concommand.Add("jb_team", function(ply, cmd, args)
	if !ply.LastChange then ply.LastChange = CurTime() end
	if ply.LastChange > CurTime() then return end
	
	local pl, g, p = #player.GetAll(), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD), team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)
	
	if ply:IsGuard() or ply:IsDeadGuard() and !table.HasValue(GAMEMODE.SwapInmate, ply) then
		table.insert(GAMEMODE.SwapInmate, ply)
		ply:ChatPrint("Added to inmate swap list.")
	elseif ply:IsInmate() or ply:IsDeadInmate() and !table.HasValue(GAMEMODE.SwapGuard, ply) then
		table.insert(GAMEMODE.SwapGuard, ply)
		ply:ChatPrint("Added to guard swap list.")
	end
	
	if GAMEMODE:GetPhase() == ROUND_WAIT then
		for key, ply in pairs(GAMEMODE.SwapGuard) do
			if (g == 0) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_GUARD)
				GAMEMODE.SwapGuard[key] = nil
			end
			
			if (g > 1) and ((pl % GAMEMODE.Ratio) == 0) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_GUARD)
				GAMEMODE.SwapGuard[key] = nil
			end
		end
		
		for key, ply in pairs(GAMEMODE.SwapInmate) do
			if ((pl % GAMEMODE.Ratio) != 0) then
				GAMEMODE:PlayerJoinTeam(ply, TEAM_INMATE)
				GAMEMODE.SwapInmate[key] = nil
			end
		end
	end
	
	ply.LastChange = CurTime() + 5
end)

concommand.Add("jb_drop", function(ply, cmd, args)
	if !IsValid(ply:GetActiveWeapon()) then return end
	
	if ply:GetActiveWeapon():GetClass() != "weapon_hands" then
		local wep = ply:GetActiveWeapon()
		
		ply:RemoveAmmo(ply:GetAmmoCount(wep:GetPrimaryAmmoType()), wep:GetPrimaryAmmoType())
		ply:DropWeapon(ply:GetActiveWeapon())
		wep:SetOwner(ply)
	end
end)
