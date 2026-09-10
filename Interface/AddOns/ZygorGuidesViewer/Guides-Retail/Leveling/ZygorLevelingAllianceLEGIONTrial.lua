local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("LevelingALEGION") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Balance of Power Questline")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Broken Shore\\Excavator Karla Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Broken Shore\\Anduin Wrynn Questline")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Dalaran Postmaster Quest Line")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Rogue Pickpocketing Quest Line")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Legion (10-70)\\Meatball Order Hall Champion")
