local player = player

function GM:GetWarden()
	for _, ply in pairs(player.GetAll()) do
		if ply:IsWarden() then
			return ply
		end
	end
	
	return false
end
