local l = {}

l.Name = "english"

l.guard = "Guard"
l.guards = "Guards"
l.inmate = "Inmate"
l.inmates = "Inmates"
l.spectator = "Spectator"
l.spectators = "Spectators"

l.guardban = "You can't join guards. You have a guard ban."

l.swaplist = "Added to %s swap list."
l.swapteam = "Press %s to swap teams."
l.jointeam = "%s joined %s."

l.lastrequest = "Last Request available. Press %s for Last Request menu."
l.lastrequest2 = "%s can choose his last request."
l.lastrequest3 = "%s has choosen %s as their last request."
l.lastrequest4 = "%s beat %s."
l.lastrequest5 = "Last Request"

l.needguard = "Need a guard in order to play."

l.warden = "%s has become warden."
l.nowarden = "No warden"

l.waiting = "Waiting"
l.prepping = "Prepping"
l.playing = "Playing"
l.ending = "Ending"

l.needwarden = "Need a warden."
l.needwarden2 = "Need a warden before you can choose your last request."

l.roundprep = "Round prep!"
l.roundstart = "Round start!"
l.roundend = "Round end!"

l.speak = "Inmates can now talk."

l.spectime = "This message will disappear in %s seconds."
l.specfirst = "%s - First Person Mode"
l.specchase = "%s - Chase Player Mode"
l.specroam = "%s - Free Roam Mode"
l.specprev = "%s - Previous Player"
l.specnext = "%s - Next Player"
l.speccontrol = "Spectator Controls"

l.name = "Name"
l.ping = "Ping"

l.helptext = { "Jailbreak is a roleplay gamemode where indivuals play one of three roles(Inmate, Guard, and Warden).",
"",
"[Inmates]",
"Inmates main objective is to make it to the end of the round and get a last request.",
"They do this by following orders given to them by guards and the warden.",
" - [Rebelling]",
"    - Killing, minging, cheating, use of a weapon, entering KOS area, failing to follow orders/commands.",
"",
"[Guards]",
"Guards objective is to maintin order and complete tasks given by the warden",
"Guards are prohibted from damaging inmates, giving contradictinng orders, aiding rebels, killing inmates who aren't rebels",
"",
"[Warden]",
"Guards are the start of a round may become a warden. ",
"Before cells are open warden must dictate orders (unless lr event)",
"Wardens are expected to start games such as simon says to reduce the inmate population.",
"Wardens can ping locations by pressing their +zoom bind",
"",
"[General]",
"When giving orders you must not try to entrap inmates. Unless it's a game.",
"Lying and misleading inmates is strictly prohibitted unless it's a game.",
"Last requests days are to be played out as intended.",
"",
"[Key Binds]",
"Team Selection  -  gm_showteam",
"Last Request  -  gm_showhelp",
"Ping Location  -  +zoom",
"",
"[Credits]",
"Clark - Creating Jailbreak.",
"golfer45, joshraphael - For testing this gamemode with me.", }

l.freeday = "This round is a FREE DAY."
l.warday = "This round is a WAR DAY."
l.race = "A DEAGLE has been spawned in one of the cells. Go and find it."

l.mapvote = "VOTE FOR NEXT MAP!"

l.nobind = "Hey %s you don't have %s bound to %s. We suggest you rebind it to play."

GM:CreateLanguage(l)