-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "ruRU")
if L then
	L.pickup_lantern = "%s поднял фонарь!"
	L.dropped_lantern = "Фонарь брошен: %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "ruRU")
if L then
	L.killed = "%s убит"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "ruRU")
if L then
	L.shield_remaining = "%s : осталось %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "ruRU")
if L then
	L.miasma = "Миазмы" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Постоянный /крик о здоровье цели Ненасытные миазмы"
	L.custom_on_repeating_yell_miasma_desc = "Повторяющиеся сообщения у целей Ненасытные миазмы, чтобы дать другим игрокам знать о том, что уровень здоровья меньше 75%."

	L.custom_on_repeating_say_laser = "Постоянные сообщения у целей Нестабильный выброс"
	L.custom_on_repeating_say_laser_desc = "Повторение сообщений у игроков, отмеченных Нестабильным выбросом, помогающие при движении видеть их тем игрокам, которые изначально не видели первое сообщение."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "ruRU")
if L then
	L.tear = "Разрыв" -- Short for Dimensional Tear
	L.seeds = "Семена" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "ruRU")
if L then
	L.times = "%dx %s"

	L.level = "%s (Уровень |cffffff00%d|r)"
	L.full = "%s (|cffff0000ПОЛНЫЙ|r)"

	L.anima_adds = "Адды Концентрированной Анимы"
	L.anima_adds_desc = "Показ таймера появления аддов от дебафа Концентрированной Анимы."

	L.custom_off_experimental = "Включение экспериментальных функций"
	L.custom_off_experimental_desc = "Эти функции |cffff0000не были протестированы|r и могут создать |cffff0000спам|r."

	L.anima_tracking = "Отслеживание анимы |cffff0000(Экспериментально)|r"
	L.anima_tracking_desc = "Сообщения и полосы для слежения за уровнями анимы в контейнерах.|n|cffaaff00Подсказка: Вы, возможно, захотите отключить информацию в инфобоксах или полосах, в зависимости от ваших предпочтений."

	L.desires = "Желания"
	L.bottles = "Колбы"
	L.sins = "Грехи"
end

L = BigWigs:NewBossLocale("The Council of Blood", "ruRU")
if L then
	L.custom_on_repeating_dark_recital = "Повторение Тёмного бала"
	L.custom_on_repeating_dark_recital_desc = "Спам сообщений в /сказать с метками {rt1}, {rt2} чтобы найти своего партнёра для танца во время Тёмного бала."

	L.dance_assist = "Помощник танцев"
	L.dance_assist_desc = "Показ предупреждений о направлении во время фазы танцев."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Двигайся вперед |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Двигайся направо |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Двигайся вниз |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Двигайся влево |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Жете вперед" -- "Жете вперед!" -- Prance Forward!
	L.dance_yell_right = "Па вправо" -- "Па вправо!" -- Shimmy right!
	L.dance_yell_down = "Бризе назад" -- "Бризе назад!" -- Boogie down!
	L.dance_yell_down_2 = "Бризе назад" -- "Бризе назад!" -- Boogie down!
	L.dance_yell_left = "Шажок влево" -- "Шажок влево!" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "ruRU")
if L then
	L.stomp_shift = "Топот + Сдвиг" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Информация об уроне"
	L.fun_info_desc = "Показ сообщения о том сколько босс потерял здоровья за фазу Разрушительного удара."

	L.health_lost = "Грязешмяк потерял %.1f%% здоровья!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "ruRU")
if L then
	L.first_blade = "Первое лезвие"
	L.second_blade = "Второе лезвие"

	L.skirmishers = "Войска" -- Short for Stone Legion Skirmishers
	L.eruption = "Взрыв" -- Short for Reverberating Eruption

	L.goliath_short = "Голиаф"
	L.goliath_desc = "Показывать предупреждения и таймеры для появления голиафа из Каменного Легиона"

	L.commando_short = "Диверсант"
	L.commando_desc = "Показывать предупреждения, когда диверсант из Каменного Легиона умирает."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "ruRU")
if L then
	L.infobox_stacks = "%d |4Стак:Стака:Стаков;: %d |4игрок:игрока:игроков;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Повторение крика о Ночном охотнике"
	L.custom_on_repeating_nighthunter_desc = "Спам крика о способности Ночной охотник иконками {rt1}, {rt2} или {rt3} для облегчения поиска линии, которую вы должны перекрывать."

	L.custom_on_repeating_impale = "Повторение чата о Пригвождении"
	L.custom_on_repeating_impale_desc = "Спам сообщений '1', '22', '333' или '4444' в /сказать о способности Пригвождение чтобы показать порядок, в котором игроки получат урон."

	L.hymn_stacks = "Гимн Нафрии"
	L.hymn_stacks_desc = "Оповещать о количестве стаков гимна Нафрии на вас."

	L.ravage_target = "Полоса заклинания Отражение: Разорение"
	L.ravage_target_desc = "Полоса заклинания, показывающая время до того как отражение нацелится на место для Разорения."
	L.ravage_targeted = "Место Разорения выбрано!" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Без зеркала: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "С зеркалом: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "ruRU")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Молдоваак"
	L.caramain = "Карамейн"
	L.sindrel = "Синдрел"
	L.hargitas = "Харгитас"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Громадный гаргон"
	L.hawkeye = "Зоркий стрелок из замка Нафрия"
	L.overseer = "Смотрительница псарни"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Жуткий обжора"
	L.rat = "Крыса необычных размеров"
	L.miasma = "Миазмы" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Деплина"
	L.dragost = "Драгост"
	L.kullan = "Куллан"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Зловещий антиквар"
	L.conservator = "Нафрийский охранитель"
	L.archivist = "Нафрийский архивариус"
	L.hierarch = "Придворный иерарх"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Голиаф из Каменного легиона"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "ruRU")
if L then
	L.custom_on_bar_icon = "Иконка полосок"
	L.custom_on_bar_icon_desc = "Показывать иконку Судьбоносного Рейда на полосках, связанных с афиксом."

	L.chaotic_essence = "Эссенция"
	L.creation_spark = "Искры"
	L.protoform_barrier = "Преграда"
	L.reconfiguration_emitter = "Кик аффикс"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "ruRU")
if L then
	L.chains = "Цепи" -- Chains of Eternity (Chains)
	L.remnants = "Фрагменты" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Физический фрагмент"
	L.magic_remnant = "Магический фрагмент"
	L.fire_remnant = "Огненный фрагмент"
	L.fire = "Огонь"
	L.magic = "Магический"
	L.physical = "Физический"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "ruRU")
if L then
	L.chains = "Цепи" -- Short for Dragging Chains
	L.death_gaze = "Взгляд смерти" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "ruRU")
if L then
	L.fragments = "Фрагменты" -- Short for Fragments of Destiny
	L.fragment = "Фрагмент" -- Singular Fragment of Destiny
	L.run_away = "Отбежать" -- Wings of Rage
	L.song = "Песня" -- Short for Song of Dissolution
	L.go_in = "Подбежать" -- Reverberating Refrain
	L.valkyr = "Зов валь'киры" -- Short for Call of the Val'kyr
	L.blades = "Клинки" -- Agatha's Eternal Blade
	L.big_bombs = "Большие бомбы" -- Daschla's Mighty Impact
	L.big_bomb = "Большая бомба" -- Attached to the countdown
	L.shield = "Щит" -- Annhylde's Bright Aegis
	L.soaks = "Перекрывания" -- Aradne's Falling Strike
	L.small_bombs = "Маленькие бомбы" -- Brynja's Mournful Dirge
	L.recall = "Повтор команд" -- Short for Word of Recall

	L.blades_yell = "Примите смерть от моего клинка!"
	L.soaks_yell = "Вам со мной не справиться!"
	L.shield_yell = "Мой щит не сломить!"

	L.berserk_stage1 = "Берсерк фазы 1"
	L.berserk_stage2 = "Берсерк фазы 2"

	L.image_special = "%s [Скайя]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "ruRU")
if L then
	L.cones = "Конусы" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "ruRU")
if L then
	L.custom_off_nameplate_defiance = "Метки на Верных Утробе с Неповиновением"
	L.custom_off_nameplate_defiance_desc = "Ставит метку на Верного Утробе, имеющего бафф Неповиновения.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Метки на Верных Утробе с Мучением"
	L.custom_off_nameplate_tormented_desc = "Ставит метку на Верного Утробе, имеющего дебафф Мучения.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.cones = "Мучение" -- Torment
	L.dance = "Танцы" -- Encore of Torment
	L.brands = "Клеймо мучения" -- Brand of Torment
	L.brand = "Клеймо" -- Single Brand of Torment
	L.spike = "Кольцо агонии" -- Short for Agonizing Spike
	L.chains = "Цепи" -- Hellscream
	L.chain = "Цепь" -- Soul Manacles
	L.souls = "Души" -- Rendered Soul

	L.chains_remaining = "Цепей осталось: %d"
	L.all_broken = "Все цепи порваны"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "ruRU")
if L then
	L.hammer = "Молот" -- Short for Rippling Hammer
	L.axe = "Топор" -- Short for Cruciform Axe
	L.scythe = "Коса" -- Short for Dualblade Scythe
	L.trap = "Капкан" -- Short for Flameclasp Trap
	L.chains = "Цепи" -- Short for Shadowsteel Chains
	L.embers = "Угли" -- Short for Shadowsteel Embers
	L.adds_embers = "Угли (%d) - скоро адды!"
	L.adds_killed = "Адды убиты за %.2f с."
	L.spikes = "Смерть от шипов" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "ruRU")
if L then
	L.bomb_missed = "%dx бомб мимо"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "ruRU")
if L then
	L.rings = "Кольца"
	L.rings_active = "Колец активно" -- for when they activate/are movable
	L.runes = "Руны"

	L.grimportent_countdown = "Отсчёт до конца Дурного предзнаменования"
	L.grimportent_countdown_desc = "Показывать отсчёт для игроков с дебаффом Дурного предзнаменования"
	L.grimportent_countdown_bartext = "Иди к руне!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ruRU")
if L then
	L.spikes = "Шипы" -- Short for Glacial Spikes
	L.spike = "Шип"
	L.miasma = "Миазмы" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Метка для преследующего прислужника"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на прислужнике, который преследует вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "ruRU")
if L then
	L.chains_active = "Активация цепепй"
	L.chains_active_desc = "Показывать полосу для активации Цепей Господства"

	L.custom_on_nameplate_fixate = "Метка для преследующего часового"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на Темном часовом, который преследует вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Цепи" -- Short for Domination Chains
	L.chain = "Цепь" -- Single Domination Chain
	L.darkness = "Завеса тьмы" -- Short for Veil of Darkness
	L.arrow = "Стрела" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Волна" -- Short for Haunting Wave
	L.dread = "Ужас" -- Short for Crushing Dread
	L.scream = "Вой банши" -- Banshee Scream

	L.knife_fling = "Ножи смерти" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "ruRU")
if L then
	L.custom_on_bar_icon = "Иконка полосок"
	L.custom_on_bar_icon_desc = "Показывать иконку Судьбоносного Рейда на полосках, связанных с афиксом."

	L.chaotic_essence = "Эссенция"
	L.creation_spark = "Искры"
	L.protoform_barrier = "Преграда"
	L.reconfiguration_emitter = "Кик аффикс"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "ruRU")
if L then
	L.sentry = "Танк моб"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ruRU")
if L then
	L.tank_combo_desc = "При применении Сколексом комбо из трёх ударов на 100 энергии танки должны сблизиться, чтобы по очереди принимать на себя урон от атак."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "ruRU")
if L then
	L.sparknova = "Вспышка гиперсвета" -- Hyperlight Sparknova
	L.relocation = "Стяжка" -- Glyph of Relocation
	L.relocation_count = "%s Ф%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Телепорты" -- Interdimensional Wormholes
	L.wormhole = "Телепорт" -- Interdimensional Wormhole
	L.rings = "Кольца Ф%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "ruRU")
if L then
	L.staggering_barrage = "Обстрел" -- Staggering Barrage
	L.obliteration_arc = "Дуга" -- Obliteration Arc

	L.disintergration_halo = "Кольца" -- Disintegration Halo
	L.rings_x = "Кольца x%d"
	L.rings_enrage = "Кольца (Исступление)"
	L.ring_count = "Кольцо (%d/%d)"

	L.custom_on_ring_timers = "Индивидуальные таймеры для колец"
	L.custom_on_ring_timers_desc = "\"Ореол дезинтеграции\" создаёт набор колец. Выбрав эту настройку, вам будет показаны полосы для каждой полосы индивидуально. Использует настройки \"Ореол дезинтеграции\"."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "ruRU")
if L then
	L.necrotic_ritual = "Ритуал"
	L.runecarvers_deathtouch = "ДОТ"
	L.windswept_wings = "Ветерки"
	L.wild_stampede = "Звери"
	L.withering_seeds = "Семена"
	L.hand_of_destruction = "Длань разрушения"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Отмечает игроков с приоритетом мили для первых меток, вторичний приоритет в соответствии с позицией группы.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "ruRU")
if L then
	L.protoform_cascade = "Фронтал"
	L.cosmic_shift = "Отталкивание"
	L.cosmic_shift_mythic = "Сдвиг: %s"
	L.unstable_mote = "Частицы"
	L.mote = "Частица"
	L.custom_on_nameplate_fixate = "Метка для автома-собирателя"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на автоме, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.harmonic = "Отталкивание"
	L.melodic = "Притягивание"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "ruRU")
if L then
	L.custom_off_repeating_blasphemy = "Метки кощунства"
	L.custom_off_repeating_blasphemy_desc = "Повторять метки {rt1} и {rt3} в чат, что бы найти партнёра."

	L.kingsmourne_hungers = "Клив"
	L.blasphemy = "Метки"
	L.befouled_barrier = "Барьер"
	L.wicked_star = "Звезда"
	L.domination_word_pain = "ДОТ"
	L.army_of_the_dead = "Армия"
	L.grim_reflections = "Кик ады"
	L.march_of_the_damned = "Стенки"
	L.dire_blasphemy = "Метки"

	L.remnant_active = "Тень активна"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "ruRU")
if L then
	L.seismic_tremors = "Частицы + Толчки"
	L.earthbreaker_missiles = "Снаряды"
	L.crushing_prism = "Призмы"
	L.prism = "Призма"
	L.ephemeral_fissure = "Разлом"

	L.bomb_dropped = "Бомба брошена"
	--L.volatile_charges_new = "New Bombs!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "ruRU")
if L then
	L.unto_darkness = "АОЕ Фаза"
	L.cloud_of_carrion = "Рой"
	L.empowered_cloud_of_carrion = "Усиленный рой" -- Empowered Cloud of Carrion
	L.leeching_claws = "Фронтал (M)"
	L.infiltration_of_dread = "Амогус"
	L.infiltration_removed = "Импостер найден спустя %.1fс" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Фир"
	L.slumber_cloud = "Слип"
	L.anguishing_strike = "Фронтал (K)"

	L.custom_on_repeating_biting_wound_desc = "Повторять сообщение о дебафе с иконкой {rt7}, ради большей видимости других игроков."
	L.custom_on_repeating_biting_wound = "Сообщение ран от укусов"
end

L = BigWigs:NewBossLocale("Rygelon", "ruRU")
if L then
	L.celestial_collapse = "Квазары"
	L.manifest_cosmos = "Сердечники"
	L.stellar_shroud = "Абсорб хила"
	L.knock = "Отталкивание" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "ruRU")
if L then
	L.rune_of_damnation_countdown = "Отсчёт"
	L.rune_of_damnation_countdown_desc = "Отсчёт для игроков, поражённых Руной проклятия"
	L.jump = "ПРЫГАЙ"

	L.relentless_domination = "Подчинение"
	L.chains_of_oppression = "Цепи страдания"
	L.unholy_attunement = "Пилоны"
	L.shattering_blast = "Выстрел в танка"
	L.rune_of_compulsion = "Подчинение"
	L.desolation = "Лужа Азерот"
	L.decimator_line = "Дециматор + Линия"
	L.chains_of_anguish = "Цепи"
	L.chain = "Цепи"
	L.chain_target = "Цепь с %s!"
	L.chains_remaining = "%d/%d цепей разорвано"
	L.rune_of_domination = "Делёжка"

	L.final = "Ласт %s" -- Final Unholy Attunement/Domination (last spell of a stage) -- Used this exact word to keep gender

	L.azeroth_health = "Хп Азерот"
	L.azeroth_health_desc = "Предупреждения о здоровье Азерот"

	L.azeroth_new_health_plus = "Хп Азерот: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Хп Азерот: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Таймеры крови Азерот 1 Фазы"
	L.mythic_blood_soak_stage_1_desc = "Показывать полосы с хорошими таймингами, аналогичными первому килу Echo."
	L.mythic_blood_soak_stage_2 = "Таймеры крови Азерот 2 Фазы"
	L.mythic_blood_soak_stage_2_desc = "Показывать полосы с хорошими таймингами, аналогичными первому килу Echo."
	L.mythic_blood_soak_stage_3 = "Таймеры крови Азерот 3 Фазы"
	L.mythic_blood_soak_stage_3_desc = "Показывать полосы с хорошими таймингами, аналогичными первому килу Echo."
	L.mythic_blood_soak_bar = "Лечить Азерот"

	L.floors_open = "Открытие пола"
	L.floors_open_desc = "Время до открытия ячеек на полу, после чего можно будет упасть в пропасть."

	L.mythic_dispel_stage_4 = "Таймеры диспелов"
	L.mythic_dispel_stage_4_desc = "Таймеры для диспелов, взятые с первого кила Echo"
	L.mythic_dispel_bar = "Диспелы"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "ruRU")
if L then
	L.custom_on_bar_icon = "Иконка полосок"
	L.custom_on_bar_icon_desc = "Показывать иконку Судьбоносного Рейда на полосках, связанных с афиксом."

	L.chaotic_essence = "Эссенция"
	L.creation_spark = "Искры"
	L.protoform_barrier = "Преграда"
	L.reconfiguration_emitter = "Кик аффикс"
end
