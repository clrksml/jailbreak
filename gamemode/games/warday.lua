
local LR = {}
LR.ID = "warday"
LR.Name = "War Day"
LR.CustomSpawns = false

function LR:Init()
	local inmate, guard = GAMEMODE:GetLRPlayers()[1], GAMEMODE:GetLRPlayers()[2]
	
	timer.Simple(3, function()
		inmate:KillSilent()
		GAMEMODE:EndRound()
	end)
	
	timer.Simple(11, function()
		for _, ent in pairs(ents.FindByClass("func_door")) do
			ent:Fire("Unlock", 0)
			ent:Fire("Open", 1)
		end
		
		for _, ply in pairs(player.GetAll()) do
			ply:StripWeapons()
			
			if ply:Team() == TEAM_INMATE or ply:Team() == TEAM_INMATE_DEAD then
				ply:SetTeam(TEAM_INMATE)
				ply:Spawn()
				
				ply:Give(table.Random(GAMEMODE.GuardPrimaryWeapons))
				ply:Give(table.Random(GAMEMODE.GuardSecondaryWeapons))
			end
			
			if ply:Team() == TEAM_GUARD or ply:Team() == TEAM_GUARD_DEAD then
				ply:SetTeam(TEAM_GUARD)
				ply:Spawn()
				
				ply:Give(table.Random(GAMEMODE.GuardPrimaryWeapons))
				ply:Give(table.Random(GAMEMODE.GuardSecondaryWeapons))
			end
			
			ply:ChatPrint(ply:GetPhrase("warday"))
		end
	end)
end
GM:AddLR(LR)
