
local net = net
local hook = hook
local util = util
local vgui = vgui
local team = team
local surface = surface

net.Receive("JB_GameData", function( len )
	GAMEMODE.Phase = net.ReadFloat()
	GAMEMODE.Round = net.ReadFloat()
	GAMEMODE.MaxRounds = net.ReadFloat()
	GAMEMODE.RoundStartTime = CurTime()
	GAMEMODE.RoundTimeLimit = net.ReadFloat()
	GAMEMODE.Ratio = net.ReadFloat()
	GAMEMODE.Win = net.ReadFloat()


	if GAMEMODE.Phase == 0 then		
		hook.Run("RoundPrep")
		
		GAMEMODE.Markers = {}
		GAMEMODE.LastRequest = ""
		GAMEMODE.LastRequestPlayer = false

		LocalPlayer().PhaseText = vgui.Create("TTOText")
		LocalPlayer().PhaseText:Init()
		LocalPlayer().PhaseText:SetFont("qel")
		LocalPlayer().PhaseText:SetColor(team.GetColor(LocalPlayer():Team()))
		LocalPlayer().PhaseText:SetText("Round Prep")
		LocalPlayer().PhaseText:SetInverted(true)
		LocalPlayer().PhaseText:Refresh()
	elseif GAMEMODE.Phase == 1 then
		hook.Run("RoundStart")

		LocalPlayer().PhaseText = vgui.Create("TTOText")
		LocalPlayer().PhaseText:Init()
		LocalPlayer().PhaseText:SetFont("qel")
		LocalPlayer().PhaseText:SetColor(team.GetColor(LocalPlayer():Team()))
		LocalPlayer().PhaseText:SetText("Round Start")
		LocalPlayer().PhaseText:SetInverted(false)
		LocalPlayer().PhaseText:Refresh()
	elseif GAMEMODE.Phase == 2 then
		hook.Run("RoundEnd", GAMEMODE.Win)

		GAMEMODE.LastRequest = ""
		GAMEMODE.LastRequestPlayer = false

		LocalPlayer().PhaseText = vgui.Create("TTOText")
		LocalPlayer().PhaseText:Init()
		LocalPlayer().PhaseText:SetFont("qel")
		LocalPlayer().PhaseText:SetColor(team.GetColor(LocalPlayer():Team()))
		LocalPlayer().PhaseText:SetText("Round End")
		LocalPlayer().PhaseText:SetInverted(true)
		LocalPlayer().PhaseText:Refresh()
	end

	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply.ragdoll) then
			ply.ragdoll:Remove()
		end
	end
end)


net.Receive("JB_Marker", function( len )
	surface.PlaySound(Sound("buttons/blip2.wav"))
	GAMEMODE:AddNotice(1, "JB_Marker")

	local tbl = net.ReadData(len)

	GAMEMODE.Markers = util.JSONToTable(util.Decompress(tbl))
end)

net.Receive("JB_UpdateMapVote", function( len )
	GAMEMODE.MapList = {}
	GAMEMODE.MapList = net.ReadTable()

	if GAMEMODE.VotePanel then
		GAMEMODE.VotePanel:Clear()
		GAMEMODE.VotePanel:Refresh()
	end
end)

net.Receive("JB_MapWinner", function( len )
	LocalPlayer().VoteMapWinner = true

	GAMEMODE.MapList = net.ReadTable()

	if GAMEMODE.VotePanel then
		GAMEMODE.VotePanel:Clear()
		GAMEMODE.VotePanel:Refresh()
	end
end)

net.Receive("JB_DrawMapVote", function( len )
	GAMEMODE.VotePanel = GAMEMODE:DrawMapVote()
end)

net.Receive("JB_AddNotice", function( len )
	GAMEMODE:AddNotice(net.ReadFloat(), net.ReadString())
end)

net.Receive("JB_LR", function( len )
	local lr, id = net.ReadInt(32)
	
	if lr == 0 then
		GAMEMODE:PrepLR()
	elseif lr == 1 then
		local id, guard = net.ReadString(), LocalPlayer()

		for _, ply in pairs(player.GetAll()) do
			if ply:IsGuard() and ply:GetLR() then
				guard = ply

				GAMEMODE:StartLR(id, guard)
				break
			end
		end
	else
		GAMEMODE:EndLR()
	end
end)

-- todo remove this. the table is shared.
/*net.Receive("JB_LastRequests", function( len )
	if !GAMEMODE.LastRequests then
		GAMEMODE.LastRequests = {}
	end

	local id, str, num, bool = net.ReadString(), net.ReadString(), net.ReadFloat(), net.ReadBool()

	GAMEMODE.LastRequests[num] = { [1] = id, [2] = str, [3] = bool }
end)*/