local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("AchievementsAMID") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Aquatic Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Beast Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Critter Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Dragonkin Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Elemental Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Flying Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Humanoid Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Magic Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Mechanical Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Undead Battler of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Achievement Guides\\Pet Battles\\Classic (1-60)\\Family Battler of Eastern Kingdoms")
