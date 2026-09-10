-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "esES")
if L then
	--L.pickup_lantern = "%s picked up the lantern!"
	--L.dropped_lantern = "Lantern dropped by %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "esES")
if L then
	--L.killed = "%s Killed"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "esES")
if L then
	--L.shield_remaining = "%s remaining: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "esES")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--L.custom_on_repeating_yell_miasma = "Repeating Miasma Health Yell"
	--L.custom_on_repeating_yell_miasma_desc = "Repeating yell messages for Gluttonous Miasma to let others know when you are below 75% health."

	--L.custom_on_repeating_say_laser = "Repeating Volatile Ejection Say"
	--L.custom_on_repeating_say_laser_desc = "Repeating say messages for Volatile Ejection to help when moving into chat range of players that didn't see your first message."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "esES")
if L then
	L.tear = "Rasgadura" -- Short for Dimensional Tear
	L.seeds = "Semillas" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "esES")
if L then
	--L.times = "%dx %s"

	--L.level = "%s (Level |cffffff00%d|r)"
	--L.full = "%s (|cffff0000FULL|r)"

	--L.anima_adds = "Concentrate Anima Adds"
	--L.anima_adds_desc = "Show a timer for when adds spawn from the Concentrate Anima debuffs."

	--L.custom_off_experimental = "Enable experimental features"
	--L.custom_off_experimental_desc = "These features are |cffff0000not tested|r and could |cffff0000spam|r."

	--L.anima_tracking = "Anima Tracking |cffff0000(Experimental)|r"
	--L.anima_tracking_desc = "Messages and Bars to track anima levels in the containers.|n|cffaaff00Tip: You might want to disable the information box or bars, depending your preference."

	--L.desires = "Desires"
	--L.bottles = "Bottles"
	--L.sins = "Sins"
end

L = BigWigs:NewBossLocale("The Council of Blood", "esES")
if L then
	--L.custom_on_repeating_dark_recital = "Repeating Dark Recital"
	--L.custom_on_repeating_dark_recital_desc = "Repeating Dark Recital say messages with icons {rt1}, {rt2} to find your partner while dancing."

	--L.dance_assist = "Dance Assist"
	--L.dance_assist_desc = "Show directional warnings for the dancing stage."
	--L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dance Forward |T450907:0:0:0:0:64:64:4:60:4:60|t"
	--L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dance Right |T450908:0:0:0:0:64:64:4:60:4:60|t"
	--L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dance Down |T450905:0:0:0:0:64:64:4:60:4:60|t"
	--L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dance Left |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	--L.dance_yell_up = "Prance Forward" -- Prance Forward!
	--L.dance_yell_right = "Shimmy right" -- Shimmy right!
	--L.dance_yell_down = "Boogie down" -- Boogie down!
	--L.dance_yell_down_2 = "Boogie down" -- Boogie down!
	--L.dance_yell_left = "Sashay left" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "esES")
if L then
	--L.stomp_shift = "Stomp & Shift" -- Destructive Stomp + Seismic Shift

	--L.fun_info = "Damage Info"
	--L.fun_info_desc = "Display a message showing how much health the boss lost during Destructive Impact."

	--L.health_lost = "Sludgefist went down %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "esES")
if L then
	--L.first_blade = "First Blade"
	--L.second_blade = "Second Blade"

	--L.skirmishers = "Skirmishers" -- Short for Stone Legion Skirmishers
	L.eruption = "Erupción" -- Short for Reverberating Eruption

	--L.goliath_short = "Goliath"
	--L.goliath_desc = "Show warnings and timers for when the Stone Legion Goliath is going to spawn."

	--L.commando_short = "Commando"
	--L.commando_desc = "Show warnings when a Stone Legion Commando is killed."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "esES")
if L then
	--L.infobox_stacks = "%d |4Stack:Stacks;: %d |4player:players;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	--L.custom_on_repeating_nighthunter = "Repeating Night Hunter Yell"
	--L.custom_on_repeating_nighthunter_desc = "Repeating yell messages for the Night Hunter ability using icons {rt1} or {rt2} or {rt3} to find your line easier if you have to soak."

	--L.custom_on_repeating_impale = "Repeating Impale Say"
	--L.custom_on_repeating_impale_desc = "Repeating say messages for the Impale ability using '1' or '22' or '333' or '4444' to make it clear in what order you will be hit."

	--L.hymn_stacks = "Nathrian Hymn"
	--L.hymn_stacks_desc = "Alerts for the amount of Nathrian Hymn stacks currently on you."

	--L.ravage_target = "Reflection: Ravage Target Cast Bar"
	--L.ravage_target_desc = "Cast bar showing the time until the reflection targets a location for Ravage."
	--L.ravage_targeted = "Ravage Targeted" -- Text on the bar for when Ravage picks its location to target in stage 3

	--L.no_mirror = "No Mirror: %d" -- Player amount that does not have the Through the Mirror
	--L.mirror = "Mirror: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "esES")
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

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "esES")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	--L.creation_spark = "Sparks"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "esES")
if L then
	L.chains = "Cadenas" -- Chains of Eternity (Chains)
	L.remnants = "Remanentes" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Remanente Fisico"
	L.magic_remnant = "Remanente Magico"
	L.fire_remnant = "Remanente Fuego"
	L.fire = "Fuego"
	L.magic = "Magico"
	L.physical = "Fisico"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "esES")
if L then
	L.chains = "Cadenas" -- Short for Dragging Chains
	L.death_gaze = "Mirada Aniquiladora" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "esES")
if L then
	L.fragments = "Fragmentos" -- Short for Fragments of Destiny
	L.fragment = "Fragmento" -- Singular Fragment of Destiny
	L.run_away = "Corre" -- Wings of Rage
	L.song = "Cancion" -- Short for Song of Dissolution
	L.go_in = "Dentro" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Hojas" -- Agatha's Eternal Blade
	L.big_bombs = "Bombas grandes" -- Daschla's Mighty Impact
	L.big_bomb = "Gran Bomba" -- Attached to the countdown
	L.shield = "Escudo" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Bombas Pequeñas" -- Brynja's Mournful Dirge
	L.recall = "Palabra de regreso" -- Short for Word of Recall

	L.blades_yell = "¡Cae ante mi espada!"
	L.soaks_yell = "¡Estais superados!"
	L.shield_yell = "¡Mi escudo nunca flaquea!"

	L.berserk_stage1 = "Rabia Fase 1"
	L.berserk_stage2 = "Rabia Fase 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "esES")
if L then
	L.cones = "Conos" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "esES")
if L then
	L.custom_off_nameplate_defiance = "Icono de placa de nombre de desafio"
	L.custom_off_nameplate_defiance_desc = "Muestra un icono en la placa de nombre del Agonizador jurafauce que tiene Desafio.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icono placa de nombre atormentado"
	L.custom_off_nameplate_tormented_desc = "Muestra un icono en la placa de nombre del Agonizador jurafauce que tiene Atormentado.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	L.cones = "Cono" -- Torment
	L.dance = "Baile" -- Encore of Torment
	L.brands = "Marcas" -- Brand of Torment
	L.brand = "Marca" -- Single Brand of Torment
	L.spike = "Nova" -- Short for Agonizing Spike
	L.chains = "Cadenas" -- Hellscream
	L.chain = "Cadena" -- Soul Manacles
	L.souls = "Almas" -- Rendered Soul

	L.chains_remaining = "%d Cadenas restantes"
	L.all_broken = "Todas las cadenas rotas"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "esES")
if L then
	L.hammer = "Martillo" -- Short for Rippling Hammer
	L.axe = "Hacha" -- Short for Cruciform Axe
	L.scythe = "Guadaña" -- Short for Dualblade Scythe
	L.trap = "Trampa" -- Short for Flameclasp Trap
	L.chains = "Cadenas" -- Short for Shadowsteel Chains
	L.embers = "Ascuas" -- Short for Shadowsteel Embers
	L.adds_embers = "Ascuas (%d) - Adds Next!"
	L.adds_killed = "Adds matados en %.2fs"
	L.spikes = "Muerte con pinchos" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "esES")
if L then
	L.bomb_missed = "%dx Bombas Falladas"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "esES")
if L then
	L.rings = "Anillos"
	L.rings_active = "Anillos Activos" -- for when they activate/are movable
	L.runes = "Runas"

	L.grimportent_countdown = "Cuenta atras"
	L.grimportent_countdown_desc = "Cuenta atras para los jugadores que estan afectados por Portar Oscuridad"
	L.grimportent_countdown_bartext = "¡Ve a la runa!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "esES")
if L then
	L.spikes = "Pinchos" -- Short for Glacial Spikes
	L.spike = "Pincho"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Icono placa de nombre Fijado"
	L.custom_on_nameplate_fixate_desc = "Muestra un icono en la placa de nombre del Devoto ligado a la Escarcha que se fija en ti.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "esES")
if L then
	L.chains_active = "Cadenas Activas"
	L.chains_active_desc = "Muestra una barra para cuando Cadenas de Dominacion se activan"

	L.custom_on_nameplate_fixate = "Icono placa de nombre Fijado"
	L.custom_on_nameplate_fixate_desc = "Muestra un icono en la placa de nombre del Centinela Oscuro que se fija en ti.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Cadenas" -- Short for Domination Chains
	L.chain = "Cadena" -- Single Domination Chain
	L.darkness = "Oscuridad" -- Short for Veil of Darkness
	L.arrow = "Flecha" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Ola" -- Short for Haunting Wave
	L.dread = "Terror" -- Short for Crushing Dread
	L.scream = "Alarido" -- Banshee Scream

	L.knife_fling = "¡Cuchillas fuera!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "esES")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	--L.creation_spark = "Sparks"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "esES")
if L then
	--L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "esES")
if L then
	--L.tank_combo_desc = "Timer for Riftmaw/Rend casts at 100 energy."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "esES")
if L then
	--L.sparknova = "Sparknova" -- Hyperlight Sparknova
	--L.relocation = "Tank Bomb" -- Glyph of Relocation
	--L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	--L.wormholes = "Wormholes" -- Interdimensional Wormholes
	--L.wormhole = "Wormhole" -- Interdimensional Wormhole
	--L.rings = "Rings S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "esES")
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

L = BigWigs:NewBossLocale("Prototype Pantheon", "esES")
if L then
	--L.necrotic_ritual = "Ritual"
	--L.runecarvers_deathtouch = "Deathtouch"
	--L.windswept_wings = "Winds"
	--L.wild_stampede = "Stampede"
	--L.withering_seeds = "Seeds"
	--L.hand_of_destruction = "Hand"
	--L.nighthunter_marks_additional_desc = "|cFFFF0000Marking with a priority for melee on the first markers and using their raid group position as secondary priority.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "esES")
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

L = BigWigs:NewBossLocale("Anduin Wrynn", "esES")
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

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "esES")
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

L = BigWigs:NewBossLocale("Lords of Dread", "esES")
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

L = BigWigs:NewBossLocale("Rygelon", "esES")
if L then
	--L.celestial_collapse = "Quasars"
	--L.manifest_cosmos = "Cores"
	--L.stellar_shroud = "Heal Absorb"
	--L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "esES")
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

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "esES")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	--L.creation_spark = "Sparks"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end
