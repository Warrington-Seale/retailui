local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("PetsAMID") then return end
ZygorGuidesViewer.GuideMenuTier = "SHA"
ZygorGuidesViewer:RegisterGuide("Pets & Mounts\\Peaceful Pets\\Dragonkin Pets\\Moon Darter",{
patch='120000',
source='Achievement',
author="support@zygorguides.com",
description="This guide will teach you how to acquire the Moon Darter peaceful pet.",
keywords={"Achievement","Dragonkin"},
pet=4913,
startlevel=1,
},[[
step
You can only access the battle pet tamers necessary to acquire this pet item on a Horde character.
confirm
]])
