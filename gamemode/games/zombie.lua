
local LR = {}
LR.ID = "zombie"
LR.Name = "Zombie day"
LR.Info= "Inmates are turned into zombies."
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
				ply:StripWeapons()

				if ply:IsInmate() then
					ply:SetHealth(300)
					ply:Give("weapon_knife")
					ply:Give("weapons_hands")
				end

				if ply:IsGuard() then
					ply:Give(table.Random(GAMEMODE.GuardPrimaryWeapons))
					ply:Give(table.Random(GAMEMODE.GuardSecondaryWeapons))
				end
				ply:ChatPrint(ply:GetPhrase("zombie"))
			end
		end)
	else
	end
end
GM:AddLR(LR)