
function GM:SelectWarden( ply )
	if GAMEMODE:GetPhase() == ROUND_END then return end
	if !ply:CanBecomeWarden() then return end
	if ply:IsWarden() then return end
	
	ply:SetWarden(true)
	
	for _, pl in pairs(player.GetAll()) do
		pl:ChatPrint(Format(pl:GetPhrase("warden"), ply:Nick()))
		pl:SendLua([[surface.PlaySound(Sound("buttons/blip2.wav"))]])
	end
end
