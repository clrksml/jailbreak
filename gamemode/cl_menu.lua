local surface = surface
local team = team
local math = math
local surface = surface
local string = string
local vgui = vgui
local game = game

function JoinTeam()
	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(ScrW(), ScrH())
	DFrame1:SetPos(0, 0)
	DFrame1:SetDraggable(false)
	DFrame1:SetTitle("")
	DFrame1:MakePopup()
	DFrame1:Center()
	DFrame1.btnMaxim.Paint = function() end
	DFrame1.btnMinim.Paint = function() end
	DFrame1.btnClose.Paint = function() end
	DFrame1.Paint = function(_, width, height)
		surface.DrawBox(0, 0, width, height, Color(1, 1, 1, 150))
	end
	
	local DPanel1 = vgui.Create("DPanel", DFrame1)
	DPanel1:SetSize(400, 200)
	DPanel1:SetPos(DFrame1:GetWide() / 2 - DPanel1:GetWide() / 2, DFrame1:GetTall() / 2 - DPanel1:GetTall() / 2)
	DPanel1.Paint = function(_, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(247, 247, 247))
	end
	
	local DButton1 = vgui.Create("DButton", DPanel1)
	DButton1:SetSize((DPanel1:GetWide() / 2) - 3, 146)
	DButton1:SetPos(2, 2)
	DButton1:SetText("")
	DButton1.DoClick = function()
		if !LocalPlayer():IsInmate() and !LocalPlayer():IsDeadInmate() then
			RunConsoleCommand("jb_team", 2)
		end
		DFrame1:Close()
	end
	DButton1.Paint = function(_, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(160, 54, 53), Color(175, 59, 58))
		
		surface.SetFont("qlg")
		local i = team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("inmates")))
		
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, h, string.upper(LocalPlayer():GetPhrase("inmates")))
		
		w, h = surface.GetTextSize(i .. "/" .. game.MaxPlayers())
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, height - h, i .. "/" .. game.MaxPlayers())
	end
	
	local DButton2 = vgui.Create("DButton", DPanel1)
	DButton2:SetSize((DPanel1:GetWide() / 2) - 3, 146)
	DButton2:SetPos((DPanel1:GetWide() / 2) + 1, 2)
	DButton2:SetText("")
	DButton2.DoClick = function()
		if !LocalPlayer():IsGuard() and !LocalPlayer():IsDeadGuard() then
			RunConsoleCommand("jb_team", 1)
		end
		DFrame1:Close()
	end
	DButton2.Paint = function(_, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(53, 106, 160), Color(58, 116, 175))
		
		surface.SetFont("qlg")
		local g = team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("guards")))
		
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, h, string.upper(LocalPlayer():GetPhrase("guards")))
		
		w, h = surface.GetTextSize(g .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))
		
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, height - h, g .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))
	end
	
	local DButton3 = vgui.Create("DButton", DPanel1)
	DButton3:SetSize(DPanel1:GetWide() - 2, 50)
	DButton3:SetPos(1, DPanel1:GetTall() - 51)
	DButton3:SetText("")
	DButton3.DoClick = function()
		if !LocalPlayer():IsSpec() then
			RunConsoleCommand("jb_team", 3)
		end
		
		DFrame1:Close()
	end
	DButton3.Paint = function(_, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(164, 160, 53), Color(159, 164, 53))
		
		surface.SetFont("qlg")
		local s = team.NumPlayers(TEAM_SPECTATOR)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("spectators")))
		
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, 2, string.upper(LocalPlayer():GetPhrase("spectators")))
		
		w, h = surface.GetTextSize(s .. "/" .. game.MaxPlayers())
		
		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, height - (h - 6), s .. "/" .. game.MaxPlayers())
	end
end
concommand.Add("jb_pickteam", JoinTeam)
