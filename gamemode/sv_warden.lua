
local Vector = Vector
local Format = Format

function GM:SelectWarden( ply )
	if GAMEMODE:GetPhase() == ROUND_END then return end
	if !ply:CanBecomeWarden() then return end
	if ply:IsWarden() then return end

	ply:SetWarden(true)
	ply:SetPlayerColor(Vector(0, 0, 1))
	ply:SetModel("models/player/barney.mdl")

	for _, pl in pairs(player.GetAll()) do
		pl:SendLua([[surface.PlaySound(Sound("buttons/blip2.wav"))]])

		GAMEMODE:AddNotice(4, Format(pl:GetPhrase("iswarden"), ply:Nick()), pl)
	end
end
