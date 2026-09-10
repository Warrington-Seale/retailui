local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldGatherCSHADOW") then return end
ZygorGuidesViewer.GuideMenuTier = "SHA"
