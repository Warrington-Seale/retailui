-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "zhCN")
if L then
	L.pickup_lantern = "%s 捡起了灯笼！"
	L.dropped_lantern = "%s 丢掉了灯笼!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "zhCN")
if L then
	L.killed = "%s 已击杀"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "zhCN")
if L then
	L.shield_remaining = "%s剩余：%s（%.1f%%）" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "zhCN")
if L then
	L.miasma = "瘴气" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "重复瘴气生命值喊话"
	L.custom_on_repeating_yell_miasma_desc = "重复暴食瘴气喊话信息让其他人知道你的生命值低于75%。"

	L.custom_on_repeating_say_laser = "重复不稳定的喷发说话"
	L.custom_on_repeating_say_laser_desc = "重复不稳定的喷发说话信息来帮助没有看到您的第一条消息的玩家移入聊天范围。"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhCN")
if L then
	L.tear = "撕裂" -- Short for Dimensional Tear
	L.seeds = "种" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhCN")
if L then
	L.times = "%d层 %s"

	L.level = "%s（等级 |cffffff00%d|r）"
	L.full = "%s（|cffff0000满|r）"

	L.anima_adds = "浓缩心能增援"
	L.anima_adds_desc = "当浓缩心能负面效果刷新增援时显示一个计时器。"

	L.custom_off_experimental = "启用实验性功能"
	L.custom_off_experimental_desc = "此功能|cffff0000未测试|r并可能|cffff0000刷屏|r。"

	L.anima_tracking = "心能追踪|cffff0000（实验性）|r"
	L.anima_tracking_desc = "追踪容器的心能等级的信息和计时条。|n|cffaaff00提示：可能要禁用信息盒或计时条，根据配置。"

	L.desires = "欲望"
	L.bottles = "瓶子"
	L.sins = "罪孽"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhCN")
if L then
	L.custom_on_repeating_dark_recital = "重复黑暗伴舞"
	L.custom_on_repeating_dark_recital_desc = "重复黑暗伴舞喊话信息使用 {rt1}，{rt2} 图标，和伙伴共舞。"

	L.dance_assist = "跳舞助手"
	L.dance_assist_desc = "显示舞台的定向警报。"
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 向前跳 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 向右跳 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 向后跳 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 向左跳 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "前阔步" -- Prance Forward!
	L.dance_yell_right = "右摆步" -- Shimmy right!
	L.dance_yell_down = "后摇步" -- Boogie down!
	L.dance_yell_down_2 = "后摇步" -- Boogie down!
	L.dance_yell_left = "左滑步" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "zhCN")
if L then
	L.stomp_shift = "踩踏和位移" -- Destructive Stomp + Seismic Shift

	L.fun_info = "伤害信息"
	L.fun_info_desc = "显示一个毁灭冲击期间损失了多少血量的信息。"

	L.health_lost = "泥拳倒下 %.1f%%！"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhCN")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"

	L.skirmishers = "散兵" -- Short for Stone Legion Skirmishers
	L.eruption = "震荡爆发" -- Short for Reverberating Eruption

	L.goliath_short = "巨怪"
	L.goliath_desc = "显示警告和计时器，提示何时会刷新顽石军团巨怪。"

	L.commando_short = "特种兵"
	L.commando_desc = "当击杀顽石军团特种兵时显示警告。"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "zhCN")
if L then
	L.infobox_stacks = "%d 堆叠：%d 玩家" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "重复午夜猎手喊话"
	L.custom_on_repeating_nighthunter_desc = "使用 {rt1}、{rt2}、{rt3} 图标重复午夜猎手技能喊话信息让你找线更容易。"

	L.custom_on_repeating_impale = "重复穿刺说话"
	L.custom_on_repeating_impale_desc = "使用“1”、“22”、“333”、“4444”重复穿刺技能说话信息让你清楚击中顺序。"

	L.hymn_stacks = "纳斯利亚赞歌"
	L.hymn_stacks_desc = "你的纳斯利亚赞歌当前堆叠层数警报。"

	L.ravage_target = "镜像：毁灭目标施放条"
	L.ravage_target_desc = "计时条显示时间直到镜像目标位置毁灭。"
	L.ravage_targeted = "毁灭已目标" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "没镜子：%d" -- Player amount that does not have the Through the Mirror
	L.mirror = "镜子：%d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "zhCN")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "摩多瓦克"
	L.caramain = "卡拉梅恩"
	L.sindrel = "辛德雷尔"
	L.hargitas = "哈尔基塔司"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "魁梧的加尔贡"
	L.hawkeye = "纳斯利亚鹰眼射手"
	L.overseer = "狗舍监督者"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "恐惧吞食者"
	L.rat = "尺寸惊人的老鼠"
	L.miasma = "瘴气" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "德普莉娜"
	L.dragost = "德拉苟斯特"
	L.kullan = "库兰"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "阴险的古董收藏家"
	L.conservator = "纳斯利亚管理员"
	L.archivist = "纳斯利亚档案员"
	L.hierarch = "王庭主教"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "顽石军团巨怪"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "zhCN")
if L then
	L.custom_on_bar_icon = "条形图标"
	L.custom_on_bar_icon_desc = "显示宿命之力条形图标."

	L.chaotic_essence = "精华"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打断小怪"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "zhCN")
if L then
	L.chains = "锁链" -- Chains of Eternity (Chains)
	L.remnants = "残迹" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "物理残迹"
	L.magic_remnant = "魔法残迹"
	L.fire_remnant = "火焰残迹"
	L.fire = "火焰"
	L.magic = "魔法"
	L.physical = "物理"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "zhCN")
if L then
	L.chains = "锁链" -- Short for Dragging Chains
	L.death_gaze = "死亡凝视" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "zhCN")
if L then
	L.fragments = "残片" -- Short for Fragments of Destiny
	L.fragment = "残片" -- Singular Fragment of Destiny
	L.run_away = "跑开" -- Wings of Rage
	L.song = "歌" -- Short for Song of Dissolution
	L.go_in = "靠近" -- Reverberating Refrain
	L.valkyr = "瓦格里" -- Short for Call of the Val'kyr
	L.blades = "刃" -- Agatha's Eternal Blade
	L.big_bombs = "大炸弹" -- Daschla's Mighty Impact
	L.big_bomb = "大炸弹" -- Attached to the countdown
	L.shield = "盾" -- Annhylde's Bright Aegis
	L.soaks = "泡" -- Aradne's Falling Strike
	L.small_bombs = "小炸弹" -- Brynja's Mournful Dirge
	L.recall = "召回" -- Short for Word of Recall

	L.blades_yell = "倒在我的剑下吧！"
	L.soaks_yell = "你们绝无胜算！"
	L.shield_yell = "我的盾牌绝不动摇！"

	L.berserk_stage1 = "狂暴阶段1"
	L.berserk_stage2 = "狂暴阶段2"

	L.image_special = "%s [斯凯亚]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "zhCN")
if L then
	L.cones = "障碍" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "zhCN")
if L then
	L.custom_off_nameplate_defiance = "蔑视姓名板图标"
	L.custom_off_nameplate_defiance_desc = "在渊誓怪有蔑视时在姓名板显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.custom_off_nameplate_tormented = "饱受磨难姓名板图标"
	L.custom_off_nameplate_tormented_desc = "在渊誓怪有饱受磨难时在姓名板显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.cones = "障碍" -- Torment
	L.dance = "跳舞" -- Encore of Torment
	L.brands = "烙印" -- Brand of Torment
	L.brand = "烙印" -- Single Brand of Torment
	L.spike = "尖刺" -- Short for Agonizing Spike
	L.chains = "锁链" -- Hellscream
	L.chain = "锁链" -- Soul Manacles
	L.souls = "灵魂" -- Rendered Soul

	L.chains_remaining = "%d锁链剩余"
	L.all_broken = "全部锁链已破坏"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "zhCN")
if L then
	L.hammer = "铁锤" -- Short for Reverberating Hammer
	L.axe = "刃斧" -- Short for Cruciform Axe
	L.scythe = "镰刀" -- Short for Dualblade Scythe
	L.trap = "陷阱" -- Short for Flameclasp Trap
	L.chains = "锁链" -- Short for Shadowsteel Chains
	L.embers = "余烬" -- Short for Shadowsteel Embers
	L.adds_embers = "余烬 (%d) - 下一波恐魔!"
	L.adds_killed = "击杀恐魔，用时 %.2f秒"
	L.spikes = "狂暴时限" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "zhCN")
if L then
	L.bomb_missed = "%dx 炸弹未击中"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "zhCN")
if L then
	L.rings = "织环"
	L.rings_active = "织环已激活" -- for when they activate/are movable
	L.runes = "符文"

	L.grimportent_countdown = "冷却"
	L.grimportent_countdown_desc = "受到恐怖征兆的玩家冷却"
	L.grimportent_countdown_bartext = "快去符文！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhCN")
if L then
	L.spikes = "尖刺" -- Short for Glacial Spikes
	L.spike = "尖刺"
	L.miasma = "瘴气" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "追击姓名板图标"
	L.custom_on_nameplate_fixate_desc = "霜缚狂热者追击你时在姓名板显示一个图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "zhCN")
if L then
	L.chains_active = "锁链已激活"
	L.chains_active_desc = "当统御锁链激活时显示计时条。"

	L.custom_on_nameplate_fixate = "追击姓名板图标"
	L.custom_on_nameplate_fixate_desc = "黑暗哨兵追击你时在姓名板显示一个图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"

	L.intermission_chains = "中场锁链"
	L.chains = "锁链" -- Short for Domination Chains
	L.chain = "锁链" -- Single Domination Chain
	L.darkness = "黑暗" -- Short for Veil of Darkness
	L.arrow = "箭" -- Short for Wailing Arrow
	L.arrow_done = "箭" -- Message when the arrow has hit
	L.wave = "妖魂" -- Short for Haunting Wave
	L.dread = "压迫" -- Short for Crushing Dread
	L.scream = "尖啸" -- Banshee Scream

	L.knife_fling = "刀飞出！" -- "Death-touched blades fling out"
	L.bridges = "桥"
	L.rive_counter = "%s (%d/%d)"
	L.soaks = "接圈" -- Merciless
	L.count_x = "%s (x%d)(%d)"
	L.shroud_active = "护盾 (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "zhCN")
if L then
	L.custom_on_bar_icon = "条形图标"
	L.custom_on_bar_icon_desc = "显示宿命之力条形图标."

	L.chaotic_essence = "精华"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打断小怪"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "zhCN")
if L then
	L.sentry = "哨兵"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "zhCN")
if L then
	L.tank_combo_desc = "为满100能量释放的裂隙之吼与撕裂显示计时器"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhCN")
if L then
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸弹" -- Glyph of Relocation
	L.relocation_count = "%s :阶段%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "虫洞" -- Interdimensional Wormholes
	L.wormhole = "虫洞" -- Interdimensional Wormhole
	L.rings = "第 %d 阶段法环" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhCN")
if L then
	L.staggering_barrage = "分摊" -- Staggering Barrage
	L.obliteration_arc = "弹幕" -- Obliteration Arc

	L.disintergration_halo = "光环" -- Disintegration Halo
	L.rings_x = "光环 x%d"
	L.rings_enrage = "光环 (激怒)"
	L.ring_count = "光环 (%d/%d)"

	L.custom_on_ring_timers = "衰变光环计时条"
	L.custom_on_ring_timers_desc = "使用衰变光环设置：这是显示衰变光环在触发能量环时,开始移动的计时条。"

	L.absorb_text = "%s（%.0f%%）"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhCN")
if L then
	L.necrotic_ritual = "死灵仪式"
	L.runecarvers_deathtouch = "死亡之触"
	L.windswept_wings = "啸风"
	L.wild_stampede = "兽群"
	L.withering_seeds = "种子"
	L.hand_of_destruction = "群拉"
	L.nighthunter_marks_additional_desc = "|cFFFF0000优先标记近战，多个近战则按团队顺序排序。|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhCN")
if L then
	L.protoform_cascade = "炸弹"
	L.cosmic_shift = "击退"
	L.cosmic_shift_mythic = "击退: %s"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "被征用姓名板图标"
	L.custom_on_nameplate_fixate_desc = "在目标是你的自动体的姓名板上显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates,Plater）。"

	L.harmonic = "谐波 (推离)"
	L.melodic = "旋律 (拉近)"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "zhCN")
if L then
	L.seismic_tremors = "微尘 + 震颤" -- Seismic Tremors
	L.earthbreaker_missiles = "飞弹" -- Earthbreaker Missiles
	L.crushing_prism = "棱镜" -- Crushing Prism
	L.prism = "棱镜"
	L.ephemeral_fissure = "裂隙"

	L.bomb_dropped = "炸弹掉落"
	L.volatile_charges_new = "新炸弹!"

	L.absorb_text = "%s（%.0f%%）"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhCN")
if L then
	L.custom_off_repeating_blasphemy = "重复渎神之光"
	L.custom_off_repeating_blasphemy_desc = "以{rt1}和{rt3} 重覆说话两种渎神之光印记，方便你快速地找到相反印记的队友，并消除自身印记。"

	L.kingsmourne_hungers = "王之哀伤"
	L.blasphemy = "标记"
	L.befouled_barrier = "屏障"
	L.wicked_star = "邪恶之星"
	L.domination_word_pain = "御言术:痛"
	L.army_of_the_dead = "大军"
	L.grim_reflections = "黑暗镜像"
	L.march_of_the_damned = "阶段"
	L.dire_blasphemy = "标记"

	L.remnant_active = "陨落君王"
end

L = BigWigs:NewBossLocale("Lords of Dread", "zhCN")
if L then
	L.unto_darkness = "AoE 阶段"-- Unto Darkness
	L.cloud_of_carrion = "腐臭" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "强化腐臭" -- Empowered Cloud of Carrion
	L.leeching_claws = "正面顺劈 (玛)" -- Leeching Claws
	L.infiltration_of_dread = "抓內鬼" -- Infiltration of Dread
	L.infiltration_removed = "内鬼发现，用时 %.1f 秒" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "爆裂恐惧" -- Fearful Trepidation
	L.slumber_cloud = "迷雾" -- Slumber Cloud
	L.anguishing_strike = "正面顺劈 (金)" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "重复啃噬伤口"
	L.custom_on_repeating_biting_wound_desc = "以团队标记 {rt7} 重覆说话啃噬伤口，以使其显得更明显。"
end

L = BigWigs:NewBossLocale("Rygelon", "zhCN")
if L then
	L.celestial_collapse = "类星体" -- Celestial Collapse
	L.manifest_cosmos = "宇宙核心" -- Manifest Cosmos
	L.stellar_shroud = "吸收治疗量" -- Stellar Shroud
	L.knock = "击退" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "zhCN")
if L then
	L.rune_of_damnation_countdown = "倒计时"
	L.rune_of_damnation_countdown_desc = "为受到咒罚符文影响的玩家倒计时。"
	L.jump = "跳入"

	L.relentless_domination = "统御"
	L.chains_of_oppression = "压迫之链"
	L.unholy_attunement = "晶塔"
	L.shattering_blast = "坦克炸弹"
	L.rune_of_compulsion = "心控"
	L.desolation = "荒芜"
	L.decimator_line = "屠戮者 + 线"
	L.chains_of_anguish = "痛苦之链"
	L.chain = "锁链"
	L.chain_target = "锁链 %s!"
	L.chains_remaining = "%d/%d 锁链碎裂"
	L.rune_of_domination = "团队分摊"

	L.final = "最终%s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "艾泽拉斯血量"
	L.azeroth_health_desc = "艾泽拉斯血量警告"

	L.azeroth_new_health_plus = "艾泽拉斯: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "艾泽拉斯: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "第一阶段输血计时条"
	L.mythic_blood_soak_stage_1_desc = "显示输血计时条，根据 Echo 的首杀所使用的时间轴制作，会在合适的时间点提醒你治疗艾泽拉斯。"
	L.mythic_blood_soak_stage_2 = "第二阶段输血计时条"
	L.mythic_blood_soak_stage_2_desc = "显示输血计时条，根据 Echo 的首杀所使用的时间轴制作，会在合适的时间点提醒你治疗艾泽拉斯。"
	L.mythic_blood_soak_stage_3 = "第三阶段输血计时条"
	L.mythic_blood_soak_stage_3_desc = "显示输血计时条，根据 Echo 的首杀所使用的时间轴制作，会在合适的时间点提醒你治疗艾泽拉斯。"
	L.mythic_blood_soak_bar = "治疗艾泽拉斯"

	L.floors_open = "地板开启"
	L.floors_open_desc = "显示地板打开、可以跳入坑中的计时器。"

	L.mythic_dispel_stage_4 = "驱散计时条"
	L.mythic_dispel_stage_4_desc = "显示驱散计时器，根据 Echo 的首杀所使用的时间轴制作，为第四阶段的驱散显示计时器，会在合适的时间点提醒你驱散。"
	L.mythic_dispel_bar = "驱散"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "zhCN")
if L then
	L.custom_on_bar_icon = "条形图标"
	L.custom_on_bar_icon_desc = "显示宿命之力条形图标."

	L.chaotic_essence = "精华"
	L.creation_spark = "火花"
	L.protoform_barrier = "屏障"
	L.reconfiguration_emitter = "打断小怪"
end
