local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("EventsA") then return end
ZygorGuidesViewer.GuideMenuTier = "TRI"
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brawler's Guild\\Battle for Azeroth Brawler's Guild")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Brewfest Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Brewfest Dailies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\A Round on the House on the Dragon Isles")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\A Round on the House in Khaz Algar")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\The Brewfest Diet")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Have Keg, Will Travel")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Brew of the Month")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Does Your Wolpertinger Linger?")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Direbrewfest")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Brewmaster")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Almost Blind Luck")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Disturbing the Peace")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Brew of the Year")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Brewfest\\Strange Brew")
ZygorGuidesViewer:RegisterGuide("Events Guides\\Battle for Azeroth\\The Burning of Teldrassil",{
description="This guide will help to defend Teldrassil against the incoming Horde attack..",
condition_suggested=function() return level >= 10 and level <= 50 and not completedq(53310) end,
},[[
step
accept A Short-Lived Peace##52058
|tip You will accept this quest automatically.
step
Enter the building |goto Stormwind City/0 80.69,37.80 < 5 |walk
talk Anduin Wrynn##107574
|tip Inside the building.
turnin A Short-Lived Peace##52058 |goto Stormwind City/0 85.90,31.57
accept The Horde Uprising##52060 |goto Stormwind City/0 85.90,31.57
step
Watch the dialogue
talk Master Mathias Shaw##139798
|tip Inside the building.
turnin The Horde Uprising##52060 |goto Stormwind City/0 85.15,32.35
accept A Disturbance in Ashenvale##52062 |goto Stormwind City/0 85.15,32.35
step
Follow the path |goto Stormwind City/0 83.88,30.57 < 5 |walk
Run up the stairs |goto Stormwind City/0 83.48,29.81 < 5 |only if walking
Follow the path |goto Stormwind City/0 83.34,29.54 < 5 |only if walking
click Portal to Astranaar##297575
Take the Portal to Astranaar |q 52062/1 |goto Stormwind City/0 82.68,26.84
step
Find Delaryn Summermoon |q 52062/2 |goto Ashenvale/0 35.86,50.43
step
talk Captain Delaryn Summermoon##134578
turnin A Disturbance in Ashenvale##52062 |goto Ashenvale/0 35.86,50.43
accept The Light of Elune##52072 |goto Ashenvale/0 35.86,50.43
accept Knives of the Forsaken##53616 |goto Ashenvale/0 35.86,50.43
stickystart "Kill_Forsaken_Assassins"
step
clicknpc Astranaar Sentinel##144282+
|tip They look like Night Elf corpses on the ground around this area.
Honor #6# Fallen Soldiers |q 52072/1 |goto Ashenvale/0 35.88,50.20
step
label "Kill_Forsaken_Assassins"
kill 8 Forsaken Assassin##140801 |q 53616/1 |goto Ashenvale/0 36.06,50.26
|tip They are stealthed around this area.
step
talk Captain Delaryn Summermoon##134578
turnin The Light of Elune##52072 |goto Ashenvale/0 35.86,50.43
turnin Knives of the Forsaken##53616 |goto Ashenvale/0 35.86,50.43
accept A Soft Glow##52116 |goto Ashenvale/0 35.86,50.43
step
Meet Malfurion at the Entrance to Darkshore |q 52116/1 |goto Darkshore/0 43.82,89.82
step
Watch the dialogue
talk Malfurion Stormrage##133693
turnin A Soft Glow##52116 |goto Darkshore/0 43.58,89.25
accept Hidden Amongst the Leaves##52234 |goto Darkshore/0 43.58,89.25
accept Mercy for the Mad##53617 |goto Darkshore/0 43.58,89.25
stickystart "Kill_Frenzied_Blackwood_Furbolgs"
step
talk Druid of the Claw##140633+
|tip They look like friendly NPC's on the ground around this area.
|tip Some are shapeshifted in animal form and some look like night elves.
Select _"You must defend the Grove of the Ancients!"_
Dispatch #8# Druids |q 52234/1 |goto Darkshore/0 42.07,77.29
step
label "Kill_Frenzied_Blackwood_Furbolgs"
kill 10 Frenzied Blackwood Furbolg##140686 |q 53617/1 |goto Darkshore/0 41.72,76.89
step
talk Captain Delaryn Summermoon##134578
turnin Hidden Amongst the Leaves##52234 |goto Darkshore/0 43.41,75.56
turnin Mercy for the Mad##53617 |goto Darkshore/0 43.41,75.56
accept Garden Grove##52240 |goto Darkshore/0 43.41,75.56
step
kill Monstrous Shredder##143562 |q 52240/1 |goto Darkshore/0 43.98,75.34
|tip You may need help with this.
step
talk Captain Delaryn Summermoon##134578
turnin Garden Grove##52240 |goto Darkshore/0 45.20,74.96
step
talk Onu##33072
accept Enraged Furbolgs##52245 |goto Darkshore/0 45.41,74.85
step
talk Elder Brolg##140719
Select _"Come with us to safety. We will not harm you."_
Rescue Elder Brolg |q 52245/1 |goto Darkshore/0 43.54,81.08
step
_Next to you:_
talk Captain Delaryn Summermoon##140728
accept Elves in the Machine##53551
stickystart "Sabotage_Horde_Demolishers"
step
Enter the cave |goto Darkshore/0 46.27,83.60 < 5 |walk
talk Gren Tornfur##140720
|tip Inside the cave.
Select _"Come with us to safety. We will not harm you."_
Rescue Gren Tornfur |q 52245/2 |goto Darkshore/0 46.63,83.90
step
Leave the cave |goto Darkshore/0 46.27,83.60 < 5 |walk
talk Elder Brownpaw##140721
Select _"Come with us to safety. We will not harm you."_
Rescue Elder Brownpaw |q 52245/3 |goto Darkshore/0 46.47,85.73
step
label "Sabotage_Horde_Demolishers"
clicknpc Horde Demolisher##144103+
|tip They look like large siege vehicles on the ground around this area.
|tip Run away from them after you click them.
|tip Use the "Sleeping Powder" ability to put enemies to sleep.
|tip It appears as a button on the screen.
Sabotage #5# Horde Demolishers |q 53551/1 |goto Darkshore/0 45.02,84.22
step
_Next to you:_
talk Captain Delaryn Summermoon##140728
turnin Elves in the Machine##53551
step
talk Onu##33072
turnin Enraged Furbolgs##52245 |goto Darkshore/0 45.41,74.85
accept The Wake of Something New##52242 |goto Darkshore/0 45.41,74.85
step
click Azerite Deposit##292886
Discover the Source of Onu's Pain |q 52242/1 |goto Darkshore/0 34.66,85.17
step
talk Captain Delaryn Summermoon##134578
turnin The Wake of Something New##52242 |goto Darkshore/0 34.73,85.11
accept Azerite Denial##53619 |goto Darkshore/0 34.73,85.11
accept No Horde Allowed##53621 |goto Darkshore/0 34.73,85.11
stickystart "Slay_Horde_Combatants"
step
click Azerite Deposit##292886+
|tip They look like black and silver rock clusters on the ground around this area.
Collect #6# Azerite |q 53619/1 |goto Darkshore/0 32.63,84.08
step
label "Slay_Horde_Combatants"
Kill enemies around this area
Slay #10# Horde Combatants |q 53621/1 |goto Darkshore/0 32.63,84.08
step
talk Captain Delaryn Summermoon##134578
turnin Azerite Denial##53619 |goto Darkshore/0 34.73,85.11
turnin No Horde Allowed##53621 |goto Darkshore/0 34.73,85.11
accept Malfurion Returns##52256 |goto Darkshore/0 34.73,85.11
step
talk Malfurion Stormrage##133693
turnin Malfurion Returns##52256 |goto Darkshore/0 42.30,66.80
accept "Rock" The World##52257 |goto Darkshore/0 42.30,66.80
step
clicknpc Tree of Life##143861
Speak with Tree of Life |q 52257/1 |goto Darkshore/0 42.09,66.86
step
Kill enemies around this area
|tip Use the abilities on your action bar.
Slay #50# Horde Enemies |q 52257/2 |goto Darkshore/0 42.17,69.08
step
Return to Malfurion Stormrage |goto Darkshore/0 42.07,66.87 < 7 |noway |c |q 52257
step
talk Malfurion Stormrage##133693
turnin "Rock" The World##52257 |goto Darkshore/0 42.30,66.80
accept Long Away##52197 |goto Darkshore/0 42.30,66.80
step
talk Captain Delaryn Summermoon##134578
turnin Long Away##52197 |goto Darnassus/0 40.00,50.42
accept A Looming Threat##52279 |goto Darnassus/0 40.00,50.42
step
talk Janthes Shadeleaf##144146
Select _"The Horde have halted their advance at the Wildbend River! We must push them back at once!"_
Rally the Druids of the Claw |q 52279/2 |goto Darnassus/0 45.61,35.93
step
talk Myara Sunsong##140498
Select _"Captain, the Horde have reached the Wildbend River! We cannot hold them for long!"_
Rally the Kaldorei Forces |q 52279/3 |goto Darnassus/0 61.00,49.41
step
talk Astarii Starseeker##4090
Select _"Priestess, we require your aid to hold the Horde at Wildbend River."_
Rally the Priestesses of the Moon |q 52279/1 |goto Darnassus/0 42.99,73.06
step
talk Malfurion Stormrage##140877
turnin A Looming Threat##52279 |goto Teldrassil/0 58.47,89.49
step
talk Captain Delaryn Summermoon##134578
accept A Threat from the North##52973 |goto Teldrassil/0 58.48,89.41
step
talk Malfurion Stormrage##140877
turnin A Threat from the North##52973 |goto Darkshore/0 50.42,20.01
accept Rescue Effort##52974 |goto Darkshore/0 50.42,20.01
accept Defending Lor'danel##53622 |goto Darkshore/0 50.42,20.01
step
talk Captain Delaryn Summermoon##134578
|tip She sometimes runs around this area fighting.
|tip You may have to search for her.
accept Action This Day##52975 |goto Darkshore/0 50.43,19.68
stickystart "Slay_Horde_Attackers"
step
talk Lor'danel Citizen##142408+
|tip They look like friendly NPCs cowering in fear on the ground around this area.
Select _"I have cleared a path - - you must escape now!"_
Rescue #8# Lor'danel Citizens |q 52974/1 |goto Darkshore/0 50.80,19.30
step
kill Gormok Axefall##144364 |q 52975/1 |goto Darkshore/0 47.67,20.42
step
kill Ragash Bloodwish##144365 |q 52975/2 |goto Darkshore/0 46.82,18.82
step
label "Slay_Horde_Attackers"
Kill enemies around this area
Slay #15# Horde Attackers |q 53622/1 |goto Darkshore/0 49.00,19.56
step
talk Captain Delaryn Summermoon##134578
|tip She sometimes runs around this area fighting.
|tip You may have to search for her.
turnin Rescue Effort##52974 |goto Darkshore/0 50.43,19.68
turnin Defending Lor'danel##53622 |goto Darkshore/0 50.43,19.68
turnin Action This Day##52975 |goto Darkshore/0 50.43,19.68
accept The Guidance of Our Shan'do##52977 |goto Darkshore/0 50.43,19.68
step
talk Zidormi##141489
Select _"Can you return me to the present time?"_
Travel to the Present |complete not ZGV.InPhase('Old Darnassus') or not completedq(53310) |goto Darkshore/0 48.86,24.46 |q 52977
step
Find Malfurion in Darkshore |q 52977/1 |goto Darkshore/0 46.17,24.42
step
Watch the dialogue
Assist Malfurion |q 52977/2 |goto Darkshore/0 45.94,24.47
step
clicknpc Tamed Hippogryph##142110
Use Tyrande's Mount |q 52977/3 |goto Darkshore/0 45.96,24.96
step
Return to Darnassus |goto Darnassus/0 43.01,73.09 < 7 |c |q 52977 |notravel
step
Enter the building |goto Darnassus/0 43.01,74.83 < 5 |walk
talk Mia Greymane##142978
|tip Inside the building.
turnin The Guidance of Our Shan'do##52977 |goto Darnassus/0 43.09,78.62
accept A Flicker of Hope##53095 |goto Darnassus/0 43.09,78.62 |only if not completedq(53310)
step
Leave the building |goto Darnassus/0 43.01,74.80 < 3 |walk
talk Darnassian Citizen##143409+
Select _"The flames are clear! Get to the Temple of the Moon!"_
Evacuate #982# Darnassian Citizens |q 53095/1 |goto Darnassus/0 58.76,68.28 |only if not completedq(53310)
|tip Use the "Douse" ability on on fires around this area.
|tip It appears as a button on the screen.
|tip It is impossible to complete this objective, you will fail.
step
Return to the Temple of the Moon |goto Darnassus/0 43.37,78.31 < 7 |c |q 53095 |notravel
step
Watch the dialogue
turnin A Flicker of Hope##53095 |goto Darnassus/0 43.37,78.31
|tip You will turn in this quest automatically.
accept From the Ashes...##53310 |goto Darnassus/0 43.37,78.31
|tip You will accept this quest automatically.
step
click Portal to Stormwind##303144 |goto Darnassus/0 43.91,78.68
Teleport to Stormwind City |goto Stormwind City/0 49.59,86.53 < 7 |noway |c |q 53310
step
Enter the building |goto Stormwind City/0 80.69,37.80 < 5 |walk
talk Anduin Wrynn##107574
|tip Inside the building.
turnin From the Ashes...##53310 |goto Stormwind City/0 85.90,31.57
]])
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Kul Tiras Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Stormwind Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Shattrath Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Dalaran Oracles Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Dalaran Wolvar Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Children's Week Dornogal Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Aw, Isn't It Cute?")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Bad Example")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Daily Chores")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Hail To The King, Baby")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Home Alone")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\School of Hard Knocks")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\Veteran Nanny")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Children's Week\\Achievements\\For the Children")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Darkmoon Faire Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Darkmoon Faire Dailies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Ace Tonk Commander")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Taking the Show on the Road")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Fairegoer's Feast")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Come One, Come All!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Blastenheimer Bullseye")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Brood of Alysrazor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Don't Stop Dancing")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Feeling It")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Can't Stop the Feeling")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Maniac on the Dance Floor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Dancing Machine")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Darkmoon Defender")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Darkmoon Dungeoneer")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Darkmoon Despoiler")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Darkmoon Dominator")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Darkmoon Like the Wind")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Faire Favors")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Hey, You're a Rockstar!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Make You Sweat")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Mosh Pit")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Taking this Show on the Road")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Perfect Performance")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\I Was Promised a Pony")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Triumphant Turtle Tossing")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\That's Whack!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Quick Shot")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\Step Right Up")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Darkmoon Faire\\Achievements\\That Rabbit's Dynamite!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Rock n' Roll")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\'Tis the Season")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\A Frosty Shake")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\BB King")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Holiday Bromance")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\A-Caroling We Will Go")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Crashin' & Thrashin'")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\The Danger Zone")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Fa-la-la-la-Ogri'la")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\He Knows If You've Been Naughty")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Iron Armada")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Let It Snow")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Merrymaker")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\On Metzen!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Scrooge")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\Simply Abominable")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\The Winter Veil Gourmet")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Achievements\\With a Little Helper from My Friends")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Feast of Winter Veil Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Feast of Winter Veil\\Feast of Winter Veil Daily Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Hallow's End Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Hallow's End Dailies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\A Cleansing Fire")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Don't Lose Your Head, Man")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Kickin' With the Wick")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Check Your Head")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\A Frightening Friend")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\G.N.E.R.D. Rage")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Hallowed Be Thy Name")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\A Mask for All Occasions")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\The Mask Task")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\The Masquerade")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Out With It")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Rotten Hallow")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\The Savior of Hallow's End")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Sinister Calling")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\That Sparkling Smile")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Trick or Treat!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Hallow's End\\Achievements\\Tricks and Treats")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Harvest Festival\\Harvest Festival Quest")
ZygorGuidesViewer:RegisterGuide("Events Guides\\Warlords of Draenor\\Iron Horde Invasion",{
description="Take part in the opening event of the Warlords of Draenor!",
condition_end=function() return completedq(36941) end,
},[[
step
talk Zidormi##88206
Select _"Take me back to the present."_
Travel to the Present |complete not ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands/0 48.16,7.28 |q 36941 |future
step
talk Vindicator Maraad##82270
accept Attack of the Iron Horde##35460 |goto Blasted Lands/0 66.58,28.26
accept Under Siege##35462 |goto Blasted Lands/0 66.58,28.26
step
talk Bodrick Grey##85213
accept Peeking into the Portal##36379 |goto Blasted Lands/0 66.94,27.93
step
talk Araazi##85731
fpath Shattered Beachhead |goto Blasted Lands/0 67.65,27.97
stickystart "Kill_Ironmarch_Grunts"
step
clicknpc Iron Demolisher##82273+
Destroy #3# Iron Demolishers |q 35462/1 |goto Blasted Lands/0 63.95,32.69
step
label "Kill_Ironmarch_Grunts"
kill 8 Ironmarch Grunt##76556 |q 35460/1 |goto Blasted Lands/0 63.95,32.69
step
click Telescope##237144
Use the Telescope |q 36379/1 |goto Blasted Lands/0 61.68,36.68
step
talk Vindicator Maraad##82270
turnin Attack of the Iron Horde##35460 |goto Blasted Lands/0 66.58,28.26
turnin Under Siege##35462 |goto Blasted Lands/0 66.58,28.26
accept Subversive Scouts##35463 |goto Blasted Lands/0 66.58,28.26
step
talk Bodrick Grey##85213
turnin Peeking into the Portal##36379 |goto Blasted Lands/0 66.94,27.93
accept Ending Execution##35464 |goto Blasted Lands/0 66.94,27.93
stickystart "Kill_Ironmarch_Scouts"
step
kill Ironmarch Executioner##82774+
|tip They stand in front of kneeling Nethergarde Prisoners around this area.
Stop #3# Executions |q 35464/1 |goto Blasted Lands/0 59.37,27.80
step
label "Kill_Ironmarch_Scouts"
kill 5 Ironmarch Scout##76886 |q 35463/1 |goto Blasted Lands/0 66.90,28.21
|tip They are stealthed near hills and open areas around this area.
step
talk Bodrick Grey##85213
turnin Ending Execution##35464 |goto Blasted Lands/0 66.94,27.93
step
talk Vindicator Maraad##82270
turnin Subversive Scouts##35463 |goto Blasted Lands/0 66.58,28.26
accept Investigating the Invasion##36307 |goto Blasted Lands/0 66.58,28.26
step
talk Vindicator Maraad##84929
turnin Investigating the Invasion##36307 |goto Blasted Lands/0 51.93,28.65
accept Lunatic Lieutenants##35486 |goto Blasted Lands/0 51.93,28.65
accept For Nethergarde!##35492 |goto Blasted Lands/0 51.93,28.65
step
talk Commander Vines##82447
accept Mementos of the Fallen##35494 |goto Blasted Lands/0 52.01,28.51
step
kill Rukah the Machinist##73458
|tip She walks around this area.
collect Rukah's Battleplan##113400 |q 35486/2 |goto Blasted Lands/0 57.00,17.96
step
click Keri's Mug##232576
|tip On the corner of the table under the tent.
collect Keri's Mug##113397 |q 35494/3 |goto Blasted Lands/0 59.35,17.97
step
click Alliance Flag##232532
Plant the Alliance Flag outside of the Main Keep |q 35492/3 |goto Blasted Lands/0 59.86,15.81
step
kill Gar Steelcrush##73446
|tip Upstairs inside the keep.
collect Gar's Battleplan##113401 |q 35486/3 |goto Blasted Lands/0 60.19,13.81
step
click Strumner's Sword##232573
|tip Inside the building.
collect Strumner's Sword##113395 |q 35494/1 |goto Blasted Lands/0 61.81,14.92
step
kill Mokrik Blackfingers##73459
collect Mokrik's Battleplan##113399 |q 35486/1 |goto Blasted Lands/0 62.86,13.12
step
click Alliance Flag##232532
Plant the Alliance Flag at the Center of Nethergarde |q 35492/2 |goto Blasted Lands/0 61.60,18.49
step
click Krolan's Shield##232575
collect Krolan's Shield##113396 |q 35494/2 |goto Blasted Lands/0 60.60,20.01
step
click Alliance Flag##232532
Plant the Alliance Flag at the Entrance to Nethergarde |q 35492/1 |goto Blasted Lands/0 62.97,22.51
step
talk Commander Vines##82447
turnin Mementos of the Fallen##35494 |goto Blasted Lands/0 52.01,28.51
step
talk Vindicator Maraad##82270
turnin Lunatic Lieutenants##35486 |goto Blasted Lands/0 51.93,28.65
turnin For Nethergarde!##35492 |goto Blasted Lands/0 51.93,28.65
accept Toothsmash the Annihilator##35495 |goto Blasted Lands/0 51.93,28.65
accept Death to the Dreadmaul##35488 |goto Blasted Lands/0 51.93,28.65
step
talk Enohar Thunderbrew##76111
accept Enohar's Revenge##35496 |goto Blasted Lands/0 51.78,28.74
stickystart "Slay_Dreadmaul_Ogres"
step
click Cooking Pot##232625
Poison the Cooking Pot |q 35496/1 |goto Blasted Lands/0 43.89,31.01 |count 1
step
click Cooking Pot##232625
Poison the Cooking Pot |q 35496/1 |goto Blasted Lands/0 44.32,35.60 |count 2
step
kill Toothsmash the Annihilator##82451 |q 35495/1 |goto Blasted Lands/0 43.61,36.32
|tip He walks around this area.
step
click Cooking Pot##232625
Poison the Cooking Pot |q 35496/1 |goto Blasted Lands/0 43.40,36.99 |count 3
step
label "Slay_Dreadmaul_Ogres"
Kill Dreadmaul enemies around this area
Slay #8# Dreadmaul Ogres |q 35488/1 |goto Blasted Lands/0 43.83,36.12
step
talk Enohar Thunderbrew##76111
turnin Enohar's Revenge##35496 |goto Blasted Lands/0 51.78,28.74
step
talk Vindicator Maraad##82270
turnin Toothsmash the Annihilator##35495 |goto Blasted Lands/0 51.93,28.65
turnin Death to the Dreadmaul##35488 |goto Blasted Lands/0 51.93,28.65
accept Gar'mak Bladetwist##35500 |goto Blasted Lands/0 51.93,28.65
step
kill Gar'mak Bladetwist##82918 |q 35500/1 |goto Blasted Lands/0 40.05,11.41
|tip Upstairs inside the tower.
step
talk Vindicator Maraad##82270
turnin Gar'mak Bladetwist##35500 |goto Blasted Lands/0 51.93,28.65
accept Report to the King##36941 |goto Blasted Lands/0 51.93,28.65
step
talk King Varian Wrynn##29611
|tip Inside the keep.
turnin Report to the King##36941 |goto Stormwind City/0 85.92,31.56
]])
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Love is in the Air Main Questline")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Love is in the Air Dailies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Be Mine!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Dangerous Love")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Fistful of Love")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\I Pitied The Fool")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Lonely?")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Lovely Luck Is On Your Side")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\My Love is Like a Red, Red Rose")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Perma-Peddle")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Shafted!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Sweet Tooth")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\The Rocket's Pink Glare")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Love is in the Air\\Achievements\\Support Your Local Artisans")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Lunar Festival Main Questline")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Lunar Festival Crown Transmog Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Lunar Festival Optimized Elders Path")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\A Coin of Ancestry")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\5 Coins of Ancestry")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\10 Coins of Ancestry")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\25 Coins of Ancestry")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\50 Coins of Ancestry")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of Khaz Algar")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of Cataclysm")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of Northrend")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of the Dungeons")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of the Alliance")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of the Horde")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elune's Blessing")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Frenzied Firecracker")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\The Rocket's Red Glare")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Lunar Festival Finery")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\To Honor One's Elders")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Lunar Festival\\Achievements\\Elders of the Dragon Isles")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Ignite the Skies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Dailies")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Bonfires")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\Midsummer Achievement Guide")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Outland")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Northrend")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing the Cataclysm")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Pandaria")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Draenor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing the Broken Isles")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Extinguishing Zandalar")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Eastern Kingdoms")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Kalimdor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Outland")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Northrend")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Cataclysm")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Pandaria")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Draenor")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Broken Isles")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Kul Tiras")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of the Dragon Isles")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Khaz Algar")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Midsummer Fire Festival\\Midsummer Fire Festival Achievements\\The Fires of Azeroth\\Flame Warden of Midnight")
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Noblegarden Quests",{
description="This guide section will walk you through completing the quests for the Noblegarden event.",
condition_suggested=function() return isevent('Noblegarden') end,
condition_end=function() return completedq(13502) end,
},[[
step
talk Holiday Enthusiast##199261
accept A Spring Awakening##79134 |goto Valdrakken/0 55.05,37.11
|tip This quest is optional and can be skipped.
step
talk Human Commoner##18927
accept Spring Collectors##13484 |goto Stormwind City/0 61.68,74.19
step
talk Zinnia Brooks##211646
turnin A Spring Awakening##79134 |goto Elwynn Forest/0 42.05,65.04 |only if haveq(79134) or completedq(79134)
accept What the Duck?##79322 |goto Elwynn Forest/0 42.05,65.04
step
talk Spring Collector##32799
turnin Spring Collectors##13484 |goto Elwynn Forest/0 42.63,65.96
step
talk Noblegarden Vendor##32836
accept A Tisket, A Tasket, A Noblegarden Basket##13502 |goto Elwynn Forest/0 42.66,65.91
stickystart "Collect_Noblegarden_Chocolate"
step
clicknpc Furious Duck##217725+
use the Horn of Honking##210558
|tip Use it on ducks found all over Goldshire.
Scare #10# Ducks |q 79322/1 |goto Elwynn Forest/0 42.44,65.50
step
label "Collect_Noblegarden_Chocolate"
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 10 Noblegarden Chocolate##44791 |q 13502/1 |goto Elwynn Forest/0 42.42,65.63
step
talk Noblegarden Vendor##32836
turnin A Tisket, a Tasket, a Noblegarden Basket##13502 |goto Elwynn Forest/0 42.66,65.91
step
talk Zinnia Brooks##211646
turnin What the Duck?##79322 |goto Elwynn Forest/0 42.05,65.04
accept A Fowl Concoction##79323 |goto Elwynn Forest/0 42.05,65.04
step
talk Emmery Fiske##216129
|tip Inside the tower.
Select _"Zinnia sent me..."_ |gossip 121089
Speak with Emmery Fiske at the Wizard's Sanctum in Stormwind |q 79323/1 |goto Stormwind City/0 48.62,86.92
step
talk Zinnia Brooks##211646
turnin A Fowl Concoction##79323 |goto Elwynn Forest/0 42.05,65.04
step
talk Tethris Dewgazer##217147
accept Duck Tales##79330 |goto Elwynn Forest/0 42.00,64.90
step
use the Duck Potion##212608
Use the Potion |q 79330/1 |goto Elwynn Forest/0 42.00,64.90
step
talk Furious Duck##217725+
Gather Information #5# Times |q 79330/2 |goto Elwynn Forest/0 42.44,65.50
step
talk Zinnia Brooks##211646
turnin Duck Tales##79330 |goto Elwynn Forest/0 42.05,65.04
accept Just a Waddle Away##79331 |goto Elwynn Forest/0 42.05,65.04
step
use the Duck Potion##212608
Use the Potion |q 79331/1 |goto Elwynn Forest/0 33.68,70.85
step
Find Daetan |q 79331/2 |goto Elwynn Forest/0 33.68,70.85
|tip Wait for him to fly down, land, and transform.
step
Remove your Duck Disguise |nobuff Duck Disguise##432494
|tip Right-click the Duck Disguise buff on your buff bar.
stickystart "Accept_Feathered_Fiend"
step
click Golden Egg Heirloom##424098
|tip If the mob is up, kill it with nearby players.
Find the Heirloom |q 79331/3 |goto Elwynn Forest/0 30.39,91.37
step
label "Accept_Feathered_Fiend"
kill Daetan Swiftplume##218738
|tip Search around nearby for a huge golden egg.
|tip One person needs to drag the big egg to the nest to spawn Daetan.
|tip This enemy will require a group.
collect Noblegarden Trinket##216932 |n
accept Feathered Fiend##73192 |goto Elwynn Forest/0 30.39,91.37
step
talk Zinnia Brooks##211646
turnin Just a Waddle Away##79331 |goto Elwynn Forest/0 42.05,65.04
turnin Feathered Fiend##73192 |goto Elwynn Forest/0 42.05,65.04
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Noblegarden Dailies",{
condition_suggested=function() return isevent('Noblegarden') end,
description="This guide section will walk you through completing the dailies for the Noblegarden event.",
},[[
step
talk Holiday Enthusiast##199261
accept A Spring Awakening##79134 |goto Valdrakken/0 55.05,37.11
|tip This quest is optional and can be skipped.
step
talk Human Commoner##18927
accept Spring Collectors##13484 |goto Stormwind City/0 61.68,74.19
|tip If this quest is not available you can skip this step.
step
label "Begin_Daily_Quests"
talk Spring Collector##32799
turnin Spring Collectors##13484 |goto Elwynn Forest/0 42.63,65.96 |only if haveq(13484) or completedq(13484)
accept The Great Egg Hunt##13480 |goto Elwynn Forest/0 42.63,65.96
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 20 Brightly Colored Shell Fragment##44806 |q 13480/1 |goto Elwynn Forest/0 42.42,65.63
step
talk Spring Collector##32799
turnin The Great Egg Hunt##13480 |goto Elwynn Forest/0 42.63,65.96
step
talk Zinnia Brooks##211646
turnin A Spring Awakening##79134 |goto Elwynn Forest/0 42.05,65.04 |only if haveq(79134) or completedq(79134)
accept What the Duck?##79322 |goto Elwynn Forest/0 42.05,65.04
step
clicknpc Furious Duck##217725+
use the Horn of Honking##210558
|tip Use it on ducks found all over Goldshire.
Scare #10# Ducks |q 79322/1 |goto Elwynn Forest/0 42.44,65.50
step
talk Zinnia Brooks##211646
turnin What the Duck?##79322 |goto Elwynn Forest/0 42.05,65.04
accept A Fowl Concoction##79323 |goto Elwynn Forest/0 42.05,65.04
step
talk Emmery Fiske##216129
|tip Inside the tower.
Select _"Zinnia sent me..."_ |gossip 121089
Speak with Emmery Fiske at the Wizard's Sanctum in Stormwind |q 79323/1 |goto Stormwind City/0 48.62,86.92
step
talk Zinnia Brooks##211646
turnin A Fowl Concoction##79323 |goto Elwynn Forest/0 42.05,65.04
step
talk Tethris Dewgazer##217147
accept Duck Tales##79330 |goto Elwynn Forest/0 42.00,64.90
step
use the Duck Potion##212608
Use the Potion |q 79330/1 |goto Elwynn Forest/0 42.00,64.90
step
talk Furious Duck##217725+
Gather Information #5# Times |q 79330/2 |goto Elwynn Forest/0 42.44,65.50
step
talk Zinnia Brooks##211646
turnin Duck Tales##79330 |goto Elwynn Forest/0 42.05,65.04
accept Just a Waddle Away##79331 |goto Elwynn Forest/0 42.05,65.04
step
use the Duck Potion##212608
Use the Potion |q 79331/1 |goto Elwynn Forest/0 42.05,65.04
step
Find Daetan |q 79331/2 |goto Elwynn Forest/0 33.68,70.85
|tip Wait for him to fly down, land, and transform.
step
Remove your Duck Disguise |nobuff Duck Disguise##432494
|tip Right-click the Duck Disguise buff on your buff bar.
stickystart "Accept_Feathered_Fiend"
step
click Golden Egg Heirloom##424098
|tip If the Daetan Swiftplume is up, kill it with nearby players.
Find the Heirloom |q 79331/3 |goto Elwynn Forest/0 30.39,91.37
step
label "Accept_Feathered_Fiend"
kill Daetan Swiftplume##218738
|tip Search around nearby for a huge golden egg.
|tip One person needs to drag the big egg to the nest to spawn Daetan.
|tip This enemy will require a group.
collect Noblegarden Trinket##216932 |n
accept Feathered Fiend##73192 |goto Elwynn Forest/0 30.39,91.37
step
talk Zinnia Brooks##211646
turnin Just a Waddle Away##79331 |goto Elwynn Forest/0 42.05,65.04
turnin Feathered Fiend##73192 |goto Elwynn Forest/0 42.05,65.04
step
talk Zinnia Brooks##211646
accept Quacking Down##78274 |goto Elwynn Forest/0 42.05,65.04
step
clicknpc Furious Duck##217725+
use the Horn of Honking##210558
|tip Use it on ducks found all over Goldshire.
Scare Off #10# Ducks |q 78274/1 |goto Elwynn Forest/0 42.44,65.50
step
talk Zinnia Brooks##211646
turnin Quacking Down##78274 |goto Elwynn Forest/0 42.05,65.04
step
You have completed all Noblegarden daily quests
|tip This guide will reset when more become available.
'|complete not completedq(13480,78274) |next "Begin_Daily_Quests"
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Quacked Killer",{
description="Defeat Daetan Swiftplume.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={20209},
patch='100206',
},[[
step
kill Daetan Swiftplume##218738
|tip Search around nearby for a huge golden egg.
|tip One person needs to drag the big egg to the nest to spawn Daetan.
|tip This enemy will require a group.
|achieve 20209 |goto Elwynn Forest/0 30.39,91.37
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Blushing Bride",{
description="Kiss someone wearing an Elegant Dress while wearing a White Tuxedo Shirt and Black Tuxedo Pants.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2576},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 50 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2576) |or
step
talk Noblegarden Vendor##32836
buy 1 Black Tuxedo Pants##151804 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2576) |or
step
talk Noblegarden Vendor##32836
buy 1 White Tuxedo Shirt##6833 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2576) |or
step
Equip the Black Tuxedo Pants |equipped Black Tuxedo Pants##151804 |or
'|complete achieved(2576) |or
step
Equip the White Tuxedo Shirt |equipped White Tuxedo Shirt##6833 |or
'|complete achieved(2576) |or
step
|script DoEmote("KISS")
Earn the "Blushing Bride" Achievement |achieve 2576
|tip Use the kiss emote on a player wearing an Elegant Dress.
|tip The Elegant Dress looks like a long pink dress when worn.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Chocoholic",{
description="Eat 100 Noblegarden Chocolates during the Noblegarden celebration.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2418},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 100 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2418) |or
step
use the Noblegarden Chocolate##44791+
Eat #100# Noblegarden Chocolates |achieve 2418
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Chocolate Lover",{
description="Eat 25 Noblegarden Chocolates during the Noblegarden celebration.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2417},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 25 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2417) |or
step
use the Noblegarden Chocolate##44791+
Eat #25# Noblegarden Chocolates |achieve 2417
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Desert Rose",{
description="Use Spring Robes to plant a flower in each of the deserts listed below:\n\n"..
"The Badlands\nDesolace\nSilithus\nTanaris\nThousand Needles",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2436},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 50 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2436) |or
step
talk Noblegarden Vendor##32836
buy 1 Spring Florist's Pouch##188694 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2436) |or
step
use the Spring Florist's Pouch##188694
Learn the Spring Florist's Pouch Toy |toy Spring Florist's Pouch##188694 |or
'|complete achieved(2436) |or
step
use the Spring Florist's Pouch##188694
Plant a Flower in the Badlands |achieve 2436/1 |goto Badlands/0 21.71,57.73
step
use the Spring Florist's Pouch##188694
Plant a Flower in Silithus |achieve 2436/3 |goto Silithus/0 78.93,21.97
step
use the Spring Florist's Pouch##188694
Plant a Flower in Tanaris |achieve 2436/4 |goto Tanaris/0 51.38,29.43
step
use the Spring Florist's Pouch##188694
Plant a Flower in Thousand Needles |achieve 2436/5 |goto Thousand Needles/0 79.09,71.89
step
use the Spring Florist's Pouch##188694
Plant a Flower in the Desolace |achieve 2436/2 |goto Desolace/0 64.67,10.44
step
Earn the "Desert Rose" Achievement |achieve 2436
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Dressed for the Occasion",{
description="Discover an Elegant Dress by opening Brightly Colored Eggs during the Noblegarden celebration.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={249},
patch='30002',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
|tip You may need to loot hundreds, if not thousands of these eggs.
use the Brightly Colored Egg##45072+
collect 1 Elegant Dress##151806 |achieve 249 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(249) |or
step
Earn the "Dressed for the Occasion" Achievement |achieve 249
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Hard Boiled",{
description="Lay an egg in Un'Goro Crater's Golakka Hot Springs as a rabbit during the Noblegarden celebration.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2416},
patch='30100',
},[[
step
talk Innkeeper Dreedle##38488
|tip Setting your hearthstone here will greatly reduce your travel time.
|tip Note that you can ONLY use your regular hearthstone, and not toy variants.
|tip You cannot take flight paths or use your mount after getting the buff.
home Marshal's Stand |goto Un'Goro Crater/0 55.38,62.26 |or
'|complete achieved(2416) |or
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
Gain the "Noblegarden Bunny" Buff |havebuff Noblegarden Bunny##61734 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2416) |or
step
use Hearthstone##6948
Earn the "Hard Boiled" Achievement |achieve 2416 |goto Un'Goro Crater/0 35.74,54.21
|tip Avoid enemies, as being hit will cause you to lose your disguise.
|tip Stand in this spot until you lay an egg.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\I Found One!",{
description="Find a Brightly Colored Egg.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2676},
patch='30101',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
collect 1 Brightly Colored Egg##45072 |achieve 2676 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2676) |or
step
Earn the "I Found One!" Achievement |achieve 2676
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Noble Garden",{
description="Hide a Brightly Colored Egg in Stormwind City.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2421},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 5 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.38,65.61 |or
'|complete achieved(2421) |or
step
talk Noblegarden Vendor##32836
buy 1 Noblegarden Egg##44818 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2421) |or
step
use Noblegarden Egg##44818
Earn the "Noble Garden" Achievement |achieve 2421 |goto Stormwind City/0 72.99,89.93
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Shake Your Bunny-Maker",{
description="Use Spring Flowers to place rabbit ears upon players of at least 20th level of the following races:\n\n"..
"Blood Elf\nDraenei\nDwarf\nGnome\nGoblin\nHuman\nNight Elf\nOrc\nTauren\nTroll\nUndead\nWorgen",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2422},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 50 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2422) |or
step
talk Noblegarden Vendor##32836
buy 1 Spring Flowers##45073 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2422) |or
step
Equip the Spring Flowers |equipped Spring Flowers##45073 |or
'|complete achieved(2422) |or
step
use the Spring Flowers##45073
|tip Use it on level 20+ characters.
|tip Check around capital cities.
Place Bunny Ears on a Blood Elf |achieve 2422/1
Place Bunny Ears on a Tauren |achieve 2422/9
Place Bunny Ears on a Draenei |achieve 2422/2
Place Bunny Ears on a Human |achieve 2422/6
Place Bunny Ears on a Troll |achieve 2422/10
Place Bunny Ears on a Dwarf |achieve 2422/3
Place Bunny Ears on a Night Elf |achieve 2422/7
Place Bunny Ears on a Gnome |achieve 2422/4
Place Bunny Ears on an Orc |achieve 2422/8
Place Bunny Ears on a Goblin |achieve 2422/5
Place Bunny Ears on an Undead |achieve 2422/11
Place Bunny Ears on a Worgen |achieve 2422/12
step
Earn the "Shake Your Bunny-Maker" Achievement |achieve 2422
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Spring Fling",{
description="Find your pet Spring Rabbit another one to love in each of the towns listed below:\n\n"..
"Azure Watch\nDolanar\nGoldshire\nKharanos",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={2419},
patch='30100',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
use the Brightly Colored Egg##45072+
collect 100 Noblegarden Chocolate##44791 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(2419) |or
step
talk Noblegarden Vendor##32836
buy 1 Spring Rabbit's Foot##44794 |goto Elwynn Forest/0 42.66,65.91 |or
'|complete achieved(2419) |or
step
use the Spring Rabbit's Foot##44794
Learn the "Spring Rabbit" Battle Pet |learnpet Spring Rabbit##200 |or
'|complete achieved(2419) |or
step
Find Your Spring Rabbit Another to Love in Kharanos |achieve 2419/4 |goto Dun Morogh/0 53.49,50.85
|tip Summon your Spring Rabbit and find another player who has one summoned.
|tip Spring Rabbits are white with brown spots.
|tip Walk near the other player's rabbit to get credit.
step
Find Your Spring Rabbit Another to Love in Goldshire |achieve 2419/3 |goto Elwynn Forest/0 43.10,67.60
|tip Summon your Spring Rabbit and find another player who has one summoned.
|tip Spring Rabbits are white with brown spots.
|tip Walk near the other player's rabbit to get credit.
step
talk Zidormi##141489
Select _"Can you show me what Darkshore was like before the battle?"_
Travel to the Past |complete ZGV.InPhase('Old Darnassus') or achieved(2419) |goto Darkshore/0 48.86,24.46
step
Find Your Spring Rabbit Another to Love in Dolanaar |achieve 2419/2 |goto Teldrassil/0 55.45,50.42
|tip Summon your Spring Rabbit and find another player who has one summoned.
|tip Spring Rabbits are white with brown spots.
|tip Walk near the other player's rabbit to get credit.
step
Find Your Spring Rabbit Another to Love in Azure Watch |achieve 2419/1 |goto Azuremyst Isle/0 49.12,51.49
|tip Summon your Spring Rabbit and find another player who has one summoned.
|tip Spring Rabbits are white with brown spots.
|tip Walk near the other player's rabbit to get credit.
step
Earn the "Spring Fling" Achievement |achieve 2419
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Noblegarden\\Achievements\\Sunday's Finest",{
description="Discover the White Tuxedo Shirt and Black Tuxedo Pants by opening Brightly Colored Eggs during the Noblegarden celebration.",
condition_suggested=function() return isevent('Noblegarden') end,
achieveid={248},
patch='30008',
},[[
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
|tip You may need to loot hundreds, if not thousands of these eggs.
use the Brightly Colored Egg##45072+
collect 1 White Tuxedo Shirt##6833 |achieve 248/1 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(248) |or
step
click Brightly Colored Egg##113768+
|tip There is at least one available at all times.
|tip You may need to loot hundreds, if not thousands of these eggs.
use the Brightly Colored Egg##45072+
collect 1 Black Tuxedo Pants##151804 |achieve 248/2 |goto Elwynn Forest/0 42.42,65.63 |or
'|complete achieved(248) |or
step
Earn the "Sunday's Finest" Achievement |achieve 248
]])
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Quests\\Pilgrim's Bounty Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Quests\\Pilgrim's Bounty Daily Quests")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\FOOD FIGHT!")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Now We're Cookin'")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Pilgrim")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Pilgrim's Paunch")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Pilgrim's Peril")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Pilgrim's Progress")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Sharing is Caring")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Terokkar Turkey Time")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\Turkey Lurkey")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Pilgrim's Bounty\\Achievements\\The Turkinator")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Battle for Azeroth\\Incursions")
ZygorGuidesViewer:RegisterGuidePlaceholder("Events Guides\\Battle for Azeroth\\Tyrande's Ascension (Darkshore Warfront Unlock)")
