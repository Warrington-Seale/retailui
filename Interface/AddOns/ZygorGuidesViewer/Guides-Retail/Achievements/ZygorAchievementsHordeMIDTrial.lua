local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Horde" then return end
if ZGV:DoMutex("AchievementsHMID") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Aquatic Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Beast Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Critter Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Dragonkin Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Elemental Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Flying Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Humanoid Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Magic Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Mechanical Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Undead Battler of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Family Battler of Kalimdor")
