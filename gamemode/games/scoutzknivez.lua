
local LR = {}
LR.ID = "scoutzknivez"
LR.Name = "Scoutz Knivez"
LR.Info= "Kill your opponent in low gravity with either a scout or a knife."
LR.CustomSpawns = true
LR.Guard = true

function LR:Init(inmate, guard)
	if SERVER then
		local iPos, iAng, gPos, gAng = Vector(0, 0, 0), Angle(0, 0, 0), Vector(0, 0, 0), Angle(0, 0, 0)

		if GAMEMODE.LRPos[LR.ID] then
			for key, val in pairs(GAMEMODE.LRPos[LR.ID]) do
				if key == 1 then
					gPos, gAng = val.Pos, val.Ang
				else
					iPos, iAng = val.Pos, val.Ang
				end
			end
		else
			for _, ply in pairs(GAMEMODE:GetLRPlayers()) do
				if ply:IsGuard() then
					for k, v in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
						if GAMEMODE:IsSpawnpointSuitable(ply, v, false) and gPos == Vector(0, 0, 0) then
							gPos = v:GetPos()
							gAng = v:GetAngles()
						end
					end
				else
					for k, v in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
						if GAMEMODE:IsSpawnpointSuitable(ply, v, false) and iPos == Vector(0, 0, 0) then
							iPos = v:GetPos()
							iAng = v:GetAngles()
						end
					end
				end
			end
		end

		inmate:SetPos(iPos)
		inmate:SetAngles(iAng)
		inmate:SetEyeAngles(iAng)

		guard:SetPos(gPos)
		guard:SetAngles(gAng)
		guard:SetEyeAngles(gAng)

		inmate:StripAmmo()
		inmate:StripWeapons()
		inmate:SetHealth(100)
		inmate:SetGravity(0.5)

		guard:StripAmmo()
		guard:StripWeapons()
		guard:SetHealth(100)
		guard:SetGravity(0.5)

		inmate:Freeze(true)
		guard:Freeze(true)

		timer.Create("countdown", 1, 5, function()
			if timer.RepsLeft("countdown") == 0 then
				timer.Destroy("countdown")

				guard:Freeze(false)
				inmate:Freeze(false)
			else
				inmate:Freeze(true)
				guard:Freeze(true)

				inmate:Give("weapon_scout")
				inmate:Give("weapon_knife")
				inmate:SelectWeapon("weapon_knife")
				guard:Give("weapon_scout")
				guard:Give("weapon_knife")
				guard:SelectWeapon("weapon_knife")

				inmate:ChatPrint(timer.RepsLeft("countdown"))
				guard:ChatPrint(timer.RepsLeft("countdown"))
			end
		end)
	else
	end
end
GM:AddLR(LR)
