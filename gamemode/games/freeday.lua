
local LR = {}
LR.ID = "freeday"
LR.Name = "Free Day"
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
			ply:ChatPrint("This round is a FREEDAY.")
		end
	end)
end
GM:AddLR(LR)
