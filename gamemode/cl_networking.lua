local net = net

net.Receive("GameData", function( len )
	GAMEMODE.Phase = net.ReadFloat()
	GAMEMODE.Round = net.ReadFloat()
	GAMEMODE.MaxRounds = net.ReadFloat()
	GAMEMODE.RoundStartTime = CurTime()
	GAMEMODE.RoundTimeLimit = net.ReadFloat()
	GAMEMODE.Ratio = net.ReadFloat()
	GAMEMODE.Win = net.ReadFloat()
	
	if GAMEMODE.Phase == 0 then
		GAMEMODE.Pings = {}
		hook.Run("RoundPrep")
	elseif GAMEMODE.Phase == 1 then
		hook.Run("RoundStart")
	elseif GAMEMODE.Phase == 2 then
		hook.Run("RoundEnd", GAMEMODE.Win)
	end
end)

net.Receive("PlayerDeath", function( len )
	LocalPlayer().Death = CurTime() + 10
end)

net.Receive("WardenPings", function( len )
	if !GAMEMODE.Pings then
		GAMEMODE.Pings = {}
	end
	
	if #GAMEMODE.Pings >= 4 then
		GAMEMODE.Pings = {}
	end
	
	surface.PlaySound(Sound("buttons/blip2.wav"))
	
	GAMEMODE.Pings[#GAMEMODE.Pings + 1] = { Time = CurTime() + 10, Pos = net.ReadVector(), Pos2 = net.ReadVector()}
end)

net.Receive("SendLastRequests", function( len )
	if !GAMEMODE.LastRequests then
		GAMEMODE.LastRequests = {}
	end
	
	local id, str, num = net.ReadString(), net.ReadString(), net.ReadFloat()
	
	GAMEMODE.LastRequests[num] = { [1] = id, [2] = str }
end)
