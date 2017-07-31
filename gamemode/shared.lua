GM.Name		= "Jailbreak"
GM.Author	= "Clark"
GM.Website	= "127.0.0.1"

DeriveGamemode("base")

TEAM_GUARD			= 1
TEAM_INMATE			= 2
TEAM_GUARD_DEAD		= 3
TEAM_INMATE_DEAD	= 4
TEAM_SPECTATOR		= 5

team.SetUp(TEAM_GUARD, "Guard", Color(53, 106, 160), false)
team.SetUp(TEAM_INMATE, "Inmate", Color(160, 54, 53), false)
team.SetUp(TEAM_GUARD_DEAD, "Dead Guard", Color(34, 38, 103), false)
team.SetUp(TEAM_INMATE_DEAD, "Dead Inmate", Color(103, 34, 38), false)
team.SetUp(TEAM_SPECTATOR, "Spectator", Color(159, 164, 53), false)

function team.GetColors( ply )
	if ply:IsInmate() then
		return { [1] = Color(175, 59, 58), [2] = team.GetColor(ply:Team()) }
	elseif ply:IsGuard() then
		return { [1] = Color(58, 116, 175), [2] = team.GetColor(ply:Team()) }
	elseif ply:IsDeadInmate() then
		return { [1] = Color(118, 39, 43), [2] = team.GetColor(ply:Team()) }
	elseif ply:IsDeadGuard() then
		return { [1] = Color(39, 43, 118), [2] = team.GetColor(ply:Team()) }
	else
		return { [1] = Color(164, 160, 53), [2] = team.GetColor(ply:Team()) }
	end
end

function team.GetModels( ply )
	local Guards = {
		"models/player/urban.mdl",
		"models/player/swat.mdl",
		"models/player/gasmask.mdl",
		"models/player/riot.mdl",
	}
	
	local Inmates = {
		"models/player/arctic.mdl",
		"models/player/phoenix.mdl",
		"models/player/guerilla.mdl",
		"models/player/leet.mdl",
	}
	
	if ply:IsGuard() then
		return table.Random(Guards)
	else
		return table.Random(Inmates)
	end
end

function team.GetLoadout( ply )
	local GuardsRifle = {
		"weapon_ak47",
		"weapon_aug",
		"weapon_awp",
		"weapon_famas",
		"weapon_galil",
		"weapon_m249",
		"weapon_m4a1",
		"weapon_mac10",
		"weapon_mp5navy",
		"weapon_p90",
		"weapon_scout",
		"weapon_sg550",
		"weapon_sg552",
		"weapon_tmp",
		"weapon_ump45",
	}
	
	local GuardsPistol = {
		"weapon_deagle",
		"weapon_fiveseven",
		"weapon_glock",
		"weapon_p228",
		"weapon_usp",
	}
	
	local Inmates = {
		"weapon_hands"
	}
	
	if ply:IsGuard() then
		return {table.Random(GuardsRifle), table.Random(GuardsPistol)}
	else
		return {table.Random(Inmates)}
	end
end
