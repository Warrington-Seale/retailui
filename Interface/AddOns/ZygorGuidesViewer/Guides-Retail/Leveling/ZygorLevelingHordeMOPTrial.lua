local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Horde" then return end
if ZGV:DoMutex("LevelingHMOP") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\The Jade Forest (10-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Valley of the Four Winds (15-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Krasarang Wilds (15-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Kun-Lai Summit (20-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Townlong Steppes (25-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Dread Wastes (30-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Isle of Thunder (50-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Dominance Offensive")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Daily")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 10")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 40")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 50")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 60")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 70")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 80")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quest 90")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\The Loremaster\\Loremaster of Pandaria")
