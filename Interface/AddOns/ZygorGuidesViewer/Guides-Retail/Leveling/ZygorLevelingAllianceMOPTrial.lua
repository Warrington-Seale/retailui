local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("LevelingAMOP") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\The Jade Forest (10-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Valley of the Four Winds (15-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Krasarang Wilds (15-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Kun-Lai Summit (20-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Townlong Steppes (25-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Dread Wastes (30-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Isle of Thunder (50-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Operation: Shieldwall")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Daily Quest")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Pandaria (10-70)\\Peak of Serenity\\Monk Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\The Loremaster\\Loremaster of Pandaria")
