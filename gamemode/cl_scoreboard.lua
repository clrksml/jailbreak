local team = team
local surface = surface
local vgui = vgui
local math = math
local game = game

function DrawScoreboard()
	local function AddPlayer( pnl, ply )
		surface.SetFont("qtn")
		
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
			surface.DrawSentence("qtn", color_white, 26, ((_h / 2) - 3), ply:Nick())
			
			_w, _h = surface.GetTextSize(ply:Ping())
			
			surface.DrawSentence("qtn", pcolor, (w - _w) - 4, ((_h / 2) - 3), ply:Ping())
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
	
	surface.SetFont("qtn")
	
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
		
		surface.SetFont("qtn")
		
		w, h = surface.GetTextSize(GAMEMODE.Name .. " by " .. GAMEMODE.Author)
		
		surface.DrawSentence("qtn", color_white, 3, 50 - (h + 1), GAMEMODE.Name .. " by " .. GAMEMODE.Author)
		
		surface.SetFont("qtn")
		
		w, h = surface.GetTextSize(#player.GetAll() .. "/" .. game.MaxPlayers())
		
		surface.DrawSentence("qtn", color_white, DFrame:GetWide() - (w + 3), 50 - (h + 1), #player.GetAll() .. "/" .. game.MaxPlayers())
		
		surface.DrawGradient(0, 50, DFrame:GetWide() / 2, 30, 2, Color(175,59,58), Color(160, 54, 53))
		surface.DrawGradient(DFrame:GetWide() / 2, 50, DFrame:GetWide() / 2, 30, 2, Color(58, 116, 175), Color(53, 106, 160))
		
		surface.DrawSentence("qsm", color_white, 6, 50, "Inmates")
		
		w, h = surface.GetTextSize((team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers())
		
		surface.DrawSentence("qsm", color_white, (DFrame:GetWide() / 2) - (w + 6), 50, (team.NumPlayers(TEAM_INMATE) + team.NumPlayers(TEAM_INMATE_DEAD)) .. "/" .. game.MaxPlayers())
		
		surface.DrawSentence("qsm", color_white, (DFrame:GetWide() / 2) + 6, 50, "Guards")
		
		w, h = surface.GetTextSize((team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)) .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))
		
		surface.DrawSentence("qsm", color_white, DFrame:GetWide() - (w + 6), 50, (team.NumPlayers(TEAM_GUARD) + team.NumPlayers(TEAM_GUARD_DEAD)) .. "/" .. math.Round((game.MaxPlayers() / GAMEMODE.Ratio)))
		
		surface.SetFont("qtn")
		
		w, h = surface.GetTextSize("Name")
		
		surface.DrawSentence("qtn", color_white, 26, 65, "Name")
		surface.DrawSentence("qtn", color_white, (DFrame:GetWide() / 2) + 26, 65, "Name")
		
		w, h = surface.GetTextSize("Ping")
		
		surface.DrawSentence("qtn", color_white, (DFrame:GetWide() / 2) - (w + 2), 65, "Ping")
		surface.DrawSentence("qtn", color_white, DFrame:GetWide() - (w + 2), 65, "Ping")
		
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
