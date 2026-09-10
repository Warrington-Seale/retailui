local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Horde" then return end
if ZGV:DoMutex("LevelingHCLASSHERITAGE") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Blood Elf Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Forsaken Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Goblin Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Orc Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Tauren Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Troll Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Pandaren Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Highmountain Tauren Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Mag'har Orc Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Nightborne Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Vulpera Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Zandalari Troll Heritage Armor")
