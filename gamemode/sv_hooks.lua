local game = game
local timer = timer
local team = team
local player = player
local net = net
local util = util
local string = string
local math = math

local pairs = pairs

function GM:Initialize()
	GAMEMODE.MapList = {}
	GAMEMODE.SwapList = {}
	GAMEMODE.SwapGuard = {}
	GAMEMODE.SwapInmate = {}
	GAMEMODE.Logs = {}
	GAMEMODE.LRPos = {}
	
	file.CreateDir("jailbreak")
	file.CreateDir("jailbreak/logs")
	file.CreateDir("jailbreak/maps")
	
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

function GM:InitPostEntity()
	local maps, _ = file.Find("maps/*.bsp", "GAME")
	
	for k, v in pairs(maps) do
		v = string.Replace(v, ".bsp", "")
		
		GAMEMODE.MapList[k] = v
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

function GM:PlayerSelectSpawn( ply )
	local guards, prisoners = ents.FindByClass("info_player_counterterrorist"), ents.FindByClass("info_player_terrorist")
	
	if ply:IsGuard() or ply:IsDeadGuard() then
		for k, v in pairs(guards) do
			if GAMEMODE:IsSpawnpointSuitable(ply, v, false) then
				return v
			end
		end
	elseif ply:IsInmate() or ply:IsDeadInmate() then
		for k, v in pairs(prisoners) do
			if GAMEMODE:IsSpawnpointSuitable(ply, v, false) then
				return v
			end
		end
	else
		return table.Random(ents.FindByClass("info_player_counterterrorist"))
	end
end

function GM:PlayerInitialSpawn( ply )
	local pl = #player.GetAll()
	local g, p = team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD) or 0, team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD) or 0
	
	ply:SetModel("models/player/phoenix.mdl")
	
	ply:SendData()
	ply:SendLR()
	
	if GAMEMODE:GetPhase() == ROUND_PLAY then
		ply:SetTeam(TEAM_INMATE_DEAD)
		
		GAMEMODE:PlayerSpawnAsSpectator(ply)
	else
		ply:SetTeam(TEAM_INMATE)
		
		GAMEMODE:PlayerLoadout(ply)
	end
end

function GM:PlayerSpawn( ply )
	if !ply:IsSpec() then
		ply:UnSpectate()
		ply:SetupHands()
		
		GAMEMODE:PlayerLoadout(ply)
	else
		ply:StripWeapons()
	end
end

function GM:PlayerLoadout( ply )
	local model = team.GetModels(ply)
	
	ply:StripWeapons()
	ply:SetCustomCollisionCheck(true)
	ply:CollisionRulesChanged()
	ply:SetModel(model)
	
	for k, v in pairs(team.GetLoadout(ply)) do
		ply:Give(v)
	end
	
	ply:StripAmmo()
	
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
		
		ply:StripAmmo()
		ply:StripWeapons()
		
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		
		if GAMEMODE:CanLR() then
			GAMEMODE:PrepLR()
		end
	end
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
	
	ply:Spectate(OBS_MODE_ROAMING)
	
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(ply:GetModel())
	ragdoll:SetPos(ply:GetPos())
	ragdoll:SetAngles(ply:GetAngles())
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ragdoll:SetOwner(ply)
	
	net.Start("PlayerDeath")
		net.WriteFloat(1)
	net.Send(ply)
	
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
	
	ply:Spectate(OBS_MODE_IN_EYE)
end

function GM:PlayerUse(ply, ent)
	if !ply:IsGuard() and !ply:IsInmate() then return false end
	
	return true
end

function GM:KeyPress(ply, key)
	if ply:IsGuard() and ply:IsWarden() then
		if key == IN_ZOOM then
			net.Start("WardenPings")
				net.WriteVector(ply:GetEyeTraceNoCursor().HitPos)
				net.WriteVector(ply:GetEyeTraceNoCursor().HitNormal)
			net.Broadcast()
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
	
	if wep:GetClass() == "weapon_lr" and table.HasValue(GAMEMODE.ToolAccess, ply:SteamID()) then
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
	
	if ply:IsInmate() and ply:CanLR() then
		ply:SetLR(true)
		ply:SendLR()
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
	
	ply:SetTeam(new)
	ply:Spawn()
	
	GAMEMODE:OnPlayerChangedTeam(ply, old, new)
end

function GM:OnPlayerChangedTeam(ply, old, new)
	local msg = "error"
	
	if new == TEAM_GUARD then
		msg = ply:Nick() .. " swapped to guards."
	end
	
	if new == TEAM_INMATE then
		msg = ply:Nick() .. " swapped to inmate."
	end
	
	for _, pl in pairs(player.GetAll()) do
		pl:ChatPrint(msg)
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
