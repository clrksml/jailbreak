local game = game
local timer = timer
local team = team
local player = player
local net = net
local util = util
local string = string
local math = math
local ents = ents
local table = table
local file = file
local pairs = pairs

function GM:Initialize()
	GAMEMODE.MapList = {}
	GAMEMODE.SwapList = {}
	GAMEMODE.SwapGuard = {}
	GAMEMODE.SwapInmate = {}
	GAMEMODE.Logs = {}
	GAMEMODE.LRPos = {}
	GAMEMODE.SpawnPos = {}
	
	file.CreateDir("jailbreak")
	file.CreateDir("jailbreak/logs")
	file.CreateDir("jailbreak/maps")
	
	local str = file.Read("data/jailbreak/maps/" .. game.GetMap() .. ".txt", "GAME")
	
	if str then
		local tbl = util.JSONToTable(str)
		
		if tbl then
			for name, val in pairs(tbl) do
				if name == "ispawns" or name == "gspawns" then
					GAMEMODE.SpawnPos[name] = val
				else
					GAMEMODE.LRPos[name] = val
				end
			end
		end
	end
end

function GM:InitPostEntity()
	local maps, _ = file.Find("maps/*.bsp", "GAME")
	
	for k, v in pairs(maps) do
		if string.find(v, "ba_") or string.find(v, "jb_") then
			v = string.Replace(v, ".bsp", "")
			
			GAMEMODE.MapList[#GAMEMODE.MapList + 1] = { v, false, 0 }
		end
	end
	
	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		if IsValid(ent) then
			local wep = ents.Create(ent:GetClass())
			wep:SetPos(ent:GetPos())
			wep:SetAngles(ent:GetAngles())
			ent:Remove()
			wep:Spawn()
			wep:GetPhysicsObject():EnableMotion(false)
			wep:GetPhysicsObject():Sleep()
		end
	end
end

function GM:IsSpawnpointSuitable(pl, spawnpointent, bMakeSuitable)
	local Pos = spawnpointent
	
	if type(spawnpointent) == "Entity" then
		Pos = spawnpointent:GetPos()
	end
	
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )
	
	if ( pl:Team() == TEAM_SPECTATOR ) then return true end
	
	local Blockers = 0
	
	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v != pl && v:GetClass() == "player" && v:Alive() ) then
		
			Blockers = Blockers + 1
			
			if ( bMakeSuitable ) then
				v:Kill()
			end
			
		end
	end
	
	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true
end

function GM:PlayerSelectSpawn( ply )
	local guards, inmates = ents.FindByClass("info_player_counterterrorist"), ents.FindByClass("info_player_terrorist")
	
	if !GAMEMODE.CustomSpawns then
		if ply:IsGuard() or ply:IsDeadGuard() then
			for k, v in pairs(guards) do
				if GAMEMODE:IsSpawnpointSuitable(ply, v, false) then
					return v
				end
			end
		elseif ply:IsInmate() or ply:IsDeadInmate() then
			for k, v in pairs(inmates) do
				if GAMEMODE:IsSpawnpointSuitable(ply, v, false) then
					return v
				end
			end
		else
			return table.Random(ents.FindByClass("info_player_counterterrorist"))
		end
	else
		if ply:IsGuard() or ply:IsDeadGuard() then
			if GAMEMODE.SpawnPos['gspawns'] and #GAMEMODE.SpawnPos['gspawns'] >= (game.MaxPlayers() / GAMEMODE.Ratio)  then
				for k, v in pairs(GAMEMODE.SpawnPos['gspawns']) do
					if GAMEMODE:IsSpawnpointSuitable(ply, v.Pos, false) then
						ply:SetPos(v.Pos)
						ply:SetAngles(Angle(0, v.Ang.y, 0))
						ply:SetEyeAngles(Angle(0, v.Ang.y, 0))
						break
					end
				end
			else
				return table.Random(guards)
			end
		elseif ply:IsInmate() or ply:IsDeadInmate() then
			if GAMEMODE.SpawnPos['ispawns'] and #GAMEMODE.SpawnPos['ispawns'] >= game.MaxPlayers() then
				for k, v in pairs(GAMEMODE.SpawnPos['ispawns']) do
					if GAMEMODE:IsSpawnpointSuitable(ply, v.Pos, false) then
						ply:SetPos(v.Pos)
						ply:SetAngles(Angle(0, v.Ang.y, 0))
						ply:SetEyeAngles(Angle(0, v.Ang.y, 0))
						break
					end
				end
			else
				return table.Random(inmates)
			end
		else
			return table.Random(guards)
		end
	end
end

function GM:PlayerInitialSpawn( ply )
	local pl = #player.GetAll()
	local g, p = team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD) or 0, team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD) or 0
	
	ply:SetModel("models/player/phoenix.mdl")
	
	ply:SendData()
	ply:SendLR()
	ply:SendMaps()
	ply:RemoveAllItems()
	
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		ply:SetTeam(TEAM_INMATE_DEAD)
		
		GAMEMODE:PlayerSpawnAsSpectator(ply)
	else
		ply:SetTeam(TEAM_INMATE)
		
		GAMEMODE:PlayerLoadout(ply)
	end
	
	ply:ChatPrint(Format(ply:GetKey("gm_showspare"), ply:GetPhrase("swapteam")))
end

function GM:PlayerSpawn( ply )
	if !ply:IsSpec() then
		ply:UnSpectate()
		ply:SetupHands()
	end
	
	ply:RemoveAllItems()
end

function GM:PlayerLoadout( ply )
	if ply:IsSpec() then return end
	
	ply:SetCustomCollisionCheck(true)
	ply:SetCanZoom(false)
	ply:CollisionRulesChanged()
	ply:SetModel(team.GetModels(ply))
	ply:RemoveAllItems()
	ply:Give("weapon_hands")
	ply:SelectWeapon("weapons_hands")
	
	if GAMEMODE.StarterWeapons then
		for k, v in SortedPairs(team.GetLoadout(ply), true) do
			ply:Give(v)
			ply:SelectWeapon(v)
		end
	end
	
	for k, wep in pairs(ply:GetWeapons()) do
		if wep:IsPrimary() or wep:IsSecondary() then
			ply:GiveAmmo(wep:GetMaxClip1() * 3, wep:GetPrimaryAmmoType(), true)
		end
	end
end

function GM:PlayerShouldTakeDamage( ply, att ) 
	if IsValid(ply) and IsValid(att) then
		if ply:IsPlayer() and att:IsPlayer() then
			if ply:IsGuard() or ply:IsInmate() and att:IsGuard() or att:IsInmate() then
				if ply:Team() == att:Team() then
					return false
				end
			end
		end
	end
	
	return true
end

function GM:PlayerDeath( ply )
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		if ply:IsGuard() then
			ply:SetTeam(TEAM_GUARD_DEAD)
		elseif ply:IsInmate() then
			ply:SetTeam(TEAM_INMATE_DEAD)
		end
		
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		
		if GAMEMODE:CanLR() then
			GAMEMODE:PrepLR()
		end
	end
	
	ply:RemoveAllItems()
end

function GM:PlayerDisconnected( ply )
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		if GAMEMODE:CanLR() then
			GAMEMODE:PrepLR()
		end
	end
end

function GM:DoPlayerDeath( ply, att, dmg )
	local players = GAMEMODE:GetPlayers()
	local choice = table.GetFirstValue(players)
	local g, p = team.NumPlayers(TEAM_GUARD), team.NumPlayers(TEAM_INMATE)
	
	for _, wep in pairs(ply:GetWeapons()) do
		wep:PreDrop(ply)
	end
	
	ply:CreateRagdoll()
	
	net.Start("PlayerDeath")
	net.Send(ply)
	
	ply:Spectate(OBS_MODE_ROAMING)
	
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		if IsValid(att) then
			if att:IsPlayer() then
				if ply == att then
					GAMEMODE:AddLogs(ply:Nick() .. " suicided.")
				else
					GAMEMODE:AddLogs(ply:Nick() .. " was killed by " .. att:Nick() .. ".")
				end
			else
				GAMEMODE:AddLogs(ply:Nick() .. " was killed by [world].")
			end
		end
	end
	
	if g + p <= 1 then
		GAMEMODE:EndRound()
	end
end

function GM:PlayerDeathThink( ply )
	return false
end

function GM:PlayerDeathSound( ply )
	if ply:IsInmate() then
		ply:EmitSound("vo/npc/male01/pain0" .. math.random(1,9) .. ".wav")
	end
	
	if ply:IsGuard() then
		ply:EmitSound("npc/metropolice/knockout2.wav")
	end
	
	return true
end

function GM:Think()
	GAMEMODE:ThinkRound()
end

function GM:PlayerSpawnAsSpectator( ply )
	local players = GAMEMODE:GetPlayers()
	local choice = table.GetFirstValue(players)
	
	if #players > 0 then
		ply:SpectateEntity(players[1])
		ply:Spectate(OBS_MODE_IN_EYE)
	else
		ply:Spectate(OBS_MODE_ROAMING)
	end
	
	ply:SetMoveType(MOVETYPE_NOCLIP)
end

function GM:PlayerUse(ply, ent)
	if !ply:IsGuard() and !ply:IsInmate() then return false end
	
	return true
end

function GM:KeyPress(ply, key)
	if ply:IsGuard() and ply:IsWarden() then
		if key == IN_ZOOM then
			ply:SendPing()
		end
	end
	
	if ply:IsGuard() then
		if key == IN_SPEED then
			if ply:GetWalkSpeed() <= 225 then
				ply:SetWalkSpeed(225)
			else
				ply:SetWalkSpeed(200)
			end
		end
	end
	
	if GAMEMODE:GetPhase() != 1 then return end
	
	if ply:IsDeadInmate() or ply:IsDeadGuard() or ply:IsSpec() then
		local players = GAMEMODE:GetPlayers()
		local choice, mode = ply:GetObserverTarget(), ply:GetObserverMode() 
		
		if !players then return end
		
		if key == IN_ATTACK then
			choice = table.FindNext(players, choice)
			
			ply:SpectateEntity(choice)
		end
		
		if key == IN_ATTACK2 then
			choice = table.FindPrev(players, choice)
			
			ply:SpectateEntity(choice)
		end
		
		if key == IN_JUMP then
			ply:Spectate(OBS_MODE_ROAMING)
		end
		
		if key == IN_DUCK then
			ply:Spectate(OBS_MODE_CHASE)
		end
		
		if key == IN_RELOAD then
			ply:Spectate(OBS_MODE_IN_EYE)
		end
	end
end

function GM:KeyRelease(ply, key)
	if ply:IsGuard() then
		if key == IN_SPEED then
			if ply:GetWalkSpeed() <= 225 then
				ply:SetWalkSpeed(225)
			else
				ply:SetWalkSpeed(200)
			end
		end
	end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	if !IsValid(ply) or !IsValid(wep) then return end
	if !ply:IsGuard() and !ply:IsInmate() then return false end
	
	if wep:GetClass() == "weapon_tool" and table.HasValue(GAMEMODE.ToolAccess, ply:SteamID()) then
		ply:SendLR()
		return true
	end
	
	if GAMEMODE:GetLR() != "" then
		if ply == GAMEMODE.guard or ply == GAMEMODE.inmate then
			return true
		end
		
		return false
	end
	
	if wep:IsPrimary() then
		if ply:HasPrimary() then
			return false
		else
			return true
		end
	end
	
	if wep:IsSecondary() then
		if ply:HasSecondary() then
			return false
		else
			return true
		end
	end
	
	if wep:IsMelee() then
		if ply:HasMelee() then
			return false
		else
			return true
		end
	end
	
	if wep:IsMisc() then
		if ply:HasMisc() then
			return false
		else
			return true
		end
	end
	
	return false
end

function GM:ShowHelp( ply )
	ply:ConCommand("jb_pickteam")
end

function GM:ShowTeam( ply )
	if GAMEMODE:GetPhase() != ROUND_PLAY then return end
	
	if ply:IsGuard() then
		GAMEMODE:SelectWarden(ply)
	end
	
	if ply:IsInmate() then
		if ply:CanLR() then
			ply:SetLR(true)
			ply:SendLR()
		else
			ply:ChatPrint(ply:GetPhrase("needwarden2"))
		end
	end
end

function GM:ShowSpare1( ply )
end

function GM:ShowSpare2( ply )
	ply:SendLua([[GAMEMODE.ShowHelpText = !GAMEMODE.ShowHelpText]])
end

function GM:GetPlayers()
	local players = {}
	
	for _, ply in pairs(player.GetAll()) do
		if ply:IsGuard() or ply:IsInmate() then
			table.insert(players, ply)
		end
	end
	
	return players
end

function GM:PlayerCanHearPlayersVoice( list, talk )
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		if talk:IsDeadInmate() or talk:IsDeadGuard() then
			if !list:IsDeadInmate() or !list:IsDeadGuard() then
				return false
			end
		end
		
		if (GAMEMODE:GetRoundTime() + 20) <= CurTime() then
			if !talk:IsGuard() then
				return false
			end
		end
		
		return true
	end
	
	return true
end

function GM:PlayerJoinTeam(ply, new)
	local old = ply:Team()
	
	if ply:IsWarden() then
		ply:SetLR(false)
		ply:SetWarden(false)
	end
	
	ply:SetTeam(new)
	ply:Spawn()
	
	if ply:IsSpec() then
		GAMEMODE:PlayerSpawnAsSpectator( ply )
	end
	
	GAMEMODE:OnPlayerChangedTeam(ply, old, new)
end

function GM:OnPlayerChangedTeam(ply, old, new)
	local str = ""
	
	if new == TEAM_GUARD or new == TEAM_GUARD_DEAD then
		str = ply:GetPhrase("guard")
	elseif new == TEAM_INMATE or new == TEAM_INMATE_DEAD then
		str = ply:GetPhrase("inmate")
	else
		str = ply:GetPhrase("spectator")
	end
	
	str = Format(ply:GetPhrase("jointeam"), ply:Nick(), str)
	
	for _, pl in pairs(player.GetAll()) do
		pl:ChatPrint(str)
	end
end

function GM:ScalePlayerDamage(ply, hit, dmg)
	local att = dmg:GetAttacker()
	
	if hit == HITGROUP_HEAD then
		dmg:ScaleDamage(2)
	else
		dmg:ScaleDamage(1)
	end
	
	if IsValid(att) and att:IsPlayer() then
		GAMEMODE:AddLogs(att:Nick() .. " damaged " .. ply:Nick() .. " for " .. dmg:GetDamage())
	end
end

function GM:AddLogs( str )
	if GAMEMODE:GetPhase() != ROUND_PLAY then return end
	
	if !GAMEMODE.Logs then
		GAMEMODE.Logs = {}
	end
	
	local time = string.ToMinutesSeconds(CurTime() - GAMEMODE:GetRoundTime())
	
	for _, ply in pairs(player.GetAll()) do
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			ply:PrintMessage(HUD_PRINTCONSOLE, "[" .. time .. "] " .. str)
		end
	end
	
	table.insert(GAMEMODE.Logs, "[" .. time .. "] " .. str)
end

function GM:SaveLogs()
	local str = ""
	
	for _, txt in pairs(GAMEMODE.Logs) do
		str = str .. txt .. "\n"
	end
	
	file.Write("jailbreak/logs/" .. os.date("%b_%d_%Y_%H_%M") .. ".txt", str)
end

function GM:LoadNextMap()
	if GAMEMODE.NextMap then return end
	
	local h, c = 0, 0
	for k, v in RandomPairs(GAMEMODE.MapList) do
		if tonumber(v[3]) >= tonumber(h) then
			h = tonumber(v[3])
			c = k
		end
	end
	
	net.Start("MapWinner")
		net.WriteTable(GAMEMODE.MapList[c])
	net.Broadcast()
	
	for k, v in pairs(player.GetAll()) do
		if GAMEMODE.MapList[c][3] <= 0 then
			v:ChatPrint(GAMEMODE.MapList[c][1] .. " won (appears everyone forgot to vote)!")
		else
			v:ChatPrint(GAMEMODE.MapList[c][1] .. " won with " .. GAMEMODE.MapList[c][3] .. "/" .. #player.GetAll() .. "!")
		end
		v:ChatPrint("Server changing level to " .. GAMEMODE.MapList[c][1] .. ".")
	end
	
	timer.Simple(3.1, function()
		game.ConsoleCommand("changelevel " .. GAMEMODE.MapList[c][1] .. "\n")
	end)
end
