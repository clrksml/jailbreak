# jailbreak

![TitleImage](http://i.imgur.com/5q6hqvqm.jpg)

Jailbreak is a roleplay gamemode where indivuals play one of thre roles(Inmate, Guard, and Warden)


## Notes:
 Make sure to set up last requests on each map before playing or else it will use guard player spawns for lr locations for certain lr.

 Inside the sh_config.lua in the gamemode folder are some variables you use to change gamemode functionality.

 The follower convars can because inside of your server.cfg or autoexec.cfg to change gameplay.
 	jb_round_limit - 30 - Max round limit before trying to change map.

 	jb_time_limit - 900 - Round time limit in seconds.

 	jb_ratio - 3 - Inmate to Guard ratio.

 Admins and SuperAdmin receive logs during gameplay related to certain events. Player Killed, Player Damage, etc. Logs are located in data/jailbreak/logs folder.


## Hooks:
 The following are hooks you can use inside your own addons/lua files. These are examples. And they are called on client and server.
 
 `hook.Add("RoundPrep", "RoundPrepDummy", function()
	print("RoundPrep", CLIENT, SERVER)
 end)`
 
 
 `hook.Add("RoundStart", "RoundStartDummy", function()
 	print("RoundStart", CLIENT, SERVER)
 end)`
 
 
 `hook.Add("RoundEnd", "RoundEndDummy", function( win )
 	print("RoundEnd", CLIENT, SERVER, win)
 	
 	if win == 1 then
 		-- guards win
 	elseif win == 2 then
 		-- inmates win
 	else
 		-- timelimit
 	end
 end)`
