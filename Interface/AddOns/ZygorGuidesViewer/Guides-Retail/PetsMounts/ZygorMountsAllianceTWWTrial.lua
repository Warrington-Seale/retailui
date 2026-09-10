local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("MountsATWW") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\Flying Mounts\\Vendor Mounts\\Remembered Golden Gryphon")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\World Event Mounts\\Heartseeker Mana Ray")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\Flying Mounts\\PVP Mounts\\Vicious Skyflayer")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\Flying Mounts\\PVP Mounts\\Vicious Electro Eel")
