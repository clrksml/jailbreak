
local LR = {}
LR.ID = "freeday"
LR.Name = "Free Day"
LR.Info= "Inmates are free to roam without interuption."
LR.CustomSpawns = false

function LR:Init(inmate, guard)
	if SERVER then
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
				ply:ChatPrint(ply:GetPhrase("freeday"))
			end
		end)
	else
	end
end
GM:AddLR(LR)
