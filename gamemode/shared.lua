GM.Name		= "Jailbreak"
GM.Author	= "Clark"
GM.Website	= "www.HavocGamers.net"

DeriveGamemode("base")

TEAM_GUARD			= 1
TEAM_INMATE			= 2
TEAM_SPECTATOR		= 3
TEAM_GUARD_DEAD		= 4
TEAM_INMATE_DEAD	= 5

team.SetUp(TEAM_GUARD, "Guard", Color(53, 106, 160), false)
team.SetUp(TEAM_INMATE, "Inmate", Color(160, 54, 53), false)
team.SetUp(TEAM_SPECTATOR, "Spectator", Color(159, 164, 53), false)
team.SetUp(TEAM_GUARD_DEAD, "Dead Guard", Color(34, 38, 103), false)
team.SetUp(TEAM_INMATE_DEAD, "Dead Inmate", Color(103, 34, 38), false)

GM.Ratio = GetConVar("jb_ratio"):GetInt()

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
	if ply:IsGuard() then
		return table.Random(GAMEMODE.GuardModels)
	else
		return table.Random(GAMEMODE.InmateModels)
	end
end

function team.GetLoadout( ply )
	if ply:IsGuard() then
		return {table.Random(GAMEMODE.GuardPrimaryWeapons), table.Random(GAMEMODE.GuardSecondaryWeapons)}
	else
		return {table.Random(GAMEMODE.InmateWeapons)}
	end
end
