-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "frFR")
if L then
	L.pickup_lantern = "%s a ramassé la lanterne !"
	L.dropped_lantern = "Lanterne posée par %s !"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "frFR")
if L then
	L.killed = "%s tué"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "frFR")
if L then
	L.shield_remaining = "%s restant : %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "frFR")
if L then
	L.miasma = "Miasme" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Répéter Vie sous Miasme en /crier"
	L.custom_on_repeating_yell_miasma_desc = "Répète des messages en /crier pour Miasme glouton afin d'indiquer aux autres quand vous êtes en dessous de 75% de vie."

	L.custom_on_repeating_say_laser = "Répéter Expulsion instable en /dire"
	L.custom_on_repeating_say_laser_desc = "Répète des messages en /dire pour Expulsion instable afin de vous aider quand vous vous déplacez à portée de discussion des joueurs qui n'ont pas vu votre premier message."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "frFR")
if L then
	L.tear = "Déchirure" -- Short for Dimensional Tear
	L.seeds = "Graines" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "frFR")
if L then
	L.times = "%dx %s"

	L.level = "%s (niveau |cffffff00%d|r)"
	L.full = "%s (|cffff0000PLEIN|r)"

	L.anima_adds = "Adds de l'Anima concentré"
	L.anima_adds_desc = "Affiche un délai indiquant quand les adds apparaissent des affaiblissements de Anima concentré."

	L.custom_off_experimental = "Activer les options expérimentales"
	L.custom_off_experimental_desc = "Ces options |cffff0000ne sont pas testées|r et pourraient |cffff0000spam|r."

	L.anima_tracking = "Suivi de l'anima |cffff0000(expérimental)|r"
	L.anima_tracking_desc = "Messages et barres pour suivre le niveau d'anima dans les conteneurs.|n|cffaaff00Astuce : vous pouvez désactiver les barres et boites d'infos si besoin."

	L.desires = "Désirs"
	L.bottles = "Bouteilles"
	L.sins = "Vices"
end

L = BigWigs:NewBossLocale("The Council of Blood", "frFR")
if L then
	L.custom_on_repeating_dark_recital = "Répéter Sombre Recital"
	L.custom_on_repeating_dark_recital_desc = "Répéter Sombre Recital en /dire avec les icônes {rt1}, {rt2} pendant la danse."

	L.dance_assist = "Assistant danse"
	L.dance_assist_desc = "Affiche des alertes directionelles pour la phase de danse."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'avant |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dansez vers la droite |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'arrière |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dansez vers la gauche |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Faites un entrechat" -- Faites un entrechat !
	L.dance_yell_right = "On se trémousse" -- On se trémousse à droite ! -or- On se trémousse vers la droite maintenant !
	L.dance_yell_down = "En avant le boogie" -- En avant le boogie !
	L.dance_yell_down_2 = "En avant le boogie" -- En avant le boogie !
	L.dance_yell_left = "Déhanché à gauche" -- Déhanché à gauche !
end

L = BigWigs:NewBossLocale("Sludgefist", "frFR")
if L then
	L.stomp_shift = "Piétinement & Transfert" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Info des dégâts"
	L.fun_info_desc = "Affiche un message indiquant combien de vie le boss a perdu durant Impact destructeur."

	L.health_lost = "Fangepoing a perdu %.1f%% !"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "frFR")
if L then
	L.first_blade = "Premier rebond"
	L.second_blade = "Deuxième rebond"

	L.skirmishers = "Tirailleuses" -- Short for Stone Legion Skirmishers (Tirailleuse de la Légion de pierre)
	L.eruption = "Éruption" -- Short for Reverberating Eruption

	L.goliath_short = "Goliath"
	L.goliath_desc = "Affiche des alertes et des délais indiquant quand le Goliath vive-pierre est sur le point d'apparaître."

	L.commando_short = "Commando"
	L.commando_desc = "Affiche des alertes quand un Commando de la Légion de pierre est tué."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "frFR")
if L then
	L.infobox_stacks = "%d |4cumul:cumuls; : %d |4joueur:joueurs;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Répéter Chasseur nocture en /cri"
	L.custom_on_repeating_nighthunter_desc = "Répète des messages en /cri pour Chasseur nocture en utilisant les icônes {rt1}, {rt2} ou {rt3} afin de trouver plus facilement votre ligne si vous devez soak."

	L.custom_on_repeating_impale = "Répéter Empaler en /dire"
	L.custom_on_repeating_impale_desc = "Répète des messages en /dire pour Empaler en utilisant '1', '22', '333' ou '4444' afin d'indiquer dans quel ordre vous serez touché."

	L.hymn_stacks = "Hymne nathrian"
	L.hymn_stacks_desc = "Alertes indiquant les cumuls de Hymne nathrian que vous avez sur vous."

	L.ravage_target = "Barre d'incantation cible de Reflet : Ravage"
	L.ravage_target_desc = "Barre d'incantation indiquant le temps avant que le reflet ne cible un emplacement pour Ravage."
	L.ravage_targeted = "Ravage ciblé" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sans Miroir : %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Miroir : %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "frFR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon massif"
	L.hawkeye = "Oeil-de-faucon nathrian"
	L.overseer = "Surveillante des Chenils"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Festoyeur de l'effroi"
	L.rat = "Rat de taille inhabituelle"
	L.miasma = "Miasme" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquaire sinistre"
	L.conservator = "Conservateur nathrian"
	L.archivist = "Archiviste nathriane"
	L.hierarch = "Hiérarque de la cour"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliath vive-pierre"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "frFR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Etincelles"
	L.protoform_barrier = "Barrière"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "frFR")
if L then
	L.chains = "Chaînes" -- Chains of Eternity (Chains)
	L.remnants = "Vestiges de tourment oubliés" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Vestige Physique"
	L.magic_remnant = "Vestige Magique"
	L.fire_remnant = "Vestige de Feu"
	L.fire = "Feu"
	L.magic = "Magique"
	L.physical = "Physique"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "frFR")
if L then
	L.chains = "Chaînes" -- Short for Dragging Chains
	L.death_gaze = "Rayon" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "frFR")
if L then
	L.fragments = "Fragments" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Fuyez" -- Wings of Rage
	L.song = "Chant" -- Short for Song of Dissolution
	L.go_in = "Rentrez" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Lames d'Agatha" -- Agatha's Eternal Blade
	L.big_bombs = "Grosses Bombes" -- Daschla's Mighty Impact
	L.big_bomb = "Grosse Bombe" -- Attached to the countdown
	L.shield = "Shield" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Petites Bombes" -- Brynja's Mournful Dirge
	L.recall = "Rappel" -- Short for Word of Recall

	L.blades_yell = "Tombez sous ma lame !"
	L.soaks_yell = "Vous êtes tous surpassés !"
	L.shield_yell = "Mon bouclier ne faiblit jamais !"

	L.berserk_stage1 = "Berserk 1"
	L.berserk_stage2 = "Berserk 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "frFR")
if L then
	L.cones = "Cônes" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "frFR")
if L then
	L.custom_off_nameplate_defiance = "Icône de Résistance"
	L.custom_off_nameplate_defiance_desc = "Affiche une icône au dessus du Suzerain antrelige si il est affecté par Résistance.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icône de Tourmenté"
	L.custom_off_nameplate_tormented_desc = "Affiche une icône au dessus du Suzerain antrelige si il est affecté par Tourment.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	L.cones = "Cônes" -- Torment
	L.dance = "Dance" -- Encore of Torment
	L.brands = "Marques" -- Brand of Torment
	L.brand = "Marque" -- Single Brand of Torment
	L.spike = "Nova" -- Short for Agonizing Spike
	L.chains = "Chaînes" -- Hellscream
	L.chain = "Chaînes" -- Soul Manacles
	L.souls = "Âmes" -- Rendered Soul

	L.chains_remaining = "%d Chaînes restantes"
	L.all_broken = "Chaînes Cassées"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "frFR")
if L then
	L.hammer = "Marteau" -- Short for Rippling Hammer
	L.axe = "Hâche" -- Short for Cruciform Axe
	L.scythe = "Faux" -- Short for Dualblade Scythe
	L.trap = "Pièges" -- Short for Flameclasp Trap
	L.chains = "Chaînes" -- Short for Shadowsteel Chains
	L.embers = "Braises" -- Short for Shadowsteel Embers
	L.adds_embers = "Braises (%d) - Puis Adds !"
	L.adds_killed = "Adds tués en %.2fs"
	L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "frFR")
if L then
	L.bomb_missed = "%dx Bombes Râtées"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "frFR")
if L then
	L.rings = "Anneaux"
	L.rings_active = "Anneaux Actifs" -- for when they activate/are movable
	L.runes = "Runes"

	L.grimportent_countdown = "Décompte"
	L.grimportent_countdown_desc = "Décompte pour les joueurs affectés par Sombre Présage"
	L.grimportent_countdown_bartext = "Allez sur une Rune !"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "frFR")
if L then
	L.spikes = "Piques de Glace" -- Short for Glacial Spikes
	L.spike = "Pique de Glace"
	L.miasma = "Miasme" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Icône de Fixation"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône au dessus du Fidèle givre-lié si vous êtes sa cible.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "frFR")
if L then
	L.chains_active = "Chaînes Actives"
	L.chains_active_desc = "Affiche une barre quand les chaînes de domination sont activées"

	L.custom_on_nameplate_fixate = "Icône de Rage"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône au dessus de la Sentinelle sombre si vous êtes sa cible. \n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Chaînes" -- Short for Domination Chains
	L.chain = "Chaîne" -- Single Domination Chain
	L.darkness = "Voile" -- Short for Veil of Darkness
	L.arrow = "Flèche" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Vague" -- Short for Haunting Wave
	L.dread = "Effroi" -- Short for Crushing Dread
	L.scream = "Cri" -- Banshee Scream

	L.knife_fling = "Poignards, Sortez !" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "frFR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Etincelles"
	L.protoform_barrier = "Barrière"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "frFR")
if L then
	--L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.tank_combo_desc = "Timer pour les cast de Mâche-faille/Pourfendre à 100 d'energie."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "frFR")
if L then
	L.sparknova = "Nova éclair" -- Hyperlight Sparknova
	L.relocation = "Bombe sur le tank" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Tunnels spatiotemporels" -- Interdimensional Wormholes
	L.wormhole = "Tunnel spatiotemporel" -- Interdimensional Wormhole
	L.rings = "Anneaux S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "frFR")
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Anneaux" -- Disintegration Halo
	L.rings_x = "Anneaux x%d"
	L.rings_enrage = "Anneaux (Enragé)"
	L.ring_count = "Anneau (%d/%d)"

	L.custom_on_ring_timers = "Décomptes Individuels de Halo de Désintégration"
	L.custom_on_ring_timers_desc = "Halo de Désintégration va déclencher un combo d'anneaux. Ainsi des barres seront affichées pour chaque anneau qui apparaîtra."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Rafale"
	L.wild_stampede = "Ruée"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Pose des marques sur les joueurs en priorisant les corps à corps et ensuite selon la position des joueurs.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Poussée"
	L.cosmic_shift_mythic = "Poussée (Mythique): %s"
	L.unstable_mote = "Granules"
	L.mote = "Granule"

	L.custom_on_nameplate_fixate = "Icône de barre d'unité fixée"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur la barre de nom d'unité des Automas pourvoyeurs qui vous fixent.\n\nNécessite d'avoir activé les barres de noms des unités ennemies et un addon de barres de noms compatible (KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "frFR")
if L then
	L.custom_off_repeating_blasphemy = "Répéter Blasphème"
	L.custom_off_repeating_blasphemy_desc = "Répéter Blasphème affiche un message en /dire avec les icônes {rt1}, {rt3} pour trouver une marque permettant d'enlever le débuff."

	L.kingsmourne_hungers = "Deuilleroi"
	L.blasphemy = "Marques"
	L.befouled_barrier = "Barrière"
	L.wicked_star = "Etoile"
	L.domination_word_pain = "MD : Douleur"
	L.army_of_the_dead = "Armée"
	L.grim_reflections = "Adds qui fear"
	L.march_of_the_damned = "Murs"
	L.dire_blasphemy = "Marques"

	L.remnant_active = "Vestige actif"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "frFR")
if L then
	L.seismic_tremors = "Fissures + Secousses Sismiques"
	L.earthbreaker_missiles = "Missiles"
	L.crushing_prism = "Prismes écrasants"
	L.prism = "Prisme"
	L.ephemeral_fissure = "Fissure"

	L.bomb_dropped = "Bombe posée"
	--L.volatile_charges_new = "New Bombs!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "frFR")
if L then
	L.unto_darkness = "AoE Phase"
	L.cloud_of_carrion = "Nuée de charognards"
	L.empowered_cloud_of_carrion = "Aura de charognards" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontal (M)"
	L.infiltration_of_dread = "Among Us"
	L.infiltration_removed = "Imposteurs trouvés en %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Fears"
	L.slumber_cloud = "Nuages"
	L.anguishing_strike = "Frontal (K)"

	L.custom_on_repeating_biting_wound = "Répéter Morsures Béantes"
	L.custom_on_repeating_biting_wound_desc = "Cocher cette option permet d'avoir plus de visibilité si l'on est affecté par le débuff morsures béantes en affichant une {rt7} au dessus de votre tête."
end

L = BigWigs:NewBossLocale("Rygelon", "frFR")
if L then
	L.celestial_collapse = "Quasars"
	L.manifest_cosmos = "Cores"
	L.stellar_shroud = "Absorption de soins"
	L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "frFR")
if L then
	L.rune_of_damnation_countdown = "Décompte"
	L.rune_of_damnation_countdown_desc = "Décompte pour les joueurs affectés par la Rune de damnation "
	L.jump = "Sautes"

	L.relentless_domination = "Domination"
	--L.chains_of_oppression = "Pull Chains"
	L.unholy_attunement = "Pylones"
	--L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "Charme"
	--L.desolation = "Azeroth Soak"
	L.decimator_line = "Décimateur + Ligne"
	L.chains_of_anguish = "Spread Chaînes"
	L.chain = "Chaîne"
	L.chain_target = "Enchaîné (Stacks) %s!"
	L.chains_remaining = "%d/%d Chaînes Cassées"
	L.rune_of_domination = "Groupes Soaks"

	L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Vie d'Azeroth"
	L.azeroth_health_desc = "Avertissement vie d'Azeroth"

	L.azeroth_new_health_plus = "Vie d'Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Vie d'Azeroth: -%.1f%%  (%d)"

	--L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	--L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	--L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	--L.mythic_blood_soak_stage_2_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	--L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	--L.mythic_blood_soak_stage_3_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill."
	L.mythic_blood_soak_bar = "Soigner Azeroth"

	L.floors_open = "Sol Ouvert"
	L.floors_open_desc = "Affiche le temps restant avant que le sol s'ouvre afin de vous avertir."

	L.mythic_dispel_stage_4 = "Dispel Timers"
	L.mythic_dispel_stage_4_desc = "Affiche les timers pour dispell pendant la dernière phase. Utilisé par Echo"
	L.mythic_dispel_bar = "Dispels"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "frFR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Etincelles"
	L.protoform_barrier = "Barrière"
	--L.reconfiguration_emitter = "Interrupt Add"
end
