local math = math
local player = player

function GM:Move(ply, md)
	if ply:IsOnGround() or !ply:Alive() or ply:WaterLevel() > 0 then return end
	
	local aim = md:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = md:GetForwardSpeed()
	local smove = md:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()
	
	local wishvel = forward * fmove + right * smove
	wishvel.z = 0
	
	local wishspeed = wishvel:Length()
	
	if(wishspeed > md:GetMaxSpeed()) then
		wishvel = wishvel * (md:GetMaxSpeed()/wishspeed)
		wishspeed = md:GetMaxSpeed()
	end
	
	local wishspd = wishspeed
	wishspd = math.Clamp(wishspd, 5, 45)
	
	local wishdir = wishvel:GetNormal()
	local current = md:GetVelocity():Dot(wishdir)
	
	local addspeed = wishspd - current
	
	if(addspeed <= 0) then return end
	
	local accelspeed = (120) * wishspeed * FrameTime()
	
	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end
	
	local vel = md:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	md:SetVelocity(vel)
	
	return false
end

function GM:GetWarden()
	for _, ply in pairs(player.GetAll()) do
		if ply:IsWarden() then
			return ply
		end
	end
	
	return false
end

function GM:AddMapImage(map, path)
	if self.NextMap then return end
	
	if !self.MapImage then
		self.MapImage = {}
	end
	
	self.MapImage[map] = path
end
