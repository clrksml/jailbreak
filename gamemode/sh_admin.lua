
if ULib and ulx then
	local CATEGORY_NAME = "Jailbreak"
	
	function ulx.swap(admin, target_plys)
		for i=1, #target_plys do
			local ply = target_plys[ i ]
			
			if ply:IsInmate() then
				ply:SetTeam(TEAM_GUARD)
				ply:Spawn()
				
				ulx.fancyLogAdmin(admin, "#A swaped #T to Guard", ply )
			elseif ply:IsGuard() then
				ply:SetTeam(TEAM_INMATE)
				ply:Spawn()
				
				ulx.fancyLogAdmin(admin, "#A swaped #T to Inmate", ply )
			end
		end
	end
	
	local swap = ulx.command(CATEGORY_NAME, "ulx swap", ulx.swap, "!swap", true)
	swap:addParam{type=ULib.cmds.PlayersArg}
	swap:defaultAccess(ULib.ACCESS_ADMIN)
	swap:help("swap from inmate to guard or guard to inmate.")
	
	function ulx.guardban(admin, target_plys)
		for i=1, #target_plys do
			local ply = target_plys[ i ]
			
			if !ply:HasGuardBan() then
				ply:SetGuardBan(true)
				
				ulx.fancyLogAdmin(admin, "#A banned #T access to GUARDS", ply )
			else
				ply:SetGuardBan(false)
				
				ulx.fancyLogAdmin(admin, "#A unbanned #T access to GUARDS", ply )
			end
		end
	end
	
	local guardban = ulx.command(CATEGORY_NAME, "ulx guardban", ulx.guardban, "!guardban", true)
	guardban:addParam{type=ULib.cmds.PlayersArg}
	guardban:defaultAccess(ULib.ACCESS_ADMIN)
	guardban:help("toggle guard ban on a player.")
end

if moderator then
	local COMMAND  = {}
	COMMAND.name = "Swap"
	COMMAND.tip = "Swaps the target's to the opposing team."
	COMMAND.icon = "arrow_right"
	COMMAND.example = "!swap #all - Swap everyone to the oppisite team."
	
	function COMMAND :OnRun(client, arguments, target)
		local function Action(target)
			if target:IsInmate() then
				target:SetTeam(TEAM_GUARD)
				target:Spawn()
				
				moderator.NotifyAction(client, target, "swapped * to guard")
			elseif target:IsGuard() then
				target:SetTeam(TEAM_INMATE)
				target:Spawn()
				
				moderator.NotifyAction(client, target, "swapped * to inmate")
			end
		end
		
		if (type(target) == "table") then
			for k, v in pairs(target) do
				Action(v)
			end
		else
			Action(target)
		end
	end
	moderator.commands.swap = COMMAND

	local COMMAND  = {}
	COMMAND.name = "Guard Ban"
	COMMAND.tip = "Toggle guard ban on the target's."
	COMMAND.icon = "stop"
	COMMAND.example = "!guardban #all - toggle guard ban."
	
	function COMMAND :OnRun(client, arguments, target)
		local function Action(target)
			if !target:HasGuardBan() then
				target:SetGuardBan(true)
				
				moderator.NotifyAction(client, target, "banned * from guard")
			elseif target:HasGuardBan() then
				target:SetGuardBan(false)
				
				moderator.NotifyAction(client, target, "unbanned * from guard")
			end
		end
		
		if (type(target) == "table") then
			for k, v in pairs(target) do
				Action(v)
			end
		else
			Action(target)
		end
	end
	moderator.commands.guardban = COMMAND
end

if maestro then
	maestro.command("swap", {"player:target"}, function(caller, targets, credits)
		if #targets == 0 then return true, "Query matched no players." end
		
		for k, v in pairs(targets) do
			if v:IsInmate() then
				v:SetTeam(TEAM_GUARD)
				v:Spawn()
			elseif v:IsGuard() then
				v:SetTeam(TEAM_INMATE)
				v:Spawn()
			end
		end
		
		return false, "swapped %1 to the opposite team."
	end, [[Swaps the target's to the opposing team.]])
	
	maestro.command("guardban", {"player:target"}, function(caller, targets, credits)
		if #targets == 0 then return true, "Query matched no players." end
		
		for k, v in pairs(targets) do
			if !v:HasGuardBan() then
				v:SetGuardBan(true)
			else
				v:SetGuardBan(false)
			end
		end
		
		return false, "toggled guard ban on %1"
	end, [[Toggle guard ban on the target's.]])
end
