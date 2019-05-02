
local LR = {}
LR.ID = "race"
LR.Name = "Race"
LR.Info= "Race to the bleeping deagle to live."
LR.CustomSpawns = true
LR.Guard = true

function LR:Init(inmate, guard)
	if SERVER then
		local iPos, iAng, gPos, gAng = Vector(0, 0, 0), Angle(0, 0, 0), Vector(0, 0, 0), Angle(0, 0, 0)

		for _, ent in pairs(ents.FindByClass("weapon_*")) do
			if IsValid(ent) then
				ent:Remove()
			end
		end

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

			for _, ent in pairs(ents.FindByClass("func_door")) do
				ent:Fire("Unlock", 0)
				ent:Fire("Open", 1)
			end
		end

		for k, v in RandomPairs(ents.FindByClass("info_player_terrorist")) do
			ePos = v:GetPos()
			eAng = v:GetAngles()
			break
		end

		local ent = ents.Create("weapon_deagle")
		ent:SetPos(ePos)
		ent:SetAngles(eAng)
		ent:SetOwner(nil)
		ent:Spawn()

		inmate:SetPos(iPos)
		inmate:SetAngles(iAng)
		inmate:SetEyeAngles(iAng)

		guard:SetPos(gPos)
		guard:SetAngles(gAng)
		guard:SetEyeAngles(gAng)

		inmate:StripAmmo()
		inmate:StripWeapons()
		inmate:SetHealth(100)

		guard:StripAmmo()
		guard:StripWeapons()
		guard:SetHealth(100)

		inmate:Freeze(true)
		guard:Freeze(true)

		timer.Create("blip", 5, 0, function()
			if IsValid(ent) then
				if IsValid(ent:GetOwner()) then
					timer.Destroy("blip")

					if ent:GetOwner() == inmate then
						guard:Kill()
					else
						inmate:Kill()
					end
				end

				ent:EmitSound("buttons/blip2.wav", ent:GetPos(), 25, 100, 1, 0)
			end
		end)

		timer.Simple(3, function()
			guard:Freeze(false)
			inmate:Freeze(false)

			guard:ChatPrint(guard:GetPhrase("race"))
			inmate:ChatPrint(inmate:GetPhrase("race"))
		end)
	else
	end
end
GM:AddLR(LR)
