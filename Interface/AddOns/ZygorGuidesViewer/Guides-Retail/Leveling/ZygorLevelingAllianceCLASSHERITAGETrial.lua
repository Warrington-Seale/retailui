local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("LevelingACLASSHERITAGE") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Draenei Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Dwarf Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Gnome Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Human Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Night Elf Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Worgen Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Pandaren Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Dark Iron Dwarf Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Kul Tiran Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Lightforged Draenei Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Mechagnome Heritage Armor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Heritage Armor\\Void Elf Heritage Armor")
