-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "deDE")
if L then
	L.pickup_lantern = "%s hat die Laterne aufgenommen!"
	L.dropped_lantern = "Laterne fallengelassen von %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "deDE")
if L then
	L.killed = "%s getötet"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "deDE")
if L then
	L.shield_remaining = "%s verbleibend: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "deDE")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Wiederholtes Miasma Gesundheit Schreien"
	L.custom_on_repeating_yell_miasma_desc = "Gibt wiederholt Schrei-Nachrichten für Gefräßiges Miasma aus, damit Mitspieler merken, wenn Du unter 75% Gesundheit bist."

	L.custom_on_repeating_say_laser = "Wiederholte Instabiler Ausstoß Ansage"
	L.custom_on_repeating_say_laser_desc = "Gibt wiederholt Chatnachrichten für Instabilen Ausstoß aus um beim Annähern an Spieler in Reichweite der Chatnachrichten zu helfen, falls diese die erste Nachricht nicht gelesen haben."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "deDE")
if L then
	L.tear = "Riss" -- Short for Dimensional Tear
	L.seeds = "Saaten" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "deDE")
if L then
	L.times = "%dx %s"

	L.level = "%s (Stufe |cffffff00%d|r)"
	L.full = "%s (|cffff0000VOLL|r)"

	L.anima_adds = "Konzentrierte Anima Adds"
	L.anima_adds_desc = "Zeigt einen Timer für die erscheinenden Adds vom Debuff Konzentrierte Anima."

	L.custom_off_experimental = "Experimentelle Funktionen aktivieren"
	L.custom_off_experimental_desc = "Diese Funktionen wurden |cffff0000nicht getestet|r und können |cffff0000spammen|r."

	L.anima_tracking = "Anima Verfolgung |cffff0000(Experimentell)|r"
	L.anima_tracking_desc = "Nachrichten und Leisten zur Verfolgung der Anima-Level in den Behältern.|n|cffaaff00Tip: Informationsboxen oder Balken nach Belieben deaktivieren."

	L.desires = "Begierden"
	L.bottles = "Flaschen"
	L.sins = "Sünden"
end

L = BigWigs:NewBossLocale("The Council of Blood", "deDE")
if L then
	L.custom_on_repeating_dark_recital = "Wiederholte Dunkler Vortrag Ansage"
	L.custom_on_repeating_dark_recital_desc = "Gibt wiederholt Chatnachrichten mit den Symbolen {rt1}, {rt2} aus, um den Partner beim Tanzen zu finden."

	L.dance_assist = "Tanzassistent"
	L.dance_assist_desc = "Zeigt an, in welche Richtung beim Tanzen gelaufen werden muss."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Tanze vorwärts |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Tanze nach rechts |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Tanze nach unten |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Tanze nach links |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Tänzelt vorwärts" -- Tänzelt vorwärts!
	L.dance_yell_right = "Schlenker nach rechts" -- Schlenker nach rechts!
	L.dance_yell_down = "Tänzelt nach unten" -- Tänzelt nach unten!
	L.dance_yell_down_2 = "Tänzelt nach unten" -- Tänzelt nach unten!
	L.dance_yell_left = "Gleitet nach links" -- Gleitet nach links!
end

L = BigWigs:NewBossLocale("Sludgefist", "deDE")
if L then
	L.stomp_shift = "Stampfen & Verschiebung" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Schadensinfo"
	L.fun_info_desc = "Zeigt eine Nachricht mit der verlorenen Gesundheit des Bosses während dem Zerstörerischen Einschlag."

	L.health_lost = "Schlickfaust hat %.1f%% verloren!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "deDE")
if L then
	L.first_blade = "Erste Klinge" -- Wicked Blade
	L.second_blade = "Zweite Klinge"

	L.skirmishers = "Scharmützlerinnen" -- Short for Stone Legion Skirmishers
	L.eruption = "Eruption" -- Short for Reverberating Eruption

	L.goliath_short = "Goliath"
	L.goliath_desc = "Zeigt Warnungen und Timer für das Erscheinen eines Goliaths der Steinlegion."

	L.commando_short = "Kommandosoldat"
	L.commando_desc = "Zeigt Warnungen wenn ein Kommandosoldat der Steinlegion getötet wird."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "deDE")
if L then
	L.infobox_stacks = "%d |4Stapel:Stapel;: %d |4Spieler:Spieler;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Wiederholtes Nachtjäger Schreien"
	L.custom_on_repeating_nighthunter_desc = "Gibt wiederholt Schrei-Nachrichten für die Nachtjäger Fähigkeit mit den Symbolen {rt1} oder {rt2} oder {rt3} aus, um die Linie zum Abfangen leichter zu finden."

	L.custom_on_repeating_impale = "Wiederholte Durchbohren Ansage"
	L.custom_on_repeating_impale_desc = "Gibt wiederholt Chatnachrichten für die Durchbohren Fähigkeit mit '1' oder '22' oder '333' oder '4444' aus, um die Reihenfolge der Angriffe zu verdeutlichen."

	L.hymn_stacks = "Hymne von Nathria"
	L.hymn_stacks_desc = "Benachrichtigungen für die aktuelle Stapelanzahl von Hymne von Nathria auf dem Spieler."

	L.ravage_target = "Reflexion: Verheeren Ziel Zauberleiste"
	L.ravage_target_desc = "Zeigt eine Zauberleiste mit der verbleibenden Zeit bis die Reflexion einen Ort für Verheeren anvisiert."
	L.ravage_targeted = "Verheeren anvisiert" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Kein Spiegel: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Spiegel: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "deDE")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Bulliger Gargon"
	L.hawkeye = "Scharfschütze von Nathria"
	L.overseer = "Zwingeraufseherin"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Schreckensschmauser"
	L.rat = "Ungewöhnlich große Ratte"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Finstere Antiquarin"
	L.conservator = "Konservator von Nathria"
	L.archivist = "Archivarin von Nathria"
	L.hierarch = "Hofhierarchin"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliath der Steinlegion"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "deDE")
if L then
	L.custom_on_bar_icon = "Leistensymbol"
	L.custom_on_bar_icon_desc = "Zeigt das Schicksalhafte Schlachtzugssymbol in den Leisten."

	L.chaotic_essence = "Essenz"
	L.creation_spark = "Funken"
	L.protoform_barrier = "Barriere"
	L.reconfiguration_emitter = "Zauber-Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "deDE")
if L then
	L.chains = "Ketten" -- Chains of Eternity (Chains)
	L.remnants = "Überreste" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Physischer Überrest"
	L.magic_remnant = "Magischer Überest"
	L.fire_remnant = "Feuer-Überrest"
	L.fire = "Feuer"
	L.magic = "Magisch"
	L.physical = "Physisch"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "deDE")
if L then
	L.chains = "Ketten" -- Short for Dragging Chains
	L.death_gaze = "Todesblick" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "deDE")
if L then
	L.fragments = "Fragmente" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Lauf weg" -- Wings of Rage
	L.song = "Lied" -- Short for Song of Dissolution
	L.go_in = "Lauf rein" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Klingen" -- Agatha's Eternal Blade
	L.big_bombs = "Große Bomben" -- Daschla's Mighty Impact
	L.big_bomb = "Große Bombe" -- Attached to the countdown
	L.shield = "Schild" -- Annhylde's Bright Aegis
	L.soaks = "Abfangen" -- Aradne's Falling Strike
	L.small_bombs = "Kleine Bomben" -- Brynja's Mournful Dirge
	L.recall = "Rückruf" -- Short for Word of Recall

	L.blades_yell = "Fallt durch meine Klinge!"
	L.soaks_yell = "Ihr seid alle unterlegen!"
	L.shield_yell = "Mein Schild versagt nie!"

	L.berserk_stage1 = "Berserker Phase 1"
	L.berserk_stage2 = "Berserker Phase 2"

	--L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "deDE")
if L then
	L.cones = "Kegel" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "deDE")
if L then
	L.custom_off_nameplate_defiance = "Trotz Namensplakettensymbol"
	L.custom_off_nameplate_defiance_desc = "Zeigt ein Symbol an der Namensplakette der mit Trotz belegten Schlundgebundenen.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Gequält Namensplakettensymbol"
	L.custom_off_nameplate_tormented_desc = "Zeigt ein Symbol an der Namensplakette der gequälten Schlundgebundenen.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.cones = "Kegel" -- Torment
	L.dance = "Tanz" -- Encore of Torment
	L.brands = "Male" -- Brand of Torment
	L.brand = "Mal" -- Single Brand of Torment
	L.spike = "Stachel" -- Short for Agonizing Spike
	L.chains = "Ketten" -- Hellscream
	L.chain = "Kette" -- Soul Manacles
	L.souls = "Seelen" -- Rendered Soul

	L.chains_remaining = "%d Ketten übrig"
	L.all_broken = "Alle Ketten gebrochen"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "deDE")
if L then
	L.hammer = "Hammer" -- Short for Rippling Hammer
	L.axe = "Axt" -- Short for Cruciform Axe
	L.scythe = "Sichel" -- Short for Dualblade Scythe
	L.trap = "Falle" -- Short for Flameclasp Trap
	L.chains = "Ketten" -- Short for Shadowsteel Chains
	L.embers = "Glut" -- Short for Shadowsteel Embers
	L.adds_embers = "Glut (%d) - Adds als Nächstes!"
	L.adds_killed = "Adds in %.2fs getötet"
	L.spikes = "Stacheliger Tod" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "deDE")
if L then
	 L.bomb_missed = "%dx Bomben verfehlt"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "deDE")
if L then
	L.rings = "Ringe"
	L.rings_active = "Ringe aktiv" -- for when they activate/are movable
	L.runes = "Runen"

	L.grimportent_countdown = "Countdown"
	L.grimportent_countdown_desc = "Countdown für die von Finsteres Omen betroffenen Spieler"
	L.grimportent_countdown_bartext = "Geh zur Rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "deDE")
if L then
	L.spikes = "Stacheln" -- Short for Glacial Spikes
	L.spike = "Stachel"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Frostgebundenen Ergebenen an.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "deDE")
if L then
	L.chains_active = "Ketten aktiv"
	L.chains_active_desc = "Zeigt einen Timer für die Aktivierung der Herrschaftsketten"

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette der Dich fixierenden Dunklen Wache an.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Ketten" -- Short for Domination Chains
	L.chain = "Kette" -- Single Domination Chain
	L.darkness = "Dunkelheit" -- Short for Veil of Darkness
	L.arrow = "Pfeil" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Welle" -- Short for Haunting Wave
	L.dread = "Angst" -- Short for Crushing Dread
	L.scream = "Kreischen" -- Banshee Scream

	L.knife_fling = "Messer fliegen!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "deDE")
if L then
	L.custom_on_bar_icon = "Leistensymbol"
	L.custom_on_bar_icon_desc = "Zeigt das Schicksalhafte Schlachtzugssymbol in den Leisten."

	L.chaotic_essence = "Essenz"
	L.creation_spark = "Funken"
	L.protoform_barrier = "Barriere"
	L.reconfiguration_emitter = "Zauber-Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "deDE")
if L then
	L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "deDE")
if L then
	L.tank_combo_desc = "Timer für die Fähigkeiten Rissschlund/Verwunden bei 100 Energie."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "deDE")
if L then
	L.sparknova = "Funkennova" -- Hyperlight Sparknova
	L.relocation = "Tank Bombe" -- Glyph of Relocation
	L.relocation_count = "%s P%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Wurmlöcher" -- Interdimensional Wormholes
	L.wormhole = "Wurmloch" -- Interdimensional Wormhole
	L.rings = "Ringe P%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "deDE")
if L then
	L.staggering_barrage = "Bombardement" -- Staggering Barrage
	L.obliteration_arc = "Bogen" -- Obliteration Arc

	L.disintergration_halo = "Ringe" -- Disintegration Halo
	L.rings_x = "Ringe x%d"
	L.rings_enrage = "Ringe (Berserker)"
	L.ring_count = "Ring (%d/%d)"

	L.custom_on_ring_timers = "Individuelle Kranz Timer"
	L.custom_on_ring_timers_desc = "Desintegrationskranz löst Ringe aus. Dies zeigt Leisten für den Bewegungsbeginn jedes Rings. Nutzt die Einstellungen von Desintegrationskranz."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "deDE")
if L then
	L.necrotic_ritual = "Ritual"
	L.runecarvers_deathtouch = "Todesberührung"
	L.windswept_wings = "Stürme"
	L.wild_stampede = "Stampede"
	L.withering_seeds = "Samen"
	L.hand_of_destruction = "Hand"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Markiert mit Priorität für Nahkämpfer bei den ersten Markierungen und nutzt ihre Raidgruppen-Position als sekundäre Priorität.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "deDE")
if L then
	L.protoform_cascade = "Kreis"
	L.cosmic_shift = "Rückstoß"
	L.cosmic_shift_mythic = "Verschiebung: %s"
	L.unstable_mote = "Partikel"
	L.mote = "Partikel"

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Akquisitionsautomas an.\n\nBenötigt die Nutzung von gegnerischen Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.harmonic = "Drücken"
	L.melodic = "Ziehen"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "deDE")
if L then
	L.seismic_tremors = "Partikel + Beben" -- Seismic Tremors
	L.earthbreaker_missiles = "Geschosse" -- Earthbreaker Missiles
	L.crushing_prism = "Prismen" -- Crushing Prism
	L.prism = "Prisma"
	L.ephemeral_fissure = "Bodenriss"

	L.bomb_dropped = "Bombe fallen gelassen"
	L.volatile_charges_new = "Neue Bomben!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "deDE")
if L then
	L.custom_off_repeating_blasphemy = "Blasphemie wiederholen"
	L.custom_off_repeating_blasphemy_desc = "Gibt wiederholt Blasphemie Chatnachrichten mit Symbolen {rt1}, {rt3} aus um das entgegengesetzte Mal zu finden."

	L.kingsmourne_hungers = "Königsgram"
	L.blasphemy = "Male"
	L.befouled_barrier = "Barriere"
	L.wicked_star = "Stern"
	L.domination_word_pain = "WdH:Schmerz"
	L.army_of_the_dead = "Armee"
	L.grim_reflections = "Furcht Adds"
	L.march_of_the_damned = "Wände"
	L.dire_blasphemy = "Male"

	L.remnant_active = "Überrest aktiv"
end

L = BigWigs:NewBossLocale("Lords of Dread", "deDE")
if L then
	L.unto_darkness = "AoE Phase"-- Unto Darkness
	L.cloud_of_carrion = "Fäulnis" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "Große Fäulnis" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontal (M)" -- Leeching Claws
	L.infiltration_of_dread = "Unter uns" -- Infiltration of Dread
	L.infiltration_removed = "Verräter gefunden in %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Furcht" -- Fearful Trepidation
	L.slumber_cloud = "Wolken" -- Slumber Cloud
	L.anguishing_strike = "Frontal (K)" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "Beißende Wunden wiederholen"
	L.custom_on_repeating_biting_wound_desc = "Gibt wiederholt Beißende Wunden Chatnachrichten mit Symbol {rt7} aus, um es sichtbarer zu machen."
end

L = BigWigs:NewBossLocale("Rygelon", "deDE")
if L then
	L.celestial_collapse = "Quasare" -- Celestial Collapse
	L.manifest_cosmos = "Kerne" -- Manifest Cosmos
	L.stellar_shroud = "Heilung absorbiert" -- Stellar Shroud
	L.knock = "Rückstoß" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "deDE")
if L then
	L.rune_of_damnation_countdown = "Countdown"
	L.rune_of_damnation_countdown_desc = "Countdown für Spieler welche von Rune der Verdammnis betroffen sind."
	L.jump = "Reinspringen"

	L.relentless_domination = "Herrschaft"
	L.chains_of_oppression = "Ketten zerreißen"
	L.unholy_attunement = "Pylonen"
	L.shattering_blast = "Tank Eruption"
	L.rune_of_compulsion = "Übernahme"
	L.desolation = "Azeroth-Soak"
	L.decimator_line = "Dezimierer + Linie"
	L.chains_of_anguish = "Ketten auseinander"
	L.chain = "Kette"
	L.chain_target = "Kette auf %s!"
	L.chains_remaining = "%d/%d Ketten gebrochen"
	L.rune_of_domination = "Gruppensoak"

	L.final = "Letzte %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Azeroths Lebenskraft"
	L.azeroth_health_desc = "Azeroths Lebenskraft Warnungen"

	L.azeroth_new_health_plus = "Azeroths Lebenskraft: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Azeroths Lebenskraft: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Phase 1 Blut-Soak Timer"
	L.mythic_blood_soak_stage_1_desc = "Zeigt eine Leiste mit guten Zeitpunkten zum Heilen von Azeroth an, genutzt von Echo beim ersten Kill."
	L.mythic_blood_soak_stage_2 = "Phase 2 Blut-Soak Timer"
	L.mythic_blood_soak_stage_2_desc = "Zeigt eine Leiste mit guten Zeitpunkten zum Heilen von Azeroth an, genutzt von Echo beim ersten Kill."
	L.mythic_blood_soak_stage_3 = "Phase 3 Blut-Soak Timer"
	L.mythic_blood_soak_stage_3_desc = "Zeigt eine Leiste mit guten Zeitpunkten zum Heilen von Azeroth an, genutzt von Echo beim ersten Kill."
	L.mythic_blood_soak_bar = "Azeroth heilen"

	L.floors_open = "Boden offen"
	L.floors_open_desc = "Zeit bis der Boden sich öffnet und Ihr in geöffnete Löcher fallen könnt."

	L.mythic_dispel_stage_4 = "Dispel Timer"
	L.mythic_dispel_stage_4_desc = "Timer für den Zeitpunkt zum Dispellen in der letzten Phase, genutzt von Echo beim ersten Kill"
	L.mythic_dispel_bar = "Dispels"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "deDE")
if L then
	L.custom_on_bar_icon = "Leistensymbol"
	L.custom_on_bar_icon_desc = "Zeigt das Schicksalhafte Schlachtzugssymbol in den Leisten."

	L.chaotic_essence = "Essenz"
	L.creation_spark = "Funken"
	L.protoform_barrier = "Barriere"
	L.reconfiguration_emitter = "Zauber-Add"
end
