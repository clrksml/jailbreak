
local LR = {}
LR.ID = "warday"
LR.Name = "War Day"
LR.CustomSpawns = false

function LR:Init()
	local inmate, guard = GAMEMODE:GetLRPlayers()[1], GAMEMODE:GetLRPlayers()[2]
	
	local Primary = {
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
	
	local Secondary = {
		"weapon_deagle",
		"weapon_fiveseven",
		"weapon_glock",
		"weapon_p228",
		"weapon_usp",
	}
	
	for _, ent in pairs(ents.FindByClass("func_door")) do
		ent:Fire("Unlock", 0)
		ent:Fire("Open", 1)
	end
	
	for _, ply in pairs(player.GetAll()) do
		ply:StripWeapons()
		
		if ply:Team() == TEAM_INMATE or ply:Team() == TEAM_INMATE_DEAD then
			ply:SetTeam(TEAM_INMATE)
			ply:Spawn()
			
			ply:Give(table.Random(Primary))
			ply:Give(table.Random(Secondary))
		end
		
		if ply:Team() == TEAM_GUARD or ply:Team() == TEAM_GUARD_DEAD then
			ply:SetTeam(TEAM_GUARD)
			ply:Spawn()
			
			ply:Give(table.Random(Primary))
			ply:Give(table.Random(Secondary))
		end
	end
end
GM:AddLR(LR)
