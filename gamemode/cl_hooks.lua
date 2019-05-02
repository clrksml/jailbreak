
local net = net
local cam = cam
local team = team
local math = math
local vgui = vgui
local game = game
local timer = timer
local input = input
local render = render
local table = table
local player = player
local string = string
local surface = surface
local pairs = pairs
local Color = Color
local ipairs = ipairs
local Format = Format
local SortedPairs = SortedPairs

function GM:InitPostEntity()
	GAMEMODE.ShowScoreBoard = false
	GAMEMODE.ShowHelpText = false
	GAMEMODE.LastRequestPlayer = false
	GAMEMODE.Notifactions = {}
	GAMEMODE.MarkerIcons = {
		[1] = "icons/move.png",
		[2] = "icons/cone.png",
		[3] = "icons/group.png",
		[4] = "icons/eye.png",
	}

	/*if LocalPlayer():GetPData("HasPlayedJB") ==  "0" then
		LocalPlayer():SetPData("HasPlayedJB", "1")
	end*/

	LocalPlayer().LastWeapon = CurTime()
	LocalPlayer().VoteMapLastVote, LocalPlayer().VoteMapWinner, LocalPlayer().VoteMapSelected = CurTime() + 17, false, 100

	local keys = { ["F1"] = "gm_showhelp", ["F2"] = "gm_showteam", ["F3"] = "gm_showspare1", ["F4"] = "gm_showspare2", ["Q"] = "+menu", ["C"] = "+menu_context", ["G"] = "impulse 201" }

	timer.Simple(3, function()
		for k, v in pairs(keys) do
			if input.LookupBinding(v) then
				net.Start("JB_SendKeys")
					net.WriteString(v)
					net.WriteString(input.LookupBinding(v))
				net.SendToServer()

				LocalPlayer():SetKey(v, input.LookupBinding(v))
			else
				net.Start("JB_SendKeys")
					net.WriteString(v)
					net.WriteString(k)
				net.SendToServer()

				LocalPlayer():ChatPrint(Format(LocalPlayer():GetPhrase("nobind"), LocalPlayer():Nick(), k, v))
			end
		end
	end)

	if IsMounted("cstrike") then return end
	LocalPlayer():ChatPrint(LocalPlayer():GetPhrase("nocss"))
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
		elseif hud == "death" and bool == true then
			GAMEMODE:DrawDeath()
		elseif hud == "votemap" and bool == true then
			GAMEMODE:DrawVoteMap()
		elseif hud == "notices" and bool == true then
			GAMEMODE:DrawNotices()
		end
	end
end

function GM:PostDrawTranslucentRenderables()
	GAMEMODE:DrawLRTool()
	GAMEMODE:DrawMarkers()

	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis(ang:Up(), 270)
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	if GAMEMODE.Phase == 1 then
		if IsValid(GAMEMODE:GetWarden()) and GAMEMODE:GetWarden():Alive() then
			cam.Start3D2D(GAMEMODE:GetWarden():EyePos() + Vector(0, 0, 25), ang, 0.2)
				surface.SetFont("qxl")

				local w, h = surface.GetTextSize(LocalPlayer():GetPhrase("warden"):upper())

				surface.DrawSentence("qxl", HSVToColor((CurTime() * 1) % 360, 1, 1), -w / 2 - 5, 0, LocalPlayer():GetPhrase("warden"):upper(), true)
			cam.End3D2D()
		end

		for _, ply in pairs(player.GetAll()) do
			if ply:IsInmate() or ply:IsGuard() then
				if ply:GetLR() and ply:Alive() then
					cam.Start3D2D(ply:EyePos() + Vector(0, 0, 7), ang, 0.2)
						surface.SetFont("qxl")

						local w, h = surface.GetTextSize(LocalPlayer():GetPhrase("lastrequest5"):upper())

						surface.DrawSentence("qxl", team.GetColor(ply:Team()), -w / 2 - 5, 0, LocalPlayer():GetPhrase("lastrequest5"):upper(), true)
					cam.End3D2D()
				end
			end

			if ply:IsInmate() and ply:IsRebel() and ply:Alive() then
				cam.Start3D2D(ply:EyePos() + Vector(0, 0, 25), ang, 0.2)
					surface.SetFont("qxl")

					local w, h = surface.GetTextSize(LocalPlayer():GetPhrase("rebel"):upper())

					surface.DrawSentence("qxl", team.GetColor(ply:Team()), -w / 2 - 5, 0, LocalPlayer():GetPhrase("rebel"):upper(), true)
				cam.End3D2D()
			end
		end
	end
end

function GM:DrawHUD()
	if !GAMEMODE.RoundStartTime then return end

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
	else
		_warden = LocalPlayer():GetPhrase("nowarden")
	end


	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))
	surface.DrawGradient(x, y, math.Clamp(_health * 1.4, (_health / 140), 140), 24, 1, Color(207, 57, 58), Color(196, 48, 49))
	surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "HP " .. _health)

	y = y + 26

	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))

	if GAMEMODE.Round > GAMEMODE.MaxRounds and GAMEMODE.MaxRounds != 0 then
		surface.DrawGradient(x, y, math.Clamp(1, 140, 140), 24, 1, Color(230, 126, 34), Color(211, 84, 0))
		surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "Rnd " .. GAMEMODE.MaxRounds .. "/" .. GAMEMODE.MaxRounds)
	else
		if GAMEMODE.MaxRounds == 0 then
			surface.DrawGradient(x, y, 140, 24, 1, Color(230, 126, 34), Color(211, 84, 0))
			surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "Rnd " .. GAMEMODE.Round)
		else
			surface.DrawGradient(x, y, math.Clamp(1, GAMEMODE.Round * 9.34, 140), 24, 1, Color(230, 126, 34), Color(211, 84, 0))
			surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, "Rnd " .. _round)
		end
	end

	y = y + 26

	surface.DrawGradient(x, y, 140, 24, 2, Color(45, 45, 45), Color(47, 47, 47))

	if GAMEMODE.Phase == 3 or GAMEMODE.Round > GAMEMODE.MaxRounds then
		surface.DrawGradient(x, y, 140, 24, 1, Color(155, 89, 182), Color(142, 68, 173))
		surface.DrawSentence("qmd", Color(255, 255, 255), x + 4, y, LocalPlayer():GetPhrase("waiting"))
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
		surface.DrawSentence("qlt", Color(255, 255, 255), x + 4, y + 4, LocalPlayer():GetActiveWeapon():GetPrintName() .. " " .. ammo)
	end
end

function GM:DrawWeaponSelection()
	if LocalPlayer().LastWeapon < CurTime() then return end

	local x, y, color = ScrW() - 222, ScrH() / 2, team.GetColors(LocalPlayer())
	local wpns = {}

	for k, v in pairs(LocalPlayer():GetWeapons()) do
		local num = 4

		if v:IsMelee() then
			num = 3
		elseif v:IsSecondary() then
			num = 2
		elseif v:IsPrimary() then
			num = 1
		end

		wpns[num] = v:GetPrintName()
	end

	for k, v in SortedPairs(wpns) do
		if LocalPlayer():GetActiveWeapon():GetPrintName() != v then
			surface.DrawGradient(x + 8, y, 220, 24, 1, color[1], color[2])
			surface.DrawGradient(x + 8, y, 24, 24, 1, Color(101, 101, 101), Color(115, 115, 115))
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 16, y + 2, k)
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 34, y + 2, v)
		else
			surface.DrawGradient(x, y, 220, 24, 2, color[1], color[2])
			surface.DrawGradient(x, y, 24, 24, 2, Color(101, 101, 101), Color(115, 115, 115))
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, k)
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, v)
		end

		y = y + 26
	end
end

function GM:DrawSpectator()
	if LocalPlayer():GetNWInt("LastDeath", 0) and LocalPlayer():GetNWInt("LastDeath", 0) >= CurTime() and GAMEMODE.Phase == 1 then
		local x, y = 4, ScrH()
		local w, h = surface.GetTextSize(" ")
		local _w, _h = 0, 2

		surface.SetFont("qmd")

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("spectime"), math.Round(((CurTime() - LocalPlayer():GetNWInt("LastDeath", 0)) * -1))))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("spectime"), math.Round(((CurTime() - LocalPlayer():GetNWInt("LastDeath", 0)) * -1))))

		w, h = surface.GetTextSize(" ")
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, " ")

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("specfirst"), input.LookupBinding("+reload"):upper()))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("specfirst"), input.LookupBinding("+reload"):upper()))

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("specchase"), input.LookupBinding("+duck"):upper()))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("specchase"), input.LookupBinding("+duck"):upper()))

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("specroam"), input.LookupBinding("+jump"):upper()))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("specroam"), input.LookupBinding("+jump"):upper()))

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("specprev"), input.LookupBinding("+attack2"):upper()))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("specprev"), input.LookupBinding("+attack2"):upper()))

		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("specnext"), input.LookupBinding("+attack"):upper()))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("specnext"), input.LookupBinding("+attack"):upper()))

		w, h = surface.GetTextSize(LocalPlayer():GetPhrase("speccontrol"))
		_w, _h = w + _w, h + _h

		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, LocalPlayer():GetPhrase("speccontrol"))
	end

	if IsValid(LocalPlayer():GetObserverTarget()) then
		surface.SetFont("qxl")

		local color = team.GetColors(LocalPlayer():GetObserverTarget())
		local w, h = surface.GetTextSize(LocalPlayer():GetObserverTarget():Nick())

		surface.DrawSentence("qxl", color[1], ScrW() / 2 - (w / 2), ScrH() - (h * 1.3), LocalPlayer():GetObserverTarget():Nick(), true)

		surface.SetFont("qmd")

		local _w, _h = surface.GetTextSize(LocalPlayer():GetObserverTarget():SteamID())

		surface.DrawSentence("qmd", color[2], ScrW() / 2 - (_w / 2), ScrH() - (_h + 2), LocalPlayer():GetObserverTarget():SteamID(), true)
	end
end

function GM:DrawMarkers( src )
	if GAMEMODE.Markers and #GAMEMODE.Markers > 0 then
		for k, v in pairs(GAMEMODE.Markers) do
			if v.Time > CurTime() then

				surface.SetFont("qmd")

				local ang = LocalPlayer():EyeAngles()
				ang:RotateAroundAxis(ang:Up(), 270)
				ang:RotateAroundAxis(ang:Forward(), 90)

				cam.Start3D2D(v.Pos + Vector(0, 0, 32), ang, 1)
					surface.SetDrawColor(Color(255, 255, 250))
					surface.SetMaterial(Material(GAMEMODE.MarkerIcons[v.Icon], "smooth"))
					surface.DrawTexturedRect(0, 0, 32, 32)
				cam.End3D2D()
			end
		end
	end
end

function GM:DrawLRTool()
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_tool" then
		local tr = LocalPlayer():GetEyeTrace()

		render.SetMaterial(Material("sgm/playercircle"))
		render.DrawQuadEasy(tr.HitPos + tr.HitNormal, tr.HitNormal, 36, 36, Color(0, 0, 0, 150))
	end
end

function GM:DrawLR()
	if LocalPlayer():IsInmate() and LocalPlayer():GetLR() and GAMEMODE.Phase == 1 then
		local x, y, color = 2, 158, team.GetColors(LocalPlayer())

		y = y + 26

		if GAMEMODE.LastRequest == "" then
			surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 9, y + 3, LocalPlayer():GetPhrase("lastrequest5"))
		
			for id, val in SortedPairs(GAMEMODE.LastRequests) do
				surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
				surface.DrawGradient(x, y, 24, 24, 1, color[1], color[2])
				surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, id)
				surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, val.Name)

				y = y + 26
			end
		end

	 	if !GAMEMODE.LastRequestPlayer and GAMEMODE.LastRequest != "" then
			surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
			surface.DrawSentence("qsm", Color(255, 255, 255), x + 9, y + 3, LocalPlayer():GetPhrase("lastrequest5"))
		
			for id, val in ipairs(team.GetPlayers(TEAM_GUARD)) do
				if id < 10 then
					surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
					surface.DrawGradient(x, y, 24, 24, 1, color[1], color[2])
					surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, id)
					surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, val:Nick())

					y = y + 26
				end
			end
		end
	end
end

function GM:DrawHelp()
	if !GAMEMODE.ShowHelpText then return end

	surface.SetFont("qlt")
	local x, y, y2, w2, color = ScrW() / 2 - 400, ScrH() / 2 - 300, 26, 0, team.GetColors(LocalPlayer())
	local w, h = surface.GetTextSize("Z")

	for _, str in SortedPairs(LocalPlayer():GetPhrase("helptext")) do
		w, h = surface.GetTextSize(str)

		if w > w2 then
			w2 = w
		end

		y2 = y2 + h
	end

	surface.DrawBox(x, y, w2 + 8, y2, Color(45, 45, 45))
	surface.DrawBox(x, y, w2 + 8, select(2, surface.GetTextSize("HELP & INFO")) + 1, Color(color[1].r, color[1].g, color[1].b))
	surface.DrawSentence("qlt", Color(255, 255, 255), x + 2, y, "HELP & INFO")

	y = y + h

	for _, str in SortedPairs(LocalPlayer():GetPhrase("helptext"), false) do
		w, h = surface.GetTextSize(str)

		if str:find("gm_showhelp") then
			str = string.Replace(str, "gm_showhelp", LocalPlayer():GetKey("gm_showhelp"):upper())
		end

		if str:find("gm_showteam") then
			str = string.Replace(str, "gm_showteam", LocalPlayer():GetKey("gm_showteam"):upper())
		end

		if str:find("gm_showspare1") then
			str = string.Replace(str, "gm_showspare1", LocalPlayer():GetKey("gm_showspare1"):upper())
		end

		if str:find("gm_showspare2") then
			str = string.Replace(str, "gm_showspare2", LocalPlayer():GetKey("gm_showspare2"):upper())
		end

		if str:find("+menu_context.") then
			str = string.Replace(str, "+menu_context", LocalPlayer():GetKey("+menu_context"):upper())
		end

		if str:find("+menu.") then
			str = string.Replace(str, "+menu", LocalPlayer():GetKey("+menu"):upper())
		end

		if str:find("impulse 201") then
			str = string.Replace(str, "impulse 201", LocalPlayer():GetKey("impulse 201"):upper())
		end

		surface.DrawSentence("qlt", Color(255, 255, 255), x + 2, y + 2, str)

		y = y + h
	end
end

function GM:DrawNotices()
	local size = 32
	local x, y = ScrW() - 1, 0

	surface.SetFont("qsm")

	local w, h = surface.GetTextSize(" ")
	local color =  team.GetColors(LocalPlayer())

	if !LocalPlayer() and LocalPlayer():Team() then return end

	for k, v in pairs(GAMEMODE.Notifactions) do
		if v.Time >= CurTime() then

			w, h = surface.GetTextSize(v.Str)
			w = w + size + 1

			if v.X >= ScrW() then
				v.X = v.X - 1
			end

			surface.DrawGradient(v.X - w, y + 2, w, size - 4, 2, Color(45, 45, 45), Color(57, 57, 57))

			surface.DrawGradient(v.X - w, y, size, size, 1, color[1], color[2])

			if v.Type == 1 then
				surface.DrawImage(v.X - w, y, size, size, "icons/Logout.png")
			elseif v.Type == 2 then
				surface.DrawImage(v.X - w, y, size, size, "icons/Login.png")
			elseif v.Type == 3 then
				surface.DrawImage(v.X - w, y, size, size, "icons/Death.png")
			else
				surface.DrawImage(v.X - w, y, size, size, "icons/Alert.png")
			end

			surface.DrawSentence("qsm", Color(255, 255, 255), v.X - w + size + 1, y + (size / 4), v.Str)

			y = y + size + 1

		else
			GAMEMODE.Notifactions[k] = nil

			if y > 25 then
				y = y - 25
			end
		end
	end
end

function GM:PlayerBindPress(ply, bind, pressed)
	if LocalPlayer():IsInmate() and LocalPlayer():GetLR() and GAMEMODE.Phase == 1 then
		if GAMEMODE.LastRequest == "" then
			for k, v in SortedPairs(GAMEMODE.LastRequests) do
				if string.find(bind, "slot" .. k) and pressed then
					GAMEMODE.LastRequest = v.ID

					return true
				end
			end
		end
			if !GAMEMODE.LastRequestPlayer and GAMEMODE.LastRequest != "" then
			for k, v in ipairs(team.GetPlayers(TEAM_GUARD)) do
				if k > 9 then return end
				if string.find(bind, "slot" .. k) and pressed then
					GAMEMODE.LastRequestPlayer = v

					net.Start("JB_LastRequest")
						net.WriteString(GAMEMODE.LastRequest)
						net.WriteString(GAMEMODE.LastRequestPlayer:UniqueID())
					net.SendToServer()

					return true
				end
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

	if string.find(bind, "impulse 201") and pressed then
		RunConsoleCommand("jb_drop")

		return true
	end

	if string.find(bind, "gm_showhelp") and pressed then
		JoinTeam()

		return true
	end

	if string.find(bind, "gmod_undo") and pressed then
		net.Start("JB_Marker")
			net.WriteInt(0, 32)
		net.SendToServer()

		return true
	end

	if ply:IsGuard() or ply:IsInmate() then
		if string.find(bind, "invnext") and pressed then
			if #LocalPlayer():GetWeapons() < 1 then return end
			if LocalPlayer():GetActiveWeapon() then
				local wep, wpns = LocalPlayer():GetActiveWeapon():GetClass(), {}

				LocalPlayer().LastWeapon = CurTime() + 3

				for k, v in pairs(LocalPlayer():GetWeapons()) do
					local num = 4

					if v:IsMelee() then
						num = 3
					elseif v:IsSecondary() then
						num = 2
					elseif v:IsPrimary() then
						num = 1
					end

					wpns[num] = v:GetClass()
				end

				if #wpns > 1 then
				wep = table.FindNext(wpns, wep)

				RunConsoleCommand("use", wep)

				return true
			else
				return false
			end
			end
		end

		if string.find(bind, "invprev") and pressed then
			if #LocalPlayer():GetWeapons() < 1 then return end
			if LocalPlayer():GetActiveWeapon() then
				local wep, wpns = LocalPlayer():GetActiveWeapon():GetClass(), {}

				LocalPlayer().LastWeapon = CurTime() + 3

				for k, v in pairs(LocalPlayer():GetWeapons()) do
					local num = 4

					if v:IsMelee() then
						num = 3
					elseif v:IsSecondary() then
						num = 2
					elseif v:IsPrimary() then
						num = 1
					end

					wpns[num] = v:GetClass()
				end

				if #wpns > 1 then
					wep = table.FindPrev(wpns, wep)

					RunConsoleCommand("use", wep)

					return true
				else
					return false
				end
			end
		end
	end
end

function GM:ScoreboardShow()
	if GAMEMODE.DisableScoreboard then return end

	if !GAMEMODE.ShowScoreBoard then
		GAMEMODE:DrawScoreboard()
		GAMEMODE.ShowScoreBoard = true
	end
end

function GM:ScoreboardHide()
	if GAMEMODE.ShowScoreBoard then
		GAMEMODE.ShowScoreBoard = false
	end
end

function GM:DrawScoreboard()
	local inmates, guards = team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD), team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)

	local function AddPlayer( pnl, ply )
		local color = team.GetColors(ply)
		local w, h = pnl:GetSize()
		local _w, _h = surface.GetTextSize("blah")

		local DPlayer = pnl:Add("DPanel")
		DPlayer:SetSize(275, 32)
		DPlayer:Dock(TOP)
		DPlayer:DockPadding(0, 0, 0, 0)
		DPlayer:DockMargin(0, 0, 0, 1)

		DPlayer.Paint = function()
			surface.SetFont("qmd")

			local pcolor = Color(46, 204, 113)

			if ply:Ping() <= 50 then
				pcolor = Color(46, 204, 113)
			elseif ply:Ping() <= 100 then
				pcolor = Color(46, 204, 113)
			elseif ply:Ping() <= 150 then
				pcolor = Color(241, 196, 15)
			elseif ply:Ping() <= 200 then
				pcolor = Color(243, 156, 18)
			elseif ply:Ping() <= 250 then
				pcolor = Color(230, 126, 34)
			else
				pcolor = Color(211, 84, 0)
			end

			_w, _h = surface.GetTextSize(ply:Nick())

			surface.DrawGradient(1, 1, 275, 30, 1, color[1], color[2])
			surface.DrawSentence("qmd", color_white, 33, 4, ply:Nick())

			_w, _h = surface.GetTextSize(ply:Ping())

			surface.DrawSentence("qmd", pcolor, (w - _w) - 18, 4, ply:Ping())
			surface.DrawBox(0, 0, 32, 32, Color(46, 204, 113))
		end

		local PlayerAvatar = vgui.Create("AvatarImage", DPlayer)
		PlayerAvatar:SetPos(1, 1)
		PlayerAvatar:SetSize(30, 30)
		PlayerAvatar:SetPlayer(ply, 30)

		if ply:SteamID64() then
			local PlayerProfile = vgui.Create("DButton", DPlayer)
			PlayerProfile:SetPos(2, 3)
			PlayerProfile:SetSize(20, 20)
			PlayerProfile:SetText("")
			PlayerProfile.Paint = function() end
			PlayerProfile.DoClick = function() ply:ShowProfile() end
			PlayerProfile.DoRightClick = function()
				gui.OpenURL("http://steamcommunity.com/profiles/" .. ply:SteamID64())
			end
		end

		return DPlayer
	end

	surface.SetFont("qlt")

	local x, y, h = 0, 0, (ScrW() / 2)
	local _w, _h = surface.GetTextSize("blah")

	local DFrame = vgui.Create("DFrame")
	DFrame:SetSize(550, 400)
	DFrame:Center()
	DFrame:SetTitle("")
	DFrame:MakePopup()
	DFrame:ShowCloseButton(false)
	DFrame:SetMouseInputEnabled(true)
	DFrame:SetKeyBoardInputEnabled(false)
	DFrame.Think = function()
		if !GAMEMODE.ShowScoreBoard then
			DFrame:Remove()
		end
	end
	DFrame.Paint = function()
		surface.SetFont("qlg")

		local w, h = surface.GetTextSize(GetHostName())

		surface.DrawGradient(0, 0, DFrame:GetWide(), DFrame:GetTall(), 2, Color(52, 73, 94), Color(44, 62, 80))

		surface.DrawGradient(0, 0, DFrame:GetWide(), 50, 2, Color(41, 59, 76), Color(34, 49, 63))

		surface.DrawSentence("qlg", color_white, 3, 1, GetHostName())

		surface.SetFont("qlt")

		w, h = surface.GetTextSize(GAMEMODE.Name .. " by " .. GAMEMODE.Author)

		surface.DrawSentence("qlt", color_white, 3, 50 - (h + 1), GAMEMODE.Name .. " by " .. GAMEMODE.Author)

		surface.SetFont("qlt")

		w, h = surface.GetTextSize(#player.GetAll() .. "/" .. game.MaxPlayers())

		surface.DrawSentence("qlt", color_white, DFrame:GetWide() - (w + 3), 50 - (h + 1), #player.GetAll() .. "/" .. game.MaxPlayers())

		surface.DrawGradient(0, 50, DFrame:GetWide() / 2, 30, 2, Color(175,59,58), Color(160, 54, 53))
		surface.DrawGradient(DFrame:GetWide() / 2, 50, DFrame:GetWide() / 2, 30, 2, Color(58, 116, 175), Color(53, 106, 160))

		surface.DrawSentence("qsm", color_white, 6, 50, LocalPlayer():GetPhrase("inmates"))

		w, h = surface.GetTextSize((team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers() - math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))

		surface.DrawSentence("qsm", color_white, (DFrame:GetWide() / 2) - (w + 6), 50, (team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers() - math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))

		surface.DrawSentence("qsm", color_white, (DFrame:GetWide() / 2) + 6, 50, LocalPlayer():GetPhrase("guards"))

		w, h = surface.GetTextSize((team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)) .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))

		surface.DrawSentence("qsm", color_white, DFrame:GetWide() - (w + 6), 50, (team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)) .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))

		surface.SetFont("qlt")

		w, h = surface.GetTextSize(LocalPlayer():GetPhrase("name"))

		surface.DrawSentence("qlt", color_white, 26, 65, LocalPlayer():GetPhrase("name"))
		surface.DrawSentence("qlt", color_white, (DFrame:GetWide() / 2) + 26, 65, LocalPlayer():GetPhrase("name"))

		w, h = surface.GetTextSize(LocalPlayer():GetPhrase("ping"))

		surface.DrawSentence("qlt", color_white, (DFrame:GetWide() / 2) - (w + 2), 65, LocalPlayer():GetPhrase("ping"))
		surface.DrawSentence("qlt", color_white, DFrame:GetWide() - (w + 2), 65, LocalPlayer():GetPhrase("ping"))
	end

	local DPanel = vgui.Create("DScrollPanel", DFrame)
	DPanel:SetSize(DFrame:GetWide() / 2 + 14, DFrame:GetTall() - 82)
	DPanel:SetPos(0, 81)
	DPanel.VBar.Paint = function() end
	DPanel.VBar.btnUp.Paint = function() end
	DPanel.VBar.btnDown.Paint = function() end
	DPanel.VBar.btnGrip.Paint = function() end

	local DPanel2 = vgui.Create("DScrollPanel", DFrame)
	DPanel2:SetSize(DFrame:GetWide() / 2 + 14, DFrame:GetTall() - 82)
	DPanel2:SetPos(DFrame:GetWide() / 2, 81)
	DPanel2.VBar.Paint = function() end
	DPanel2.VBar.btnUp.Paint = function() end
	DPanel2.VBar.btnDown.Paint = function() end
	DPanel2.VBar.btnGrip.Paint = function() end

	for _, ply in pairs(team.GetPlayers(TEAM_INMATE)) do
		AddPlayer(DPanel, ply)
	end

	for _, ply in pairs(team.GetPlayers(TEAM_INMATE_DEAD)) do
		AddPlayer(DPanel, ply)
	end

	for _, ply in pairs(team.GetPlayers(TEAM_GUARD)) do
		AddPlayer(DPanel2, ply)
	end

	for _, ply in pairs(team.GetPlayers(TEAM_GUARD_DEAD)) do
		AddPlayer(DPanel2, ply)
	end

	DFrame:SetTall(math.Clamp(inmates * 30, 400, ScrH() - 16))
	DPanel:SetTall(DFrame:GetTall() - 82)
	DPanel2:SetTall(DFrame:GetTall() - 82)
	DFrame:Center()
end

function GM:DrawMapVote()
	if GAMEMODE.NextMap then return end

	local size, time, font, font2 = 96, CurTime() + 35, "qlt", "qtn"

	if ScrH() >= 480 and ScrH() < 720 then
		size = 96
		font, font2 = "qtl", "qtn"
	elseif ScrH() >= 720 and ScrH() < 1080 then
		size = 160
		font, font2 = "qtn", "qsm"
	elseif ScrH() >= 1080 then
		font, font2 = "qsm", "qmd"
		size = 192
	end

	local VotePanel = vgui.Create("DFrame")
	VotePanel:SetSize(300, 300)
	VotePanel:SetDraggable(false)
	VotePanel:SetTitle("")
	VotePanel:MakePopup()
	VotePanel:Center()
	VotePanel.btnMaxim.Paint = function() end
	VotePanel.btnMinim.Paint = function() end
	VotePanel.btnClose.Paint = function() end
	VotePanel:ShowCloseButton(false)
	VotePanel.PerformLayout = function() end
	VotePanel.Refresh = function()
		if !IsValid(VotePanel) and !VotePanel:IsVisible() then return end

		if !LocalPlayer().VoteMapWinner then
			local x, y = (size * -1), 30
			for k, v in pairs(GAMEMODE.MapList) do
				if k < 4 then
					x = x + (size + 4)
				elseif k > 3 and k < 9 then
					if k == 5 then
						x, y = 4, (size + 34)
						x = 4
					else
						x = x + (size + 4)
					end
				elseif k > 7 and k < 13 then
					if k == 9 then
						x, y = 4, (y + size + 4)
						x = 4
					else
						x = x + (size + 4)
					end
				elseif k > 11 and k < 17 then
					if k == 13 then
						x, y = 4, (y + size + 4)
						x = 4
					else
						x = x + (size + 4)
					end
				end

				local MapPanel = vgui.Create("DPanel", VotePanel)
				MapPanel:SetSize(size, size)
				MapPanel:SetPos(x, y)
				MapPanel.Paint = function()
					if GAMEMODE.MapImage[v[1]] then
						surface.DrawImage(0, 0, size, size, GAMEMODE.MapImage[v[1]])
					else
						surface.DrawImage(0, 0, size, size, "gui/dupe_bg.png")
					end

					surface.SetFont(font)

					local _w, _h = surface.GetTextSize(v[3] .. " / " .. #player.GetAll())

					if LocalPlayer().VoteMapSelected == k then
						surface.DrawBox(0, 0, size, 18, Color(1, 175, 1, 200))
						surface.DrawBox(0, size - 18, size, 18, Color(1, 175, 1, 200))
					else
						surface.DrawBox(0, 0, size, 18, Color(1, 1, 1, 200))
						surface.DrawBox(0, size - 18, size, 18, Color(1, 1, 1, 200))
					end

					surface.DrawSentence(font, color_white, size - _w - 4, 0, v[3] .. " / " .. #player.GetAll())

					if size < 256 then
						surface.DrawSentence(font, color_white, 2, size - _h - 2, v[1])
					else
						surface.DrawSentence(font, color_white, 2, size - _h, v[1])
					end
				end

				local MapButton = vgui.Create("DButton", MapPanel)
				MapButton:SetSize(size, size)
				MapButton:SetPos(0, 0)
				MapButton:SetText("")
				MapButton.Paint = function() end
				MapButton.DoClick = function()
					if LocalPlayer().VoteMapLastVote <= CurTime() then
						if LocalPlayer().VoteMapSelected == k then return end

						net.Start("JB_VoteMap")
							net.WriteFloat(k)
						net.SendToServer()

						LocalPlayer().VoteMapLastVote = CurTime() + 1
						LocalPlayer().VoteMapSelected = k

						surface.PlaySound("buttons/button15.wav")
					end
				end
			end
		else
			size = 256

			local c, x, y = 0, 6, 28
			local winner = table.GetFirstValue(GAMEMODE.MapList)

			local WinnerPanel = vgui.Create("DPanel", VotePanel)
			WinnerPanel:SetSize(size, size)
			WinnerPanel:SetPos(x, y)
			WinnerPanel.Paint = function()
				if GAMEMODE.MapImage[winner] then
					surface.DrawImage(0, 0, size, size, GAMEMODE.MapImage[winner])
				else
					surface.DrawImage(0, 0, size, size, "gui/dupe_bg.png")
				end

				surface.SetFont(font)

				local _w, _h = surface.GetTextSize(winner)

				surface.DrawBox(0, 0, size, 18, Color(1, 1, 1, 200))
				surface.DrawBox(0, size - 18, size, 18, Color(1, 1, 1, 200))

				if size < 256 then
					surface.DrawSentence(font, color_white, 2, size - _h - 2, winner)
				else
					surface.DrawSentence(font, color_white, 2, size - _h, winner)
				end
			end
		end
	end

	VotePanel:Refresh()
	VotePanel:SizeToChildren(true, true)
	VotePanel:Center()
	VotePanel.Paint = function()
		if !IsValid(VotePanel) and !VotePanel:IsVisible() then return end

		surface.DrawBox(0, 0, VotePanel:GetWide(), 25, Color(1, 1, 1, 200))

		surface.SetFont(font2)

		local w, txt = surface.GetTextSize(math.Round(time - CurTime())) + 4, math.Clamp(math.Round(time - CurTime()), 0, math.Round(time - CurTime()))

		if size < 256 then
			surface.DrawSentence(font2, color_white, 4, 4, LocalPlayer():GetPhrase("mapvote"))
			surface.DrawSentence(font2, color_white, VotePanel:GetWide() -  w, 4, txt)
		else
			surface.DrawSentence(font2, color_white, 4, 2, LocalPlayer():GetPhrase("mapvote"))
			surface.DrawSentence(font2, color_white, VotePanel:GetWide() -  w, 2, txt)
		end
	end

	return VotePanel
end

function GM:AddNotice( type, str )
	if !type then type = 4 end
	if !str then return end

	surface.SetFont("qsm")

	local w, h = surface.GetTextSize(str)
	local len = w + ScrW()

	GAMEMODE.Notifactions[#GAMEMODE.Notifactions + 1] = { X = len, Type = type, Time = CurTime() + 5, Str = str }
end

function GM:Think()
	for _, ply in pairs(player.GetAll()) do
		if ply:IsInmate() or ply:IsGuard() and ply:IsPlayer() then
			for _, wep in pairs(ply:GetWeapons()) do
				if IsValid(wep) and wep:IsPrimary() or wep:IsSecondary() then
					if !ply.CSWeapons then
						ply.CSWeapons = {}
					end

					if !ply.CSWeapons[wep:GetClass()] then
						ply.CSWeapons[wep:GetClass()] = ClientsideModel(wep:GetModel(), RENDERGROUP_OPAQUE)
						ply.CSWeapons[wep:GetClass()]:SetNoDraw(true)
						ply.CSWeapons[wep:GetClass()]:SetParent(ply)
					end
				end
			end
		end
	end
end

local Attach = { [0] = "ValveBiped.Bip01_Spine2", [1] = "ValveBiped.Bip01_R_Thigh" }

function GM:PostPlayerDraw( ply )
	if ply:IsInmate() or ply:IsGuard() and ply:IsPlayer() then
		for _, wep  in pairs(ply:GetWeapons()) do
			if IsValid(wep) and  wep:GetClass() != ply:GetActiveWeapon():GetClass() then
				if wep:IsPrimary() or wep:IsSecondary() then
					local pos, ang = ply:GetBonePosition(ply:LookupBone(Attach[wep:GetSlot()]))

					if pos and ang then
						if ply.CSWeapons and ply.CSWeapons[wep:GetClass()] then
							if wep:IsPrimary() then
								ply.CSWeapons[wep:GetClass()]:SetRenderOrigin(pos + (ang:Forward() * 6) + (ang:Right() * 5) + (ang:Up() * -10))
							else
								pos.z = pos.z - 4
								ang:RotateAroundAxis(ang:Forward(), 90)
								ply.CSWeapons[wep:GetClass()]:SetRenderOrigin(pos + (ang:Up() * -4) + (ang:Right() * 5))
							end

							ply.CSWeapons[wep:GetClass()]:SetRenderAngles(ang)
							ply.CSWeapons[wep:GetClass()]:DrawModel()
						end
					end
				end
			end
		end
	end
end

function GM:ShouldDrawLocalPlayer( ply )
	return ply:GetNWBool("thirdperson", false)
end

function GM:CalcView( ply, pos, ang, fov )
	if !LocalPlayer():IsInmate() and !LocalPlayer():IsGuard() and !LocalPlayer():IsSpec() then return end
	if !LocalPlayer():GetNWBool("thirdperson", false) then return end
	if !LocalPlayer():Alive() then return end

	local view = {}

	view.origin = pos - (ang:Forward() * 70)
	view.angles = ang
	view.fov = fov
	view.drawviewer = true

	return view
end

function GM:OnSpawnMenuOpen()
	SelectProp()
end

function GM:OnContextMenuOpen()
	LocalPlayer():SetNWBool("thirdperson", !LocalPlayer():GetNWBool("thirdperson", false))
end