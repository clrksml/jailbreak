local surface = surface
local team = team
local math = math
local surface = surface
local string = string
local vgui = vgui
local game = game

function GM:InitPostEntity()
	GAMEMODE.ShowScoreBoard = false
	GAMEMODE.ShowHelpText = false
	GAMEMODE.LastRequests = {}
	
	LocalPlayer().LastWeapon = CurTime()
	LocalPlayer().VoteMapLastVote, LocalPlayer().VoteMapWinner, LocalPlayer().VoteMapSelected = CurTime() + 17, false, 100
	
	local keys = { "gm_showhelp", "gm_showteam", "gm_showspare1", "gm_showspare2", "+zoom" }
	
	for k, v in pairs(keys) do
		net.Start("SendKeys")
			net.WriteString(v)
			net.WriteString(input.LookupBinding(v))
		net.SendToServer()
		
		LocalPlayer():SetKey(v, input.LookupBinding(v))
	end
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
		end
	end
end

function GM:PostDrawTranslucentRenderables()
	GAMEMODE:DrawPings()
	GAMEMODE:DrawLRTool()
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
	surface.DrawGradient(x, y, math.Clamp(1, _health * 1.4, 125), 24, 1, Color(207, 57, 58), Color(196, 48, 49))
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
		
		w, h = surface.GetTextSize(Format(LocalPlayer():GetPhrase("spectime"), math.Round(((CurTime() - LocalPlayer().Death) * -1))))
		_w, _h = w + _w, h + _h
		
		surface.DrawSentence("qmd", Color(255, 255, 255), x, y - _h, Format(LocalPlayer():GetPhrase("spectime"), math.Round(((CurTime() - LocalPlayer().Death) * -1))))
		
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
end

function GM:DrawPings()
	if GAMEMODE.Pings and #GAMEMODE.Pings > 0 then
		for k, v in pairs(GAMEMODE.Pings) do
			if v.Time > CurTime() then
				render.SetMaterial(Material("effects/select_dot"))
				render.DrawQuadEasy(v.Pos, v.Pos2, 48, 48, v.Color)
				
				if v.Pos2.x == 1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(30, 0, 0), v.Pos2, 48, 48, v.Color)
				end
				
				if v.Pos2.x == -1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(-30, 0, 0), v.Pos2, 48, 48, v.Color)
				end
				
				if v.Pos2.y == 1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(0, 30, 0), v.Pos2, 48, 48, v.Color)
				end
				
				if v.Pos2.y == -1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(0, -30, 0), v.Pos2, 48, 48, v.Color)
				end
				
				if v.Pos2.z == 1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(0, 0, 90), v.Pos2, 48, 48, v.Color)
				end
				
				if v.Pos2.z == -1 then
					render.SetMaterial(Material("effects/select_ring"))
					render.DrawQuadEasy(v.Pos + Vector(0, 0, -90), v.Pos2, 48, 48, v.Color)
				end
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
	if !LocalPlayer():GetLR() then return end
	
	local x, y, color = 2, 158, team.GetColors(LocalPlayer())
	
	surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
	surface.DrawSentence("qsm", Color(255, 255, 255), x + 9, y + 3, LocalPlayer():GetPhrase("lastrequest5"))
	
	y = y + 26
	
	for id, val in SortedPairs(GAMEMODE.LastRequests) do
		surface.DrawGradient(x, y, 150, 24, 1, Color(115, 115, 115), Color(101, 101, 101))
		surface.DrawGradient(x, y, 24, 24, 1, color[1], color[2])
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 8, y + 2, id + 1)
		surface.DrawSentence("qsm", Color(255, 255, 255), x + 26, y + 2, val[2])
		
		y = y + 26
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
	
	surface.DrawBox(x, y, w2 + 8, y2, Color(color[1].r, color[1].g, color[1].b, 200))
	surface.DrawSentence("qlt", Color(255, 255, 255), x, y, "HELP & INFO")
	
	y = y + h
	
	for _, str in SortedPairs(LocalPlayer():GetPhrase("helptext"), false) do
		w, h = surface.GetTextSize(str)
		
		if str:find("gm_showteam") then
			str = string.Replace(str, "gm_showteam", LocalPlayer():GetKey("gm_showteam"):upper())
		end
		
		if str:find("gm_showhelp") then
			str = string.Replace(str, "gm_showhelp", LocalPlayer():GetKey("gm_showhelp"):upper())
		end
		
		if str:find("+zoom") then
			str = string.Replace(str, "+zoom", LocalPlayer():GetKey("+zoom"):upper())
		end
		
		surface.DrawSentence("qlt", Color(255, 255, 255), x + 2, y + 2, str)
		
		y = y + h
	end
end

function GM:PlayerBindPress(ply, bind, pressed)
	if ply:IsInmate() and LocalPlayer():GetLR() then
		for k, v in  SortedPairs(GAMEMODE.LastRequests) do
			if string.find(bind, "slot" .. k + 1) and pressed then
				
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
	
	if ply:IsSpec() or !ply:IsGuard() and !ply:IsInmate() then
		if string.find(bind, "+zoom") and pressed then
			LocalPlayer().Death = CurTime() + 10
			
			return true
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
	local function AddPlayer( pnl, ply )
		surface.SetFont("qlt")
		
		local y = 0
		local color = team.GetColors(ply)
		local w, h = pnl:GetWide(), pnl:GetTall()
		local _w, _h = surface.GetTextSize("blah")
		
		y = #pnl:GetChildren() * 26
		
		local DPlayer = vgui.Create("DPanel", pnl)
		DPlayer:SetPos(0, y)
		DPlayer:SetSize(pnl:GetWide(), 26)
		DPlayer.Paint = function()
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
			
			surface.DrawGradient(1, 1, pnl:GetWide(), 24, 1, color[1], color[2])
			surface.DrawSentence("qlt", color_white, 26, ((_h / 2) - 3), ply:Nick())
			
			_w, _h = surface.GetTextSize(ply:Ping())
			
			surface.DrawSentence("qlt", pcolor, (w - _w) - 4, ((_h / 2) - 3), ply:Ping())
			surface.DrawBox(1, 2, 22, 22, Color(46, 204, 113))
		end
		
		local PlayerAvatar = vgui.Create("AvatarImage", DPlayer)
		PlayerAvatar:SetPos(2, 3)
		PlayerAvatar:SetSize(20, 20)
		PlayerAvatar:SetPlayer(ply, 20)
		
		if ply:SteamID64() then
			local PlayerProfile = vgui.Create("DButton", DPlayer)
			PlayerProfile:SetPos(2, 3)
			PlayerProfile:SetSize(20, 20)
			PlayerProfile:SetText("")
			PlayerProfile.Paint = function() end
			PlayerProfile.DoClick = function()
				gui.OpenURL("http://steamcommunity.com/profiles/" .. ply:SteamID64())
			end
			PlayerProfile.DoRightClick = function()
				gui.OpenURL("http://steamcommunity.com/profiles/" .. ply:SteamID64())
			end
		end
		
		pnl:SizeToChildren(false, true)
		
		local DFrame = pnl:GetParent()
		DFrame:SizeToChildren(false, true)
		DFrame:Center()
		
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
			DFrame:Close()
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
		
		w, h = surface.GetTextSize((team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers())
		
		surface.DrawSentence("qsm", color_white, (DFrame:GetWide() / 2) - (w + 6), 50, (team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers())
		
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
	
	local DPanel = vgui.Create("DPanel", DFrame)
	DPanel:SetSize(DFrame:GetWide() / 2, 14)
	DPanel:SetPos(0, 80)
	DPanel.Paint = function() end
	
	local DPanel2 = vgui.Create("DPanel", DFrame)
	DPanel2:SetSize(DFrame:GetWide() / 2, 14)
	DPanel2:SetPos(DFrame:GetWide() / 2, 80)
	DPanel2.Paint = function() end
	
	for _, ply in pairs(team.GetPlayers(TEAM_INMATE)) do
		AddPlayer(DPanel, ply):Refresh()
	end
	
	for _, ply in pairs(team.GetPlayers(TEAM_INMATE_DEAD)) do
		AddPlayer(DPanel, ply):Refresh()
	end
	
	for _, ply in pairs(team.GetPlayers(TEAM_GUARD)) do
		AddPlayer(DPanel2, ply):Refresh()
	end
	
	for _, ply in pairs(team.GetPlayers(TEAM_GUARD_DEAD)) do
		AddPlayer(DPanel2, ply):Refresh()
	end
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
						
						net.Start("VoteMap")
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
