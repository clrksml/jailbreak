// Disables the provided HUD.
// Only change the booleans
GM.ShouldDrawHUD		= { ["hud"] = true, ["pid"] = true , ["ammo"] = true, ["weapon"] = true , ["spectator"] = true, ["lr"] = true, ["help"] = true }

// Disables the provided Scoreboard.
// Change boolean to true or false
GM.ShowScoreBoard		= false

// Disables automatically changing to the next map.
// Change boolean to true or false
GM.NextMap				= false

// Who has access to LR Tool(Used for manual LR spawn placement)
// Example: "STEAM_0:0:0" ,"STEAM_0:0:1",
GM.ToolAccess			= { "STEAM_0:0:740023", }

// Help and Info text
GM.HelpText = { "Jailbreak is a roleplay gamemode where indivuals play one of three roles(Inmate, Guard, and Warden).",
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
"Lying and misleading prisoners is strictly prohibitted unless it's a game.",
"Last requests days are to be played out as intended.",
"",
"[Key Binds]",
"Team Selection  -  gm_showteam",
"Last Request  -  gm_showhelp",
"Ping Location  -  +zoom",
"",
"[Credits]",
"Clark - Creating Jailbreak.",
"golfer45, joshraphael - For testing this gamemode with me.",
"HandsomeMatt, Marcuz, meharryp, moat - For judging this gamemode."
}