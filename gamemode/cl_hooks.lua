local surface = surface
local team = team
local math = math
local surface = surface
local string = string

function GM:InitPostEntity()
	GAMEMODE.ShowScoreBoard = false
	GAMEMODE.ShowHelpText = false
	GAMEMODE.LastRequests = {}
	LocalPlayer().LastWeapon = CurTime()
end

function GM:HUDShouldDraw( str )
	if (str == "CHudHealth") or (str == "CHudBattery") or (str == "CHudWeaponSelection") or (str == "CHudAmmo") or (str == "CHudSecondaryAmmo") or (str == "CHudZoom") or (str == "CHudPoisonDamageIndicator") then
		return false
	end
	
	return true
end

function GM:HUDPaint()
	if !IsValid(LocalPlayer()) then return end
	if !GAMEMODE.ShouldDrawHUD then return end
	
	for hud, bool in pairs(GAMEMODE.ShouldDrawHUD) do
		if hud == "hud" and bool == true then
			GAMEMODE:DrawHUD()
		elseif hud == "pid" and bool == true then
			GAMEMODE:DrawPID()
		elseif hud == "ammo" and bool == true then
			GAMEMODE:DrawAmmo()
		elseif hud == "weapon" and bool == true then
			GAMEMODE:DrawWeaponSelection()
		elseif hud == "spectator" and bool == true then
			GAMEMODE:DrawSpectator()
		elseif hud == "lr" and bool == true then
			GAMEMODE:DrawLR()
		elseif hud == "help" and bool == true then
			GAMEMODE:DrawHelp()
		end
	end
end

function GM:PostDrawTranslucentRenderables()
	GAMEMODE:DrawPings()
end

function GM:DrawHUD()
	if !GAMEMODE.RoundStartTime then return end
	
	local function phasetotext( num )
		if num == 0 then
			return "Prepping"
		elseif num == 1 then
			return "Playing"
		elseif num == 2 then
			return "Ending"
		elseif num == 3 then
			return "Waiting"
		end
	end
	
	local x, y = 2, 2
	local x2, y2 = ScrW() - 127, 2
	local _phase, _team, _health, _round, _time, _warden = GAMEMODE.Phase, team.GetName(LocalPlayer():Team()), LocalPlayer():Health(), GAMEMODE.Round .. "/" .. GAMEMODE.MaxRounds, math.Round((GAMEMODE.RoundStartTime + GAMEMODE.RoundTimeLimit) - CurTime()), GAMEMODE:GetWarden()
	local _num = 140
	
	if GAMEMODE.RoundTimeLimit > 20 then
		_num = 6.42
		_num = _time / _num
	else
		_num = _num / GAMEMODE.RoundTimeLimit
		_num = _time * _num
	end
	
	if type(_warden) == "Player" then
		_warden = _warden:Nick()
	end
	
	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
	surface.DrawGradient(x, y, math.Clamp(1, _health * 1.4, 125), 24, 1, Color(207, 57, 58), Color(196, 48, 49))
	surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "HP " .. _health)
	
	y = y + 26
	
	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
	surface.DrawGradient(x, y, math.Clamp(1, GAMEMODE.Round * 9.34, 140), 24, 1, Color(230, 126, 34), Color(211, 84, 0))
	surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "Rnd " .. _round)
	
	y = y + 26
	
	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
	
	if GAMEMODE.Phase == 3 then
		surface.DrawGradient(x, y, 140, 24, 1, Color(155, 89, 182), Color(142, 68, 173))
		surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "Waiting")
	else
		surface.DrawGradient(x, y, math.Clamp(1, _num, 140), 24, 1, Color(155, 89, 182), Color(142, 68, 173))
		surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, string.ToMinutesSeconds(_time))
	end
	y = y + 26
	
	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
	surface.DrawGradient(x, y, 140, 24, 1, Color(26, 188, 156), Color(22, 160, 133))
	surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, _warden)
end

function GM:DrawPID()
	local ent = LocalPlayer():GetEyeTrace().Entity
	
	if ent:IsValid() and ent:IsPlayer() then
		if ent:IsGuard() or ent:IsInmate() then
			surface.SetFont("qsm")
			
			local x, y, color = ScrW() / 2, ScrH() / 2, team.GetColors(ent)
			local w, h = surface.GetTextSize(ent:GetName())
			
			y = y + h
			
			surface.DrawSentence("qsm", color[1], x - (w / 2), y, ent:GetName())
			surface.DrawSentence("qsm", color[2], x - (w / 2) + 1, y + 1, ent:GetName())
			
			w, h = surface.GetTextSize(ent:Health() .. "%")
			
			surface.DrawSentence("qsm", color[1], x - (w / 2), y + (h + 2), ent:Health() .. "%")
			surface.DrawSentence("qsm", color[2], x - (w / 2) + 1, y + (h + 2) + 1, ent:Health() .. "%")
		end
	end
end

function GM:DrawAmmo()
	if LocalPlayer():GetObserverMode() != 0 then return end
	
	local x, y, color, ammo = 2, 106, team.GetColors(LocalPlayer()), ""
	
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():IsMelee() or LocalPlayer():GetActiveWeapon():IsMisc() then
			ammo = ""
		else
			ammo = LocalPlayer():GetActiveWeapon():Clip1() .. "/" .. LocalPlayer():GetActiveWeapon():Ammo1()
		end
		
		surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
		surface.DrawGradient(x, y, 140, 24, 1, color[1], color[2])
		surface.DrawSentence("qtn", Color(255, 255, 255), x + 4, y + 4, LocalPlayer():GetActiveWeapon():GetPrintName() .. " " .. ammo)
	end
end

function GM:DrawWeaponSelection()
	if LocalPlayer().LastWeapon < CurTime() then return end
	
	local x, y, color = ScrW() - 222, ScrH() / 2, team.GetColors(LocalPlayer())
	local wpns = {}
	
	for k, v in pairs(LocalPlayer():GetWeapons()) do
		wpns[v:GetSlot() + 1] = v:GetPrintName()
	end
	
	for k, v in SortedPairs(wpns) do
		surface.DrawGradient(x, y, 220, 24, 1, color[1], color[2])
		surface.DrawGradient(x, y, 24, 24, 1, Color(101, 101, 101), Color(115, 115, 115))
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, k)
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, v)
		
		y = y + 26
	end
end

function GM:DrawSpectator()
	if LocalPlayer().Death and LocalPlayer().Death >= CurTime() and GAMEMODE.Phase == 1 then
		local x, y = 4, ScrH()
		local w, h = surface.GetTextSize(" ")
		local _w, _h = 0, 2
		
		surface.SetFont("qmd")
		
		w, h = surface.GetTextSize("This message will disappear in " .. math.Round(((CurTime() - LocalPlayer().Death) * -1)) .. " seconds.")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, "This message will disappear in " .. math.Round(((CurTime() - LocalPlayer().Death) * -1)) .. " seconds.")
		
		w, h = surface.GetTextSize(" ")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, " ")
		
		w, h = surface.GetTextSize(input.LookupBinding("+reload") .. " First Person Mode")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, input.LookupBinding("+reload"):upper() .. " - First Person Mode")
		
		w, h = surface.GetTextSize(input.LookupBinding("+duck") .. " Chase Player Mode")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, input.LookupBinding("+duck"):upper() .. " - Chase Player Mode")
		
		w, h = surface.GetTextSize(input.LookupBinding("+jump") .. " Free Roam Mode")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, input.LookupBinding("+jump"):upper() .. " - Free Roam Mode")
		
		w, h = surface.GetTextSize(input.LookupBinding("+attack2") .. " Previous Player")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, input.LookupBinding("+attack2"):upper() .. " - Previous Player")
		
		w, h = surface.GetTextSize(input.LookupBinding("+attack") .. " Next Player")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, input.LookupBinding("+attack"):upper() .. " - Next Player")
		
		w, h = surface.GetTextSize("SPECATOR CONTROLS")
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, "SPECATOR CONTROLS")
	end
end

local _z = 0
function GM:DrawPings()
	if GAMEMODE.Pings and #GAMEMODE.Pings > 0 then
		for k, v in pairs(GAMEMODE.Pings) do
			if v.Time > CurTime() then
				render.SetMaterial(Material("effects/select_ring"))
				render.DrawQuadEasy(v.Pos, v.Pos2, 48, 48, Color(255, 255, 255))
				
				render.SetMaterial(Material("effects/select_dot"))
				render.DrawQuadEasy(v.Pos, v.Pos2, 32, 32,  Color(255, 255, 255))
			end
		end
	end
end

function GM:DrawLR()
	if !LocalPlayer():CanLR() then return end
	
	local x, y, color = 2, 158, team.GetColors(LocalPlayer())
	
	surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
	surface.DrawSentence("qsm", Color(255, 255, 255), x + 9, y + 3, "LAST REQUEST")
	
	y = y + 26
	
	for id, val in SortedPairs(GAMEMODE.LastRequests) do
		surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
		surface.DrawGradient(x, y, 24, 24, 1, color[1], color[2])
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, id)
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, val[2])
		
		y = y + 26
	end
end

function GM:DrawHelp()
	if !GAMEMODE.ShowHelpText then return end
	
	surface.SetFont("qtn")
	local x, y, y2, w2, color = ScrW() / 2 - 400, ScrH() / 2 - 300, 26, 0, team.GetColors(LocalPlayer())
	local w, h = surface.GetTextSize("Z")
	
	for _, str in SortedPairs(GAMEMODE.HelpText) do
		w, h = surface.GetTextSize(str)
		
		if w > w2 then
			w2 = w
		end
		
		y2 = y2 + h
	end
	
	surface.DrawBox(x, y, w2 + 8, y2, Color(color[1].r, color[1].g, color[1].b, 200))
	surface.DrawSentence("qtn", Color(255, 255, 255), x, y, "HELP & INFO")
	
	y = y + h
	
	for _, str in SortedPairs(GAMEMODE.HelpText, false) do
		w, h = surface.GetTextSize(str)
		surface.DrawSentence("qtn", Color(255, 255, 255), x + 2, y + 2, str)
		
		y = y + h
	end
end

function GM:PlayerBindPress(ply, bind, pressed)
	if ply:IsInmate() and LocalPlayer():CanLR() then
		for k, v in  SortedPairs(GAMEMODE.LastRequests) do
			if string.find(bind, "slot" .. k) and pressed then
				
				RunConsoleCommand("jb_lr", v[1])
				
				return true
			end
		end
	end
	
	if string.find(bind, "slot1") and pressed then
		for k, v in pairs(LocalPlayer():GetWeapons()) do
			if v:IsPrimary() then
				LocalPlayer().LastWeapon = CurTime() + 3
				RunConsoleCommand("use", v:GetClass())
			end
		end
		
		return true
	end
	
	if string.find(bind, "slot2") and pressed then
		for k, v in pairs(LocalPlayer():GetWeapons()) do
			if v:IsSecondary() then
				LocalPlayer().LastWeapon = CurTime() + 3
				RunConsoleCommand("use", v:GetClass())
			end
		end
		
		return true
	end
	
	if string.find(bind, "slot3") and pressed then
		for k, v in pairs(LocalPlayer():GetWeapons()) do
			if v:IsMelee() then
				LocalPlayer().LastWeapon = CurTime() + 3
				RunConsoleCommand("use", v:GetClass())
			end
		end
		
		return true
	end
	
	if string.find(bind, "slot4") and pressed then
		for k, v in pairs(LocalPlayer():GetWeapons()) do
			if v:IsMisc() then
				LocalPlayer().LastWeapon = CurTime() + 3
				RunConsoleCommand("use", v:GetClass())
			end
		end
		
		return true
	end
	
	if string.find(bind, "+menu") and pressed then
		RunConsoleCommand("jb_drop")
		
		return true
	end
end

function GM:ScoreboardShow()
	if GAMEMODE.DisableScoreboard then return end
	
	if !GAMEMODE.ShowScoreBoard then
		DrawScoreboard()
		GAMEMODE.ShowScoreBoard = true
	end
end

function GM:ScoreboardHide()
	if GAMEMODE.ShowScoreBoard then
		GAMEMODE.ShowScoreBoard = false
	end
end
