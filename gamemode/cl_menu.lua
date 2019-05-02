
local team = team
local math = math
local vgui = vgui
local game = game
local player = player
local string = string
local surface = surface
local Color = Color

function JoinTeam()
	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(ScrW(), ScrH())
	DFrame1:SetPos(0, 0)
	DFrame1:SetDraggable(false)
	DFrame1:SetTitle("")
	DFrame1:MakePopup()
	DFrame1:Center()
	DFrame1.LastThink = CurTime() + 3
	DFrame1.btnMaxim.Paint = function() end
	DFrame1.btnMinim.Paint = function() end
	DFrame1.btnClose.Paint = function() end

	local DPanel1 = vgui.Create("DPanel", DFrame1)
	DPanel1:SetSize(400, 200)
	DPanel1:SetPos(DFrame1:GetWide() / 2 - DPanel1:GetWide() / 2, DFrame1:GetTall() / 2 - DPanel1:GetTall() / 2)
	DPanel1.Paint = function(self, width, height)
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
	DButton1.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(160, 54, 53), Color(175, 59, 58))

		surface.DrawImage(DButton1:GetWide() / 2 - 58, 2, 116,  116, "icons/inmate.png")

		surface.SetFont("qlg")
		local i = team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("inmates")))

		surface.DrawSentence("qlg", Color(255, 255, 255), 2, height - h + 2, string.upper(LocalPlayer():GetPhrase("inmates")))

		w, h = surface.GetTextSize(i .. "/" .. game.MaxPlayers())
		surface.DrawSentence("qlg", Color(255, 255, 255), width - (w + 2), height - h + 2, i .. "/" .. game.MaxPlayers())
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
	DButton2.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(53, 106, 160), Color(58, 116, 175))

		surface.DrawImage(DButton2:GetWide() / 2 - 58, 2, 116,  116, "icons/guard.png")

		surface.SetFont("qlg")
		local g = team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("guards")))

		surface.DrawSentence("qlg", Color(255, 255, 255), 2, height - h + 2, string.upper(LocalPlayer():GetPhrase("guards")))

		w, h = surface.GetTextSize(g .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))

		surface.DrawSentence("qlg", Color(255, 255, 255), width - (w + 2), height - h + 2, g .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))
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
	DButton3.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(164, 160, 53), Color(159, 164, 53))

		surface.SetFont("qlg")
		local s = team.NumPlayers(TEAM_SPECTATOR)
		local w, h = surface.GetTextSize(string.upper(LocalPlayer():GetPhrase("spectators")))

		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, 0, string.upper(LocalPlayer():GetPhrase("spectators")))

		w, h = surface.GetTextSize(s .. "/" .. game.MaxPlayers())

		surface.DrawSentence("qlg", Color(255, 255, 255), width / 2 - w / 2, height - (h - 6), s .. "/" .. game.MaxPlayers())
	end

	DFrame1.Paint = function(self, width, height)
		local x, y = DPanel1:GetPos()

		surface.DrawBox(0, 0, width, height, Color(1, 1, 1, 150))

		if self.LastThink >= CurTime() then
			surface.DrawSentence("qmd", Color(255, 255, 255), x, y + DPanel1:GetTall() + 2, "Press Enter or " .. LocalPlayer():GetKey("gm_showhelp"):upper() .. " to Close.", true)
		end
	end

	DFrame1.OnKeyCodePressed = function(self, key)
		if key == KEY_1 then
			DButton1:DoClick()
		end
		if key == KEY_2 then
			DButton2:DoClick()
		end
		if key == KEY_3 then
			DButton3:DoClick()
		end
		if key == KEY_ENTER then
			DFrame1:Close()
		end
		if key == input.GetKeyCode(LocalPlayer():GetKey("gm_showhelp")) then
			DFrame1:Close()
		end
	end
end

function SelectMarker()
	if !LocalPlayer():IsWarden() then return end
	
	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(ScrW(), ScrH())
	DFrame1:SetPos(0, 0)
	DFrame1:SetDraggable(false)
	DFrame1:SetKeyboardInputEnabled(true)
	DFrame1:SetTitle("")
	DFrame1:MakePopup()
	DFrame1:Center()
	DFrame1.LastThink = CurTime() + 3
	DFrame1.btnMaxim.Paint = function() end
	DFrame1.btnMinim.Paint = function() end
	DFrame1.btnClose.Paint = function() end

	local DPanel1 = vgui.Create("DPanel", DFrame1)
	DPanel1:SetSize(200, 150)
	DPanel1:SetPos(ScrW() / 2 - DPanel1:GetWide() / 2, ScrH() / 2 - DPanel1:GetTall() / 2 + 200)
	DPanel1.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(45, 45, 45), Color(247, 247, 247))
	end

	local DButton1 = vgui.Create("DButton", DPanel1)
	DButton1:SetSize(DPanel1:GetWide() / 2, 75)
	DButton1:SetPos(0, 0)
	DButton1:SetText("")
	DButton1.DoClick = function()
		DFrame1:Close()

		net.Start("JB_Marker")
			net.WriteInt(1, 32)
		net.SendToServer()
	end
	DButton1.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(255, 255, 255))
		surface.DrawImage(DButton1:GetWide() / 2 - 29, 2, 58, 58, GAMEMODE.MarkerIcons[1])
		surface.DrawSentence("qlg", Color(55, 55, 55), 2, 2, "1")
	end

	local DButton2 = vgui.Create("DButton", DPanel1)
	DButton2:SetSize(DPanel1:GetWide() / 2, 75)
	DButton2:SetPos(DPanel1:GetWide() / 2, 0)
	DButton2:SetText("")
	DButton2.DoClick = function()
		DFrame1:Close()

		net.Start("JB_Marker")
			net.WriteInt(2, 32)
		net.SendToServer()
	end
	DButton2.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(255, 255, 255))
		surface.DrawImage(DButton1:GetWide() / 2 - 29, 2, 58, 58, GAMEMODE.MarkerIcons[2])
		surface.DrawSentence("qlg", Color(55, 55, 55), 2, 2, "2")
	end

	local DButton3 = vgui.Create("DButton", DPanel1)
	DButton3:SetSize(DPanel1:GetWide() / 2, 75)
	DButton3:SetPos(0, DPanel1:GetTall() - DButton3:GetTall())
	DButton3:SetText("")
	DButton3.DoClick = function()
		DFrame1:Close()

		net.Start("JB_Marker")
			net.WriteInt(3, 32)
		net.SendToServer()
	end
	DButton3.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(255, 255, 255))
		surface.DrawImage(DButton1:GetWide() / 2 - 29, 2, 58, 58, GAMEMODE.MarkerIcons[3])
		surface.DrawSentence("qlg", Color(55, 55, 55), 2, 2, "3")
	end

	local DButton4 = vgui.Create("DButton", DPanel1)
	DButton4:SetSize(DPanel1:GetWide() / 2, 75)
	DButton4:SetPos(DPanel1:GetWide() - DButton3:GetWide(), DPanel1:GetTall() - DButton3:GetTall())
	DButton4:SetText("")
	DButton4.DoClick = function()
		DFrame1:Close()

		net.Start("JB_Marker")
			net.WriteInt(4, 32)
		net.SendToServer()
	end
	DButton4.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(255, 255, 255))
		surface.DrawImage(DButton1:GetWide() / 2 - 29, 2, 58, 58, GAMEMODE.MarkerIcons[4])
		surface.DrawSentence("qlg", Color(55, 55, 55), 2, 2, "4")
	end

	DFrame1.Paint = function(self, width, height)
		local x, y = DPanel1:GetPos()

		if self.LastThink >= CurTime() then
			surface.DrawSentence("qmd", Color(255, 255, 255), x, y + DPanel1:GetTall() + 2, "Press Enter or " .. LocalPlayer():GetKey("+menu"):upper() .. " to Close.", true)
		end
	end
	DFrame1.Think = function()
		if !LocalPlayer():IsWarden() then
			DFrame1:Remove()
		end
	end
	DFrame1.OnKeyCodePressed = function(self, key)
		if key == KEY_1 then
			DButton1:DoClick()
		end
		if key == KEY_2 then
			DButton2:DoClick()
		end
		if key == KEY_3 then
			DButton3:DoClick()
		end
		if key == KEY_4 then
			DButton4:DoClick()
		end
		if key == KEY_ENTER then
			DFrame1:Close()
		end
		if key == input.GetKeyCode(LocalPlayer():GetKey("+menu")) then
			DFrame1:Close()
		end
	end
end

function SelectProp()
	if !LocalPlayer():IsWarden() then return end
	
	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(400, 300)
	DFrame1:SetPos(0, 0)
	DFrame1:SetDraggable(false)
	DFrame1:SetKeyboardInputEnabled(true)
	DFrame1:SetTitle("")
	DFrame1:MakePopup()
	DFrame1:Center()
	DFrame1.LastThink = CurTime() + 3
	DFrame1.btnMaxim.Paint = function() end
	DFrame1.btnMinim.Paint = function() end
	DFrame1.btnClose.Paint = function() end


	local DScrollPanel1 = vgui.Create( "DScrollPanel", DFrame1)
	DScrollPanel1:Dock( FILL )
	DScrollPanel1.Paint = function(self, width, height)
		surface.DrawGradient(0, 0, width, height, 2, Color(245, 245, 245), Color(247, 247, 247))
	end

	local DIconLayout1 = vgui.Create( "DIconLayout", DScrollPanel1)
	DIconLayout1:Dock(FILL)
	DIconLayout1:SetSpaceY(5)
	DIconLayout1:SetSpaceX(5)

	for key, mdl in pairs(GAMEMODE.WardenProps) do
		local DPanel1 = DIconLayout1:Add("DPanel")
		DPanel1.Paint = function(self, width, height) end

		local DModelPanel1 = vgui.Create("DModelPanel", DPanel1)
		DModelPanel1:SetPos(0, 0)
		DModelPanel1:SetSize(DPanel1:GetWide(), DPanel1:GetTall())
		DModelPanel1:SetModel(mdl)

		local DButton1 = vgui.Create("DButton", DPanel1)
		DButton1:SetSize(DPanel1:GetWide(), DPanel1:GetTall())
		DButton1:SetPos(0, 0)
		DButton1:SetText("")
		DButton1.Paint = function(self, width, height) end
		DButton1.DoClick = function()
			DFrame1:Close()

			net.Start("JB_SpawnProp")
				net.WriteInt(key, 32)
			net.SendToServer()
		end
	end


	DFrame1.Paint = function(self, width, height)
		local x, y = DScrollPanel1:GetPos()

		if self.LastThink >= CurTime() then
			surface.DrawSentence("qmd", Color(255, 255, 255), x, y + DScrollPanel1:GetTall() + 2, "Press Enter or " .. LocalPlayer():GetKey("+menu"):upper() .. " to Close.", true)
		end
	end
	DFrame1.Think = function()
		if !LocalPlayer():IsWarden() then
			DFrame1:Remove()
		end
	end
	DFrame1.OnKeyCodePressed = function(self, key)
		if key == KEY_1 then
			DButton1:DoClick()
		end
		if key == KEY_2 then
			DButton2:DoClick()
		end
		if key == KEY_3 then
			DButton3:DoClick()
		end
		if key == KEY_4 then
			DButton4:DoClick()
		end
		if key == KEY_ENTER then
			DFrame1:Close()
		end
		if key == input.GetKeyCode(LocalPlayer():GetKey("+menu")) then
			DFrame1:Close()
		end
	end
end
SelectProp()