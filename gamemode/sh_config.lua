// Disables the provided HUD.
// Only change the booleans
GM.ShouldDrawHUD			= { ["hud"] = true, ["pid"] = true , ["ammo"] = true, ["weapon"] = true , ["spectator"] = true, ["lr"] = true, ["help"] = true }

// Disables the provided Scoreboard.
// Change boolean to true or false
GM.ShowScoreBoard			= false

// Disables built in votemap.
// Change boolean to true or false
GM.NextMap					= false

// Who has access to LR Tool(Used for manual LR spawn placement)
// Example: "STEAM_0:0:0" ,"STEAM_0:0:1",
GM.ToolAccess				= { "STEAM_0:0:740023", }

// Use custom players spawns instead of the ones defined by the map.
// Change boolean to true or false
GM.CustomSpawns				= true

// Give Guards/Inmates starter weapons as defined below in the table/array.
// Change boolean to true or false
GM.StarterWeapons			= true

// Selection of models that Guards can spawn as.
GM.GuardModels				= { "models/player/urban.mdl", "models/player/swat.mdl", "models/player/gasmask.mdl", "models/player/riot.mdl", }

// Selection of models that Inmates can spawn as.
GM.InmateModels				= { "models/player/arctic.mdl", "models/player/phoenix.mdl", "models/player/guerilla.mdl", "models/player/leet.mdl", }

// Selection of primary weapons that Guards can spawn with.
GM.GuardPrimaryWeapons		= { "weapon_ak47", "weapon_aug", "weapon_awp", "weapon_famas", "weapon_galil", "weapon_m249", "weapon_m4a1", "weapon_mac10", "weapon_mp5navy", "weapon_p90", "weapon_scout", "weapon_sg550", "weapon_sg552", "weapon_tmp", "weapon_ump45", }

// Selection of secondary weapons that Guards can spawn with.
GM.GuardSecondaryWeapons	= { "weapon_deagle", "weapon_fiveseven", "weapon_glock", "weapon_p228", "weapon_usp", }

// Selection of weapons that Inmates can spawn with.
GM.InmateWeapons			= { "weapon_hands", }

// Force a weapon to use primary weapon slot
GM.PrimaryWeapons			= {}

// Force a weapon to use primary weapon slot
GM.SecondaryWeapons			= {}

// Force a weapon to use primary weapon slot
GM.MeleeWeapons				= {}

// Help text
// Change boolean to true or false
GM.HelpText					= true

// Votemap Materials
GM:AddMapImage("ba_jail_alcatraz_pre-final", "jailbreak/maps/ba_jail_alcatraz_pre-final.png")
GM:AddMapImage("ba_jail_alpha", "jailbreak/maps/ba_jail_alpha.png")
GM:AddMapImage("ba_jail_blackops", "jailbreak/maps/ba_jail_blackops.png")
GM:AddMapImage("ba_jail_bravo", "jailbreak/maps/ba_jail_bravo.png")
GM:AddMapImage("ba_jail_campus_v4", "jailbreak/maps/ba_jail_campus_v4.png")
GM:AddMapImage("ba_jail_canyondam_v6_fix", "jailbreak/maps/ba_jail_canyondam_v6_fix.png")
GM:AddMapImage("ba_jail_cavewalk_v1b", "jailbreak/maps/ba_jail_cavewalk_v1b.png")
GM:AddMapImage("ba_jail_e-block_fix", "jailbreak/maps/ba_jail_e-block_fix.png")
GM:AddMapImage("ba_jail_electric_aero_v1_1", "jailbreak/maps/ba_jail_electric_aero_v1_1.png")
GM:AddMapImage("ba_jail_electric_razor_v6", "jailbreak/maps/ba_jail_electric_razor_v6.png")
GM:AddMapImage("ba_jail_electric_vip_v2", "jailbreak/maps/ba_jail_electric_vip_v2.png")
GM:AddMapImage("ba_jail_hellsgamers_fx6", "jailbreak/maps/ba_jail_hellsgamers_fx6.png")
GM:AddMapImage("ba_jail_hellsgamers_se_r2", "jailbreak/maps/ba_jail_hellsgamers_se_r2.png")
GM:AddMapImage("ba_jail_inhole", "jailbreak/maps/ba_jail_inhole.png")
GM:AddMapImage("ba_jail_ishimura_v2", "jailbreak/maps/ba_jail_ishimura_v2.png")
GM:AddMapImage("ba_jail_lego_prison_final", "jailbreak/maps/ba_jail_lego_prison_final.png")
GM:AddMapImage("ba_jail_lockdown_final", "jailbreak/maps/ba_jail_lockdown_final.png")
GM:AddMapImage("ba_jail_lr_state50_alpha3", "jailbreak/maps/ba_jail_lr_state50_alpha3.png")
GM:AddMapImage("ba_jail_mars", "jailbreak/maps/ba_jail_mars.png")
GM:AddMapImage("ba_jail_minecraft_beach_beta3", "jailbreak/maps/ba_jail_minecraft_beach_beta3.png")
GM:AddMapImage("ba_jail_minecraftpiston_v6", "jailbreak/maps/ba_jail_minecraftpiston_v6.png")
GM:AddMapImage("ba_jail_nightprison_v2", "jailbreak/maps/ba_jail_nightprison_v2.png")
GM:AddMapImage("ba_jail_nova_prospekt_2014", "jailbreak/maps/ba_jail_nova_prospekt_2014.png")
GM:AddMapImage("ba_jail_nstylez_gaming_lego", "jailbreak/maps/ba_jail_nstylez_gaming_lego.png")
GM:AddMapImage("ba_jail_sand_final_beta2", "jailbreak/maps/ba_jail_sand_final_beta2.png")
GM:AddMapImage("ba_jail_sand_v3", "jailbreak/maps/ba_jail_sand_v3.png")
GM:AddMapImage("ba_jail_xtreme_downview_v4", "jailbreak/maps/ba_jail_xtreme_downview_v4.png")
GM:AddMapImage("ba_mario_party_extended_v1", "jailbreak/maps/ba_mario_party_extended_v1.png")
GM:AddMapImage("jb_avalanche", "jailbreak/maps/jb_avalanche.png")
GM:AddMapImage("jb_brikkenwood_v4", "jailbreak/maps/jb_brikkenwood_v4.png")
GM:AddMapImage("jb_carceris_final_fixed", "jailbreak/maps/jb_carceris_final_fixed.png")
GM:AddMapImage("jb_hell_castle_bt3p", "jailbreak/maps/jb_hell_castle_bt3p.png")
GM:AddMapImage("jb_iceworld", "jailbreak/maps/jb_iceworld.png")
GM:AddMapImage("jb_italia_beta4", "jailbreak/maps/jb_italia_beta4.png")
GM:AddMapImage("jb_lego_jail_pre_v6-2", "jailbreak/maps/jb_lego_jail_pre_v6-2.png")
GM:AddMapImage("jb_lego_jail_v4", "jailbreak/maps/jb_lego_jail_v4.png")
GM:AddMapImage("jb_lego_jail_v8", "jailbreak/maps/jb_lego_jail_v8.png")
GM:AddMapImage("jb_mars_lp", "jailbreak/maps/jb_mars_lp.png")
GM:AddMapImage("jb_minecraft_z_v4g", "jailbreak/maps/jb_minecraft_z_v4g.png")
GM:AddMapImage("jb_new_summer_v2", "jailbreak/maps/jb_new_summer_v2.png")
GM:AddMapImage("jb_new_summer_v3", "jailbreak/maps/jb_new_summer_v3.png")
GM:AddMapImage("jb_nexzoid", "jailbreak/maps/jb_nexzoid.png")
GM:AddMapImage("jb_no1_jail_v2b9", "jailbreak/maps/jb_no1_jail_v2b9.png")
GM:AddMapImage("jb_parabellum_xg_v1-1", "jailbreak/maps/jb_parabellum_xg_v1-1.png")
GM:AddMapImage("jb_paradise_prison_fix", "jailbreak/maps/jb_paradise_prison_fix.png")
GM:AddMapImage("jb_skyjail_v2", "jailbreak/maps/jb_skyjail_v2.png")
GM:AddMapImage("jb_space_jail_v1_fix2", "jailbreak/maps/jb_space_jail_v1_fix2.png")
GM:AddMapImage("jb_spy_vs_spy_beta7", "jailbreak/maps/jb_spy_vs_spy_beta7.png")
GM:AddMapImage("jb_underrock_v1", "jailbreak/maps/jb_underrock_v1.png")
GM:AddMapImage("jb_vipinthemix_v1_2", "jailbreak/maps/jb_vipinthemix_v1_2.png")
GM:AddMapImage("jb_vortex_dimension_v2_1", "jailbreak/maps/jb_vortex_dimension_v2_1.png")
