local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("MountsAMID") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts\\Mounts\\Flying Mounts\\World Event Mounts\\Ballistic Bronco")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts\\Mounts\\Ground Mounts\\World Event Mounts\\Brawlin' Bruno")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts\\Mounts\\Flying Mounts\\Achievement Mounts\\Anu'shalla Shadow's Guidance")
