
local LR = {}
LR.ID = "kf"
LR.Name = "Knife Fight"
LR.CustomSpawns = true

function LR:Init()
	local inmate, guard = GAMEMODE:GetLRPlayers()[1], GAMEMODE:GetLRPlayers()[2]
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
	
	guard:StripAmmo()
	guard:StripWeapons()
	guard:SetHealth(100)
	
	inmate:Give("weapon_knife")
	guard:Give("weapon_knife")
	
	inmate:Freeze(true)
	guard:Freeze(true)
	
	timer.Simple(3, function()
		
		guard:Freeze(false)
		inmate:Freeze(false)
	end)
end
GM:AddLR(LR)
