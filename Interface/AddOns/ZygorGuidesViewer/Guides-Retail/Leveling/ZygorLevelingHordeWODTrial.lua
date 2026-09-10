local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Horde" then return end
if ZGV:DoMutex("LevelingHWOD") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Draenor Intro")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Frostfire Ridge (10-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Gorgrond (15-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Talador (20-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Spires of Arak (30-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Nagrand (35-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\Draenor (10-70)\\Tanaan Jungle (40-70)")
ZygorGuidesViewer:RegisterGuidePlaceholder("Leveling Guides\\The Loremaster\\Loremaster of Draenor")
