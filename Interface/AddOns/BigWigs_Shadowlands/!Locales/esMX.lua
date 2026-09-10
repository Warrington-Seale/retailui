-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "esMX")
if L then
	L.pickup_lantern = "%s recogió la linterna!"
	L.dropped_lantern = "Linterna soltada por %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "esMX")
if L then
	L.killed = "%s Muerto"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "esMX")
if L then
	L.shield_remaining = "%s restante: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "esMX")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Repetir alerta de vida de Miasma en /gritar"
	L.custom_on_repeating_yell_miasma_desc = "Repite en /gritar mensajes para Miasma Glotona for Gluttonous Miasma para que los demás sepan cuando estás por debajo del 75% de salud."

	L.custom_on_repeating_say_laser = "Repeating Volatile Ejection Say"
	L.custom_on_repeating_say_laser_desc = "Repeating en /decir mensajes para for Eyección volátil para ayudar al entrar en el rango de chat de los jugadores que no vieron tu primer mensaje."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "esMX")
if L then
	L.tear = "Ruptura" -- Short for Dimensional Tear
	L.seeds = "Semillas" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "esMX")
if L then
	L.times = "%dx %s"

	L.level = "%s (Nivel |cffffff00%d|r)"
	L.full = "%s (|cffff0000LLENO|r)"

	L.anima_adds = "Esbirros de ánima concentrada"
	L.anima_adds_desc = "Muestra un temporizador cuando los esbirros aparecen del debuff de Ánima Concentrada."

	L.custom_off_experimental = "Habilitar funcionalidades experimentales"
	L.custom_off_experimental_desc = "Estas funcionalidades |cffff0000no fueron probadas|r y pueden causar |cffff0000spam|r."

	L.anima_tracking = "Rastreo de Anima |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Mensajes y barras para rastrear los niveles de anima en los contenedores.|n|cffaaff00Consejo: Puede que quieras deshabilitar el cuadro o las barras de información, dependiendo de tu preferencia."

	L.desires = "Deseos"
	L.bottles = "Botellas"
	L.sins = "Pecados"
end

L = BigWigs:NewBossLocale("The Council of Blood", "esMX")
if L then
	L.custom_on_repeating_dark_recital = "Repetir Recital Oscuro"
	L.custom_on_repeating_dark_recital_desc = "Repite mensajes en decir para la habilidad Recital oscuro con íconos {rt1}, {rt2} para que encuentres a tu pareja mientras danzas."

	L.dance_assist = "Asistente de danza"
	L.dance_assist_desc = "Muestra advertencias direccionales para la fase de baile."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Baila hacia adelante |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Baila a la derecha |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Baila hacia abajo |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Baila a la izquierda |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Un paso al frente" -- Prance Forward!
	L.dance_yell_right = "Hombros a la derecha" -- Shimmy right!
	L.dance_yell_down = "A bailar" -- Boogie down! // Yelled by Niklaus & Frieda
	L.dance_yell_down_2 = "A mover las caderas" -- Boogie down! // Yelled by Stavros
	L.dance_yell_left = "Chassé a la izquierda" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "esMX")
if L then
	L.stomp_shift = "Pisotón & Falla" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Información de daño"
	L.fun_info_desc = "Muestra un mensaje que indica cuánta salud perdió el jefe durante Impacto Destructivo."

	L.health_lost = "Fangopuño perdió %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "esMX")
if L then
	L.first_blade = "Primera Cuchilla"
	L.second_blade = "Segunda cuchilla"

	L.skirmishers = "Comandos" -- Short for Stone Legion Skirmishers
	L.eruption = "Erupción" -- Short for Reverberating Eruption

	L.goliath_short = "Goliat"
	L.goliath_desc = "Muestra avisos y temporizadores para cuando el Goliat de la Legión Pétrea está apunto de aparecer."

	L.commando_short = "Comando"
	L.commando_desc = "Muestra avisos cuando un Comando de la Legión Pétrea es eliminado."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "esMX")
if L then
	L.infobox_stacks = "%d |4Acumulación:Acumulaciones;: %d |4jugador:jugadores;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Repetir gritar Cazador nocturno"
	L.custom_on_repeating_nighthunter_desc = "Repite mensajes en gritar para la habilidad Cazador nocturno utilizando íconos {rt1} o {rt2} o {rt3} para encontrar tu línea más fácilmente si tienes que hacer soak."

	L.custom_on_repeating_impale = "Repetir decir Empalar"
	L.custom_on_repeating_impale_desc = "Repite mensajes en decir para la habilidad empalar utilizando '1' or '22' or '333' or '4444' para dejar claro en qué orden te afectará."

	L.hymn_stacks = "Himno nathriano"
	L.hymn_stacks_desc = "Alerta el número de acumulaciones actuales de Himno nathriano en ti."

	L.ravage_target = "Reflejo: Devastar Barra de lanzamiento"
	L.ravage_target_desc = "Barra de lanzamiento que muestra el tiempo hasta que el reflejo apunta a un lugar para Devastar."
	L.ravage_targeted = "Destrozar dirigido" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sin espejo: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Espejo: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "esMX")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon descomunal"
	L.hawkeye = "Ojohalcón de Nathria"
	L.overseer = "Sobrestante de perrera"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Descarnador aterrador"
	L.rat = "Rata de tamaño inusual"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Anticuaria siniestra"
	L.conservator = "Conservador de Nathria"
	L.archivist = "Archivista de Nathria"
	L.hierarch = "Jerarca de la corte"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliat de la Legión Pétrea"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "esMX")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Chiribitas"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "esMX")
if L then
	--L.chains = "Chains" -- Chains of Eternity (Chains)
	--L.remnants = "Remnants" -- Remnant of Forgotten Torments (Remnants)

	--L.physical_remnant = "Physical Remnant"
	--L.magic_remnant = "Magic Remnant"
	--L.fire_remnant = "Fire Remnant"
	--L.fire = "Fire"
	--L.magic = "Magic"
	--L.physical = "Physical"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "esMX")
if L then
	--L.chains = "Chains" -- Short for Dragging Chains
	--L.death_gaze = "Death Gaze" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "esMX")
if L then
	--L.fragments = "Fragments" -- Short for Fragments of Destiny
	--L.fragment = "Fragment" -- Singular Fragment of Destiny
	--L.run_away = "Run Away" -- Wings of Rage
	--L.song = "Song" -- Short for Song of Dissolution
	--L.go_in = "Go in" -- Reverberating Refrain
	--L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	--L.blades = "Blades" -- Agatha's Eternal Blade
	--L.big_bombs = "Big Bombs" -- Daschla's Mighty Impact
	--L.big_bomb = "Big Bomb" -- Attached to the countdown
	--L.shield = "Shield" -- Annhylde's Bright Aegis
	--L.soaks = "Soaks" -- Aradne's Falling Strike
	--L.small_bombs = "Small Bombs" -- Brynja's Mournful Dirge
	--L.recall = "Recall" -- Short for Word of Recall

	--L.blades_yell = "Fall before my blade!"
	--L.soaks_yell = "You are all outmatched!"
	--L.shield_yell = "My shield never falters!"

	--L.berserk_stage1 = "Berserk Stage 1"
	--L.berserk_stage2 = "Berserk Stage 2"

	--L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "esMX")
if L then
	--L.cones = "Cones" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "esMX")
if L then
	--L.custom_off_nameplate_defiance = "Defiance Nameplate Icon"
	--L.custom_off_nameplate_defiance_desc = "Show an icon on the nameplate of Mawsworn that have Defiance.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	--L.custom_off_nameplate_tormented = "Tormented Nameplate Icon"
	--L.custom_off_nameplate_tormented_desc = "Show an icon on the nameplate of Mawsworn that have Tormented.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	--L.cones = "Cones" -- Torment
	--L.dance = "Dance" -- Encore of Torment
	--L.brands = "Brands" -- Brand of Torment
	--L.brand = "Brand" -- Single Brand of Torment
	--L.spike = "Spike" -- Short for Agonizing Spike
	--L.chains = "Chains" -- Hellscream
	--L.chain = "Chain" -- Soul Manacles
	--L.souls = "Souls" -- Rendered Soul

	--L.chains_remaining = "%d Chains remaining"
	--L.all_broken = "All Chains broken"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "esMX")
if L then
	--L.hammer = "Hammer" -- Short for Rippling Hammer
	--L.axe = "Axe" -- Short for Cruciform Axe
	--L.scythe = "Scythe" -- Short for Dualblade Scythe
	--L.trap = "Trap" -- Short for Flameclasp Trap
	--L.chains = "Chains" -- Short for Shadowsteel Chains
	--L.embers = "Embers" -- Short for Shadowsteel Embers
	--L.adds_embers = "Embers (%d) - Adds Next!"
	--L.adds_killed = "Adds killed in %.2fs"
	--L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "esMX")
if L then
	--L.bomb_missed = "%dx Bombs Missed"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "esMX")
if L then
	--L.rings = "Rings"
	--L.rings_active = "Rings Active" -- for when they activate/are movable
	--L.runes = "Runes"

	--L.grimportent_countdown = "Countdown"
	--L.grimportent_countdown_desc = "Countdown for the players who are Affected by Grim Portent"
	--L.grimportent_countdown_bartext = "Go to rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "esMX")
if L then
	--L.spikes = "Spikes" -- Short for Glacial Spikes
	--L.spike = "Spike"
	--L.miasma = "Miasma" -- Short for Sinister Miasma

	--L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	--L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frostbound Devoted that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "esMX")
if L then
	--L.chains_active = "Chains Active"
	--L.chains_active_desc = "Show a bar for when the Chains of Domination activate"

	--L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	--L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	--L.chains = "Chains" -- Short for Domination Chains
	--L.chain = "Chain" -- Single Domination Chain
	--L.darkness = "Darkness" -- Short for Veil of Darkness
	--L.arrow = "Arrow" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	--L.wave = "Wave" -- Short for Haunting Wave
	--L.dread = "Dread" -- Short for Crushing Dread
	--L.scream = "Scream" -- Banshee Scream

	--L.knife_fling = "Knives out!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "esMX")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Chiribitas"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "esMX")
if L then
	--L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "esMX")
if L then
	--L.tank_combo_desc = "Timer for Riftmaw/Rend casts at 100 energy."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "esMX")
if L then
	--L.sparknova = "Sparknova" -- Hyperlight Sparknova
	--L.relocation = "Tank Bomb" -- Glyph of Relocation
	--L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	--L.wormholes = "Wormholes" -- Interdimensional Wormholes
	--L.wormhole = "Wormhole" -- Interdimensional Wormhole
	--L.rings = "Rings S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "esMX")
if L then
	--L.staggering_barrage = "Barrage" -- Staggering Barrage
	--L.obliteration_arc = "Arc" -- Obliteration Arc

	--L.disintergration_halo = "Rings" -- Disintegration Halo
	--L.rings_x = "Rings x%d"
	--L.rings_enrage = "Rings (Enrage)"
	--L.ring_count = "Ring (%d/%d)"

	--L.custom_on_ring_timers = "Individual Halo Timers"
	--L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."

	--L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "esMX")
if L then
	--L.necrotic_ritual = "Ritual"
	--L.runecarvers_deathtouch = "Deathtouch"
	--L.windswept_wings = "Winds"
	--L.wild_stampede = "Stampede"
	--L.withering_seeds = "Seeds"
	--L.hand_of_destruction = "Hand"
	--L.nighthunter_marks_additional_desc = "|cFFFF0000Marking with a priority for melee on the first markers and using their raid group group position as secondary priority.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "esMX")
if L then
	--L.protoform_cascade = "Frontal"
	--L.cosmic_shift = "Pushback"
	--L.cosmic_shift_mythic = "Shift: %s"
	--L.unstable_mote = "Motes"
	--L.mote = "Mote"

	--L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	--L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate on Acquisitions Automa that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "esMX")
if L then
	--L.custom_off_repeating_blasphemy = "Repeating Blasphemy"
	--L.custom_off_repeating_blasphemy_desc = "Repeating Blasphemy say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	--L.kingsmourne_hungers = "Kingsmourne"
	--L.blasphemy = "Marks"
	--L.befouled_barrier = "Barrier"
	--L.wicked_star = "Star"
	--L.domination_word_pain = "DW:Pain"
	--L.army_of_the_dead = "Army"
	--L.grim_reflections = "Fear Adds"
	--L.march_of_the_damned = "Walls"
	--L.dire_blasphemy = "Marks"

	--L.remnant_active = "Remnant Active"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "esMX")
if L then
	--L.seismic_tremors = "Motes + Tremors"
	--L.earthbreaker_missiles = "Missiles"
	--L.crushing_prism = "Prisms"
	--L.prism = "Prism"
	L.ephemeral_fissure = "Fisura"

	--L.bomb_dropped = "Bomb dropped"
	--L.volatile_charges_new = "New Bombs!"

	--L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "esMX")
if L then
	--L.unto_darkness = "AoE Phase"
	--L.cloud_of_carrion = "Carrion"
	--L.empowered_cloud_of_carrion = "Big Carrion" -- Empowered Cloud of Carrion
	--L.leeching_claws = "Frontal (M)"
	--L.infiltration_of_dread = "Among Us"
	--L.infiltration_removed = "Imposters found in %.1fs" -- "Imposters found in 1.1s" s = seconds
	--L.fearful_trepidation = "Fears"
	--L.slumber_cloud = "Clouds"
	--L.anguishing_strike = "Frontal (K)"

	--L.custom_on_repeating_biting_wound = "Repeating Biting Wound"
	--L.custom_on_repeating_biting_wound_desc = "Repeating Biting Wound say messages with icons {rt7} to make it more visible."
end

L = BigWigs:NewBossLocale("Rygelon", "esMX")
if L then
	--L.celestial_collapse = "Quasars"
	--L.manifest_cosmos = "Cores"
	--L.stellar_shroud = "Heal Absorb"
	--L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "esMX")
if L then
	--L.rune_of_damnation_countdown = "Countdown"
	--L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	--L.jump = "Jump In"

	--L.relentless_domination = "Domination"
	--L.chains_of_oppression = "Pull Chains"
	--L.unholy_attunement = "Pylons"
	--L.shattering_blast = "Tank Blast"
	--L.rune_of_compulsion = "Charms"
	--L.desolation = "Azeroth Soak"
	--L.decimator_line = "Decimator + Line"
	--L.chains_of_anguish = "Spread Chains"
	--L.chain = "Chain"
	--L.chain_target = "Chaining %s!"
	--L.chains_remaining = "%d/%d Chains Broken"
	--L.rune_of_domination = "Group Soaks"

	--L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	--L.azeroth_health = "Azeroth Health"
	--L.azeroth_health_desc = "Azeroth Health Warnings"

	--L.azeroth_new_health_plus = "Azeroth Health: +%.1f%% (%d)"
	--L.azeroth_new_health_minus = "Azeroth Health: -%.1f%%  (%d)"

	--L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	--L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	--L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	--L.mythic_blood_soak_stage_2_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	--L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	--L.mythic_blood_soak_stage_3_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	--L.mythic_blood_soak_bar = "Heal Azeroth"

	--L.floors_open = "Floors Open"
	--L.floors_open_desc = "Time until the floors opens up and you can fall into opened holes."

	--L.mythic_dispel_stage_4 = "Dispel Timers"
	--L.mythic_dispel_stage_4_desc = "Timers for when to do dispels in the last stage, used by Echo on their first kill"
	--L.mythic_dispel_bar = "Dispels"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "esMX")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Chiribitas"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end
