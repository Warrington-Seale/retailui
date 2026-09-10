local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Horde" then return end
if ZGV:DoMutex("PetsMountsHDRAGON") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\Ground Mounts\\Vendor Mounts\\White War Wolf")
ZygorGuidesViewer:RegisterGuidePlaceholder("Pets & Mounts Guides\\Mounts\\Ground Mounts\\PVP Mounts\\Vicious Sabertooth")
