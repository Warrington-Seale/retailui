-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "zhTW")
if L then
	L.pickup_lantern = "%s 撿起了燈籠！"
	L.dropped_lantern = "%s 把燈籠丟掉了！"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "zhTW")
if L then
	L.killed = "已擊殺%s"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "zhTW")
if L then
	L.shield_remaining = "%s剩餘：%s（%.1f%%）" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "zhTW")
if L then
	L.miasma = "瘴氣" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "重覆貪食瘴氣喊話"
	L.custom_on_repeating_yell_miasma_desc = "當你中了貪食瘴氣，會在生命值低於 75% 時持續喊話。"

	L.custom_on_repeating_say_laser = "重覆猛烈噴射說話"
	L.custom_on_repeating_say_laser_desc = "當你你被標記為猛烈噴射的目標時，重覆發送說話訊息，以便接近你的玩家可以立刻看見並避開。"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhTW")
if L then
	L.tear = "裂口" -- Short for Dimensional Tear
	L.seeds = "種子" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhTW")
if L then
	L.times = "%d層 %s"

	L.level = "%s (等級|cffffff00%d|r)"
	L.full = "%s (|cffff0000滿了|r)"

	L.anima_adds = "濃縮靈魄增援"
	L.anima_adds_desc = "替濃縮靈魄減益效果召喚的增援生成顯示計時條。"

	L.custom_off_experimental = "啟用實驗性功能"
	L.custom_off_experimental_desc = "這些功能|cffff0000尚未經過完整測試|r，而且可能造成|cffff0000洗頻|r。"

	L.anima_tracking = "靈魄能量監控|cffff0000（實驗性）|r"
	L.anima_tracking_desc = "監控靈魄容器等級的訊息與計時條。|n|cffaaff00提示：你可以依據偏好單獨關閉此提示的訊息盒或計時條。"

	L.desires = "欲望"
	L.bottles = "瓶子"
	L.sins = "苦難"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhTW")
if L then
	L.custom_on_repeating_dark_recital = "重覆黑暗伴舞喊話"
	L.custom_on_repeating_dark_recital_desc = "使用 {rt1} 和 {rt2} 重覆黑暗伴舞喊話，方便你找到你的舞伴。"

	L.dance_assist = "跳舞助手"
	L.dance_assist_desc = "顯示舞步方向的警報。"
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 向前 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 向右 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 向後 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 向左 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "向前進！"
	L.dance_yell_right = "往右擺！"
	L.dance_yell_down = "往後跳！"
	L.dance_yell_down_2 = "往後跳！"
	L.dance_yell_left = "往左搖！"
end

L = BigWigs:NewBossLocale("Sludgefist", "zhTW")
if L then
	L.stomp_shift = "踐踏與震地" -- Destructive Stomp + Seismic Shift

	L.fun_info = "傷害訊息"
	L.fun_info_desc = "以訊息顯示泥拳在毀滅撞擊的昏迷期間所損失的生命值。"

	L.health_lost = "泥拳的血量下降了 %.1f%%！"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhTW")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"

	L.skirmishers = "鬥爭者" -- Short for Stone Legion Skirmishers
	L.eruption = "爆發" -- Short for Reverberating Eruption

	L.goliath_short = "巨人"
	L.goliath_desc = "對即將到來的石源魔軍團巨人顯示警告和計時器。"

	L.commando_short = "特種兵"
	L.commando_desc = "擊殺石源魔軍團特種兵時顯示警告。"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "zhTW")
if L then
	L.infobox_stacks = "%d 堆疊：%d 玩家" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "重覆黑夜獵人喊話"
	L.custom_on_repeating_nighthunter_desc = "以 {rt1}、{rt2} 或 {rt3} 重覆黑夜獵人喊話，使需要分攤的人可以更方便地找到你負責分攤的那條線。"

	L.custom_on_repeating_impale = "重覆刺穿喊話"
	L.custom_on_repeating_impale_desc = "以「1」、「22」、「333」或「4444」的方式重覆刺穿喊話，使你能清楚明瞭地知道擊中順序。"

	L.hymn_stacks = "納撒亞讚歌"
	L.hymn_stacks_desc = "以警報提示你的納撒亞讚歌層數。"

	L.ravage_target = "倒影：劫掠目標施法條"
	L.ravage_target_desc = "顯示倒影指向劫掠目標位置時間的施法條。"
	L.ravage_targeted = "劫掠鎖定目標" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "沒鏡子：%d" -- Player amount that does not have the Through the Mirror
	L.mirror = "鏡子：%d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "zhTW")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "魔多瓦克"
	L.caramain = "卡拉曼"
	L.sindrel = "辛德雷"
	L.hargitas = "哈吉塔斯"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "笨重的石獸"
	L.hawkeye = "納撒亞追蹤者"
	L.overseer = "養狗場監督者"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "噬懼者"
	L.rat = "大得離譜的老鼠"
	L.miasma = "瘴氣" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "戴普琳娜"
	L.dragost = "德苟斯特"
	L.kullan = "庫倫"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "邪惡的古物收藏家"
	L.conservator = "納撒亞栽培者"
	L.archivist = "納撒亞文獻管理員"
	--L.hierarch = "Court Hierarch"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "石源魔軍團巨人"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "zhTW")
if L then
	L.custom_on_bar_icon = "條形圖示"
	L.custom_on_bar_icon_desc = "顯示宿命之力的條形圖示"

	L.chaotic_essence = "精華"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打斷小怪"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "zhTW")
if L then
	L.chains = "鎖鏈" -- Chains of Eternity (Chains)
	L.remnants = "殘留" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "物理殘留"
	L.magic_remnant = "魔法殘留"
	L.fire_remnant = "火焰殘留"
	L.fire = "火焰"
	L.magic = "魔法"
	L.physical = "物理"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "zhTW")
if L then
	L.chains = "鎖鏈" -- Short for Dragging Chains
	L.death_gaze = "死亡凝視" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "zhTW")
if L then
	L.fragments = "碎片" -- Short for Fragments of Destiny
	L.fragment = "碎片" -- Singular Fragment of Destiny
	L.run_away = "跑開" -- Wings of Rage
	L.song = "唱歌" -- Short for Song of Dissolution
	L.go_in = "靠近" -- Reverberating Refrain
	L.valkyr = "華爾琪" -- Short for Call of the Val'kyr
	L.blades = "飛刀" -- Agatha's Eternal Blade
	L.big_bombs = "大炸彈" -- Daschla's Mighty Impact; 待定
	L.big_bomb = "大炸彈" -- Attached to the countdown; 待定
	L.shield = "減傷盾" -- Annhylde's Bright Aegis; 待定
	L.soaks = "接圈" -- Aradne's Falling Strike
	L.small_bombs = "小炸彈" -- Brynja's Mournful Dirge; 待定
	L.recall = "撤回" -- Short for Word of Recall; 待定，召回、撤回、或者取消？

	L.blades_yell = "死在我的利刃之下！"
	L.soaks_yell = "你們毫無勝算！"
	L.shield_yell = "我的盾堅不可摧！"

	L.berserk_stage1 = "狂暴階段一"
	L.berserk_stage2 = "狂暴階段二"

	L.image_special = "%s [斯凱雅]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "zhTW")
if L then
	L.cones = "射線" -- Grasp of Malic
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "zhTW")
if L then
	L.custom_off_nameplate_defiance = "反抗名條圖示"
	L.custom_off_nameplate_defiance_desc = "在獲得反抗效果強化的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.custom_off_nameplate_tormented = "烙印名條圖示"
	L.custom_off_nameplate_tormented_desc = "在受到折磨烙印影響的小怪名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.cones = "折磨" -- Torment
	L.dance = "跳舞" -- Encore of Torment
	L.brands = "烙印" -- Brand of Torment
	L.brand = "烙印" -- Single Brand of Torment
	L.spike = "尖刺" -- Short for Agonizing Spike
	L.chains = "鎖鏈" -- Hellscream
	L.chain = "鎖鏈" -- Soul Manacles
	L.souls = "靈魂" -- Rendered Soul

	L.chains_remaining = "還剩 %d 條鎖鏈"
	L.all_broken = "鎖鏈已全部拉斷"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "zhTW")
if L then
	L.hammer = "迴盪錘" -- Short for Rippling Hammer
	L.axe = "十字斧" -- Short for Cruciform Axe
	L.scythe = "雙刃鐮" -- Short for Dualblade Scythe
	L.trap = "陷阱" -- Short for Flameclasp Trap
	L.chains = "鎖鏈" -- Short for Shadowsteel Chains
	L.embers = "餘燼" -- Short for Shadowsteel Embers
	L.adds_embers = "餘燼（%d）：下一波懼魔！"
	L.adds_killed = "擊殺懼魔，用時%.2f秒"
	L.spikes = "狂暴時限" -- Soft enrage spikes; 尖刺軟狂暴時限
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "zhTW")
if L then
	L.bomb_missed = "%dx炸彈未擊中" -- 圈沒有去石柱給能量的提示，格式好像不對，可能要修
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "zhTW")
if L then
	L.rings = "圓環"
	L.rings_active = "圓環啟動" -- for when they activate/are movable
	L.runes = "符文"

	L.grimportent_countdown = "倒數"
	L.grimportent_countdown_desc = "為受到恐怖惡兆的玩家顯示倒數技時。"
	L.grimportent_countdown_bartext = "去找符文！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhTW")
if L then
	L.spikes = "冰刺" -- Short for Glacial Spikes
	L.spike = "冰刺"
	L.miasma = "瘴氣" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "索命追擊名條圖示"
	L.custom_on_nameplate_fixate_desc = "在追擊你的霜縛效忠者名條上顯示圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "zhTW")
if L then
	L.chains_active = "鎖鏈啟動"
	L.chains_active_desc = "顯示鎖鏈開始鏈住玩家的倒數計時器。"

	L.custom_on_nameplate_fixate = "憤怒名條圖示"
	L.custom_on_nameplate_fixate_desc = "在追擊你的黑暗哨兵名條上顯示追擊圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	--L.intermission_chains = "Intermission Chains"
	L.chains = "鎖鏈" -- Short for Domination Chains
	L.chain = "鎖鏈" -- Single Domination Chain
	L.darkness = "黑暗" -- Short for Veil of Darkness
	L.arrow = "悲鳴箭" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "波浪" -- Short for Haunting Wave
	L.dread = "碎擊" -- Short for Crushing Dread
	L.scream = "號叫" -- Banshee Scream

	L.knife_fling = "飛刀！" -- "Death-touched blades fling out"; 傳奇模式的死亡利刃射出計時
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "zhTW")
if L then
	L.custom_on_bar_icon = "條形圖示"
	L.custom_on_bar_icon_desc = "顯示宿命之力的條形圖示"

	L.chaotic_essence = "精華"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打斷小怪"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "zhTW")
if L then
	L.sentry = "哨兵"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "zhTW")
if L then
	L.tank_combo_desc = "為達到 100 能量時施放的撕裂與裂喉顯示計時器。"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhTW")
if L then
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸彈" -- Glyph of Relocation
	L.relocation_count = "%s（%d 之 %d）" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count) 先用這個試試看
	L.wormholes = "蟲洞" -- Interdimensional Wormholes
	L.wormhole = "蟲洞" -- Interdimensional Wormhole
	L.rings = "第 %d 階段輝環" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhTW")
if L then
	L.staggering_barrage = "分攤" -- Staggering Barrage
	L.obliteration_arc = "彈幕" -- Obliteration Arc 這個其實更適合叫彈幕，但分攤技能竟然就叫彈幕...

	L.disintergration_halo = "輝環" -- Disintegration Halo
	L.rings_x = "輝環 x%d"
	L.rings_enrage = "輝環（軟狂暴）"
	L.ring_count = "輝環（%d/%d）"

	L.custom_on_ring_timers = "瓦解輝環計時器"
	L.custom_on_ring_timers_desc = "當一組瓦解輝環啟動時，顯示每個輝環開始擴散的計時器。此選項的進階設定直接繼承自瓦解輝環的進階設定。"

	L.absorb_text = "%s（%.0f%%）"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhTW")
if L then
	L.necrotic_ritual = "死靈儀式"
	L.runecarvers_deathtouch = "死亡之觸"
	L.windswept_wings = "疾風"
	L.wild_stampede = "奔竄"
	L.withering_seeds = "種子"
	L.hand_of_destruction = "群拉" -- 毀滅之手群拉
	L.nighthunter_marks_additional_desc = "|cFFFF0000優先標記近戰，多個近戰則按團隊順序排列。|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhTW")
if L then
	L.protoform_cascade = "炸彈"
	L.cosmic_shift = "擊退"
	L.cosmic_shift_mythic = "擊退：%s"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "鎖定名條圖示"
	L.custom_on_nameplate_fixate_desc = "在鎖定你的截獲自主機名條上顯示追擊圖示。\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates、Plater）。"

	L.harmonic = "音律"  -- push
	L.melodic = "和聲"  -- pull
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "zhTW")
if L then
	L.seismic_tremors = "震地" -- Seismic Tremors
	L.earthbreaker_missiles = "飛彈" -- Earthbreaker Missiles
	L.crushing_prism = "稜光" -- Crushing Prism
	L.prism = "稜光"
	L.ephemeral_fissure = "裂隙"

	L.bomb_dropped = "炸彈掉落"
	L.volatile_charges_new = "新炸彈！"

	L.absorb_text = "%s（%.0f%%）"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhTW")
if L then
	L.custom_off_repeating_blasphemy = "重覆褻瀆印記喊話"
	L.custom_off_repeating_blasphemy_desc = "以 {rt1} 和 {rt3} 持續喊話兩種褻瀆印記，方便你快速地找到相反印記的隊友，並消除自身印記。"

	L.kingsmourne_hungers = "王之哀傷"
	L.blasphemy = "印記"
	L.befouled_barrier = "屏障"
	L.wicked_star = "星星"
	L.domination_word_pain = "御言術痛"
	L.army_of_the_dead = "大軍"
	L.grim_reflections = "幻影"
	L.march_of_the_damned = "影牆"
	L.dire_blasphemy = "印記"

	L.remnant_active = "墮落之王出現"
end

L = BigWigs:NewBossLocale("Lords of Dread", "zhTW")
if L then
	L.unto_darkness = "AoE 階段"-- Unto Darkness
	L.cloud_of_carrion = "食腐蟲群" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "強化食腐蟲群" -- Empowered Cloud of Carrion
	L.leeching_claws = "順劈（瑪）" -- Leeching Claws
	L.infiltration_of_dread = "抓內鬼" -- Infiltration of Dread
	L.infiltration_removed = "抓出內鬼，用時 %.1f 秒" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "驚懼爆發" -- Fearful Trepidation
	L.slumber_cloud = "雲霧" -- Slumber Cloud
	L.anguishing_strike = "順劈（金）" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "重覆螫傷喊話"
	L.custom_on_repeating_biting_wound_desc = "當你中了螫傷，以 {rt7} 持續喊話，使隊友能快速地找到你。"
end

L = BigWigs:NewBossLocale("Rygelon", "zhTW")
if L then
	L.celestial_collapse = "類星體" -- Celestial Collapse
	L.manifest_cosmos = "核心" -- Manifest Cosmos
	L.stellar_shroud = "治療吸收" -- Stellar Shroud
	L.knock = "擊退" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "zhTW")
if L then
	L.rune_of_damnation_countdown = "倒數計時"
	L.rune_of_damnation_countdown_desc = "為受到災罰符文影響的玩家顯示倒數計時。"
	L.jump = "跳入"

	L.relentless_domination = "統御"
	L.chains_of_oppression = "壓迫之鏈" -- 這個中文技能名夠短，不需縮寫
	L.unholy_attunement = "水晶塔"
	L.shattering_blast = "坦克爆炸"
	L.rune_of_compulsion = "心控"
	L.desolation = "荒寂"
	L.decimator_line = "屠戮者 + 行列"
	L.chains_of_anguish = "痛苦之鏈" -- 這個中文技能名夠短，不需縮寫
	L.chain = "鎖鏈"
	L.chain_target = "鎖鏈：%s!"
	L.chains_remaining = "鎖鏈拉斷：%d/%d"
	L.rune_of_domination = "團隊分攤"

	L.final = "最終%s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "艾澤拉斯血量"
	L.azeroth_health_desc = "艾澤拉斯血量警告"

	L.azeroth_new_health_plus = "艾澤拉斯：+%.1f%% (%d)"
	L.azeroth_new_health_minus = "艾澤拉斯：-%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "第一階段輸血計時器"
	L.mythic_blood_soak_stage_1_desc = "顯示輸血計時器，根據 Echo 的首殺所使用的時間軸製作，會在適合的時間點提醒你治療艾澤拉斯。"
	L.mythic_blood_soak_stage_2 = "第二階段輸血計時器"
	L.mythic_blood_soak_stage_2_desc = "顯示輸血計時器，根據 Echo 的首殺所使用的時間軸製作，會在適合的時間點提醒你治療艾澤拉斯。"
	L.mythic_blood_soak_stage_3 = "第三階段輸血計時器"
	L.mythic_blood_soak_stage_3_desc = "顯示輸血計時器，根據 Echo 的首殺所使用的時間軸製作，會在適合的時間點提醒你治療艾澤拉斯。"
	L.mythic_blood_soak_bar = "治療艾澤拉斯"

	L.floors_open = "地板開啟"
	L.floors_open_desc = "顯示地板打開、可以跳入坑中的計時器。"

	L.mythic_dispel_stage_4 = "驅散計時器"
	L.mythic_dispel_stage_4_desc = "顯示驅散計時器，根據 Echo 的首殺所使用的時間軸製作，為第四階段的驅散顯示計時器，會在適合的時間點提醒你驅散。"
	L.mythic_dispel_bar = "驅散"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "zhTW")
if L then
	L.custom_on_bar_icon = "條形圖示"
	L.custom_on_bar_icon_desc = "顯示宿命之力的條形圖示"

	L.chaotic_essence = "精華"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打斷小怪"
end
