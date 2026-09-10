local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)

local profileName = string.format('%s - %s', UnitName('player'), GetRealmName('player'))
local db = {}

local function CopyDBValue(value)
  if type(value) ~= 'table' then
    return value
  end

  local copy = {}
  for key, childValue in pairs(value) do
    copy[key] = CopyDBValue(childValue)
  end

  return copy
end

local function RestoreDBValues(target, snapshot)
  if type(target) ~= 'table' or type(snapshot) ~= 'table' then
    return
  end

  for key, value in pairs(snapshot) do
    target[key] = CopyDBValue(value)
  end
end

db.movers = function(layout, force)
  if Private.GetBlacklist('movers') and not force then
    return
  end

  E.db.movers = E.db.movers or {}

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.movers.AlertFrameMover = 'TOP,UIParent,TOP,0,-354'
    E.db.movers.AzeriteBarMover = 'TOP,ElvUIParent,TOP,-311,-371'
    E.db.movers.BNETMover = 'TOPLEFT,UIParent,TOPLEFT,662,-4'
    E.db.movers.BagsMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-763,4'
    E.db.movers.BelowMinimapContainerMover = E.Retail and 'TOPRIGHT,ElvUIParent,TOPRIGHT,-256,-216' or 'TOPRIGHT,ElvUIParent,TOPRIGHT,-238,-216'
    E.db.movers.BossButton = 'BOTTOM,ElvUIParent,BOTTOM,-200,694'
    E.db.movers.BuffsMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-239,-4'
    E.db.movers.ClassBarMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,4,491'
    E.db.movers.DTPanelCustomPanel_LeftMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4'
    E.db.movers.DTPanelCustomPanel_RightMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4'
    E.db.movers.DebuffsMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-239,-162'
    E.db.movers.DurabilityFrameMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-11,535'
    E.db.movers.ElvUIBagMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
    E.db.movers.ElvUIBankMover = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,289"
    E.db.movers.ExperienceBarMover = 'TOP,UIParent,TOP,0,-4'
    E.db.movers.GMMover = 'TOPLEFT,UIParent,TOPLEFT,413,-4'
    E.db.movers.HonorBarMover = 'TOPLEFT,ElvUIParent,TOPLEFT,528,-338'
    E.db.movers.LeftChatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,29'
    E.db.movers.LossControlMover = 'BOTTOM,UIParent,BOTTOM,0,671'
    E.db.movers.LootFrameMover = 'TOP,UIParent,TOP,0,-218'
    E.db.movers.MawBuffsBelowMinimapMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-335'
    E.db.movers.MicrobarMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-460,4"
    E.db.movers.MinimapButtonAnchor = 'TOPRIGHT,ElvUIParent,TOPRIGHT,0,-203'
    E.db.movers.MinimapMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-4'
    E.db.movers.ObjectiveFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-32,-345'
    E.db.movers.OzCooldownsMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-271,-453'
    E.db.movers.QuestWatchFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-91,-373"
    E.db.movers.RightChatMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
    E.db.movers.SquareMinimapButtonBarMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-239"
    E.db.movers.TopCenterContainerMover = 'TOP,ElvUIParent,TOP,0,-62'
    E.db.movers.RaidMarkerBarAnchor = 'TOP,UIParent,TOP,0,-4'
    E.db.movers.TooltipMover = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,246"
    E.db.movers.TorghastBuffsMover = 'TOPLEFT,UIParent,TOPLEFT,4,-4'
    E.db.movers.TorghastChoiceToggle = 'TOPLEFT,UIParent,TOPLEFT,285,-4'
    E.db.movers.TotemBarMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,452'
    E.db.movers.TotemTrackerMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,662,4'
    E.db.movers.PrivateAurasMover = E.Retail and 'TOPRIGHT,ElvUIParent,TOPRIGHT,-256,-216' or 'TOPRIGHT,ElvUIParent,TOPRIGHT,-238,-216'
    E.db.movers.PetExperienceBarMover = 'TOP,ElvUIParent,TOP,0,-30'
    E.db.movers.ZoneAbility = 'TOP,ElvUIParent,TOP,199,-694'
    E.db.movers.VehicleLeaveButton = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,480,137'
    E.db.movers.VehicleSeatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,480,4'
    E.db.movers.ElvAB_1 = 'BOTTOM,ElvUIParent,BOTTOM,-210.731707,4.000000'
    E.db.movers.ElvAB_10 = 'TOPLEFT,ElvUIParent,TOPLEFT,82,-414'
    E.db.movers.ElvAB_2 = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,316'
    E.db.movers.ElvAB_3 = 'BOTTOM,ElvUIParent,BOTTOM,210.731707,4.000000'
    E.db.movers.ElvAB_4 = 'BOTTOM,ElvUIParent,BOTTOM,-210.731707,39.121951'
    E.db.movers.ElvAB_5 = 'BOTTOM,ElvUIParent,BOTTOM,210.731707,39.121951'
    E.db.movers.ElvAB_7 = 'TOPLEFT,UIParent,TOPLEFT,82,-507'
    E.db.movers.ElvAB_8 = 'TOPLEFT,ElvUIParent,TOPLEFT,82,-476'
    E.db.movers.ElvAB_9 = 'TOPLEFT,ElvUIParent,TOPLEFT,82,-445'
    E.db.movers.VOICECHAT = 'TOPLEFT,UIParent,TOPLEFT,412,-81'

    if layout == 'DPS/Tank' then
      -- Individual Units
      --E.db.movers.ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-284,390"
      E.db.movers.ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-286,399"
      --E.db.movers.ElvUF_PetMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,731,390"
      E.db.movers.ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-361,324"
      --E.db.movers.ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,284,390"
      E.db.movers.ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,285,399"
      --E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-735,390"
      E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-763,399"
      --E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-500,390"
      E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-540,401"

      -- Group Elements
      --E.db.movers.ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,644,-563"
      E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,644,-560'
      E.db.movers.ElvUF_Raid1Mover = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,289"
      E.db.movers.ElvUF_Raid2Mover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,289"
      E.db.movers.ElvUF_Raid3Mover = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,289"
      E.db.movers.ElvUF_RaidpetMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,570'
      --E.db.movers.ArenaHeaderMover = "TOPRIGHT,UIParent,TOPRIGHT,-636,-519"
      E.db.movers.ArenaHeaderMover = "TOPRIGHT,UIParent,TOPRIGHT,-540,-509"
      --E.db.movers.BossHeaderMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-636,-320"
      E.db.movers.BossHeaderMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-540,-509"

      -- Castbars:
      E.db.movers.ElvUF_PlayerCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,-1,308'
      E.db.movers.ElvUF_PetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,0,197'
      E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,300,372'
      E.db.movers.ElvUF_FocusCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-620,372'

      E.db.movers.ElvAB_6 = 'BOTTOM,ElvUIParent,BOTTOM,0.000000,74.243902'
      E.db.movers.ShiftAB = 'BOTTOM,ElvUIParent,BOTTOM,0.000000,144.487805'
      E.db.movers.PetAB = 'BOTTOM,ElvUIParent,BOTTOM,0.000000,109.365854'

    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      -- Individual Units
      E.db.movers.ElvUF_PlayerMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,707,364"
      E.db.movers.ElvUF_PetMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,707,292"
      E.db.movers.ElvUF_TargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-708,364"
      E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-601,364"
      E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-384,364"

      -- Group Elements
      E.db.movers.ElvUF_Raid1Mover = E.Retail and 'BOTTOM,ElvUIParent,BOTTOM,0,109' or 'BOTTOM,ElvUIParent,BOTTOM,0,277'
      E.db.movers.ElvUF_Raid2Mover = E.Retail and 'BOTTOM,UIParent,BOTTOM,0,87' or 'BOTTOM,ElvUIParent,BOTTOM,0,85'
      E.db.movers.ElvUF_Raid3Mover = E.Retail and 'BOTTOM,ElvUIParent,BOTTOM,0,77' or 'BOTTOM,ElvUIParent,BOTTOM,0,85'
      E.db.movers.ElvUF_RaidpetMover = E.Cata and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-708,85' or 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-708,109'
      E.db.movers.ArenaHeaderMover = "TOPRIGHT,UIParent,TOPRIGHT,-540,-509"
      E.db.movers.BossHeaderMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-540,-509"

      -- Castbars:
      E.db.movers.ElvUF_FocusCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-470,375'
      E.db.movers.ElvUF_PetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,0,197'
      E.db.movers.ElvUF_PlayerCastbarMover = E.Retail and 'BOTTOM,UIParent,BOTTOM,0,406' or 'BOTTOM,ElvUIParent,BOTTOM,0,84'
      E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-698,372'

      E.db.movers.ElvAB_6 = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,314'
      E.db.movers.ShiftAB = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,384"
      -- Other Elements
      E.db.movers.PetAB = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,349"
    end

    if layout == 'Healer-H' then
      E.db.movers.ElvUF_PartyMover = 'BOTTOM,ElvUIParent,BOTTOM,0,341'
    elseif layout == 'Healer-V' then
      E.db.movers.ElvUF_PartyMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,699,544'
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.movers.AlertFrameMover = 'TOP,UIParent,TOP,0,-354'
    E.db.movers.AzeriteBarMover = 'TOP,ElvUIParent,TOP,-311,-371'
    E.db.movers.BNETMover = 'TOPLEFT,UIParent,TOPLEFT,496,-4'
    E.db.movers.BagsMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-763,4'
    E.db.movers.BelowMinimapContainerMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-246,-209'
    E.db.movers.BossButton = 'TOP,ElvUIParent,TOP,-153,-514'
    E.db.movers.BuffsMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-188,-4"
    E.db.movers.ClassBarMover = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,4,491'
    E.db.movers.DTPanelCustomPanel_LeftMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,4'
    E.db.movers.DTPanelCustomPanel_RightMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,4'
    E.db.movers.DebuffsMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-188,-150"
    E.db.movers.DurabilityFrameMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-7,430'
    E.db.movers.ElvUIBagMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
    E.db.movers.ElvUIBankMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,237"
    E.db.movers.ExperienceBarMover = 'TOP,UIParent,TOP,0,-4'
    E.db.movers.GMMover = 'TOPLEFT,UIParent,TOPLEFT,284,-4'
    E.db.movers.HonorBarMover = 'TOPLEFT,ElvUIParent,TOPLEFT,528,-338'
    E.db.movers.LeftChatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,29'
    E.db.movers.LootFrameMover = 'TOP,UIParent,TOP,0,-218'
    E.db.movers.LossControlMover = 'TOP,UIParent,TOP,0,-490'
    E.db.movers.MawBuffsBelowMinimapMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-335'
    E.db.movers.MicrobarMover = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-373,4"
    E.db.movers.MinimapButtonAnchor = 'TOPRIGHT,ElvUIParent,TOPRIGHT,0,-203'
    E.db.movers.MinimapMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-4'
    E.db.movers.ObjectiveFrameMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-34,-306'
    E.db.movers.OzCooldownsMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-271,-453'
    E.db.movers.PrivateAurasMover = 'TOPRIGHT,ElvUIParent,TOPRIGHT,-210,-208'
    E.db.movers.QuestWatchFrameMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-256'
    E.db.movers.RaidMarkerBarAnchor = 'TOP,UIParent,TOP,0,-4'
    E.db.movers.RightChatMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,29'
    E.db.movers.SquareMinimapButtonBarMover = 'TOPRIGHT,UIParent,TOPRIGHT,-4,-188'
    E.db.movers.TooltipMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,180"
    E.db.movers.TopCenterContainerMover = 'TOP,ElvUIParent,TOP,0,-62'
    E.db.movers.TorghastBuffsMover = 'TOPLEFT,UIParent,TOPLEFT,4,-4'
    E.db.movers.TorghastChoiceToggle = 'TOPLEFT,UIParent,TOPLEFT,285,-4'
    E.db.movers.TotemBarMover = 'BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,428'
    E.db.movers.TotemTrackerMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,404,4'
    E.db.movers.VOICECHAT = 'TOPLEFT,ElvUIParent,TOPLEFT,284,-82'
    E.db.movers.VehicleLeaveButton = 'BOTTOMLEFT,UIParent,BOTTOMLEFT,404,134'
    E.db.movers.VehicleSeatMover = 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,404,4'
    E.db.movers.ZoneAbility = 'BOTTOM,ElvUIParent,BOTTOM,153,514'
    E.db.movers.PetExperienceBarMover = 'TOP,ElvUIParent,TOP,0,-30'
    E.db.movers.ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,-177,4"
    E.db.movers.ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,186,96"
    E.db.movers.ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,177,4"
    E.db.movers.ElvAB_4 = "BOTTOM,ElvUIParent,BOTTOM,-177,33"
    E.db.movers.ElvAB_5 = "BOTTOM,ElvUIParent,BOTTOM,177,33"
    E.db.movers.ElvAB_7 = "TOPLEFT,UIParent,TOPLEFT,82,-507"
    E.db.movers.ElvAB_8 = "TOPLEFT,ElvUIParent,TOPLEFT,82,-476"
    E.db.movers.ElvAB_9 = "TOPLEFT,ElvUIParent,TOPLEFT,82,-445"
    E.db.movers.ElvAB_10 = "TOPLEFT,ElvUIParent,TOPLEFT,82,-414"
    E.db.movers.VOICECHAT = 'TOPLEFT,ElvUIParent,TOPLEFT,289,-81'
    E.db.movers.ArenaHeaderMover = E.Retail and 'TOPRIGHT,UIParent,TOPRIGHT,-447,-344' or "TOPRIGHT,UIParent,TOPRIGHT,-378,-344"
    E.db.movers.BossHeaderMover = E.Retail and 'TOPRIGHT,UIParent,TOPRIGHT,-447,-209' or "TOPRIGHT,UIParent,TOPRIGHT,-378,-344"


    if layout == 'DPS/Tank' then
      -- Individual Elements:
      --E.db.movers.ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-267,280"
      E.db.movers.ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-253,290"
      --E.db.movers.ElvUF_PetMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,447,280"
      E.db.movers.ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-316,225"
      --E.db.movers.ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,267,280"
      E.db.movers.ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,252,292"
      --E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-447,280"
      E.db.movers.ElvUF_TargetTargetMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-518,292"
      --E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-256,280"
      E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-317,292"

      -- Group Elements:
      E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,418,-339'
      E.db.movers.ElvUF_Raid1Mover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,235"
      E.db.movers.ElvUF_Raid2Mover = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,237"
      E.db.movers.ElvUF_Raid3Mover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,237"
      E.db.movers.ElvUF_RaidpetMover = 'TOPLEFT,ElvUIParent,TOPLEFT,4,-403'

      -- Castbars:
      E.db.movers.ElvUF_PlayerCastbarMover = E.Retail and 'BOTTOM,ElvUIParent,BOTTOM,0,203' or 'BOTTOM,ElvUIParent,BOTTOM,0,214'

      E.db.movers.ElvUF_PetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,0,197'
      E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,285,284'
      E.db.movers.ElvUF_FocusCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-369,284'

      E.db.movers.ElvAB_6 = "BOTTOM,ElvUIParent,BOTTOM,0,62"

      -- Special Elements
      E.db.movers.PetAB = "BOTTOM,UIParent,BOTTOM,0,122"
      E.db.movers.ShiftAB = "BOTTOM,UIParent,BOTTOM,0,91"
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      -- Individual Elements:
      E.db.movers.ElvUF_PlayerMover = E.Retail and 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,478,280' or "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,508,280"
      E.db.movers.ElvUF_PetMover = E.Retail and 'BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,478,190' or "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,508,215"
      E.db.movers.ElvUF_TargetMover = E.Retail and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-477,280' or "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-508,282"
      E.db.movers.ElvUF_TargetTargetMover = E.Retail and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-350,280' or "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-421,282"
      E.db.movers.ElvUF_FocusMover = E.Retail and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-289,226' or "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-239,282"

      -- Group Elements:
      E.db.movers.ElvUF_Raid1Mover = E.Retail and 'BOTTOM,ElvUIParent,BOTTOM,0,87' or 'BOTTOM,UIParent,BOTTOM,0,216'
      E.db.movers.ElvUF_Raid2Mover = E.Retail and 'BOTTOM,UIParent,BOTTOM,0,89' or 'BOTTOM,ElvUIParent,BOTTOM, 0,69'
      E.db.movers.ElvUF_Raid3Mover = (E.Retail and 'BOTTOM,UIParent,BOTTOM,0,75') or ((E.Cata or E.Mists) and 'BOTTOM,UIParent,BOTTOM,0,69') or 'BOTTOM,ElvUIParent,BOTTOM,0,66'
      E.db.movers.ElvUF_RaidpetMover = (E.Retail and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-505,87')
        or ((E.Cata or E.Mists) and 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-505,69')
        or 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-505,66'

      -- Castbars:
      E.db.movers.ElvUF_PlayerCastbarMover = E.Retail and 'BOTTOM,ElvUIParent,BOTTOM,0,323' or 'BOTTOM,ElvUIParent,BOTTOM,0,76'
      E.db.movers.ElvUF_PetCastbarMover = 'BOTTOM,ElvUIParent,BOTTOM,0,197'
      E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-477,284'
      E.db.movers.ElvUF_FocusCastbarMover = 'BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-288,284'

      -- Special Elements:
      E.db.movers.ElvAB_6 = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,237"

      E.db.movers.PetAB = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,307"
      E.db.movers.ShiftAB = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,271"
    end

    if layout == 'Healer-H' then
      E.db.movers.ElvUF_PartyMover = 'BOTTOM,UIParent,BOTTOM,0,260'
    elseif layout == 'Healer-V' then
      E.db.movers.ElvUF_PartyMover = 'TOPLEFT,ElvUIParent,TOPLEFT,478,-361'
    end
  end
end

db.general = function()
  E.db.general.tagUpdateRate = 0.5

  E.db.general.guildBank = E.db.general.guildBank or {}
  E.db.general.guildBank.countFont = Private.Font
  E.db.general.guildBank.countFontOutline = 'OUTLINE'
  E.db.general.guildBank.itemLevelFont = Private.Font
  E.db.general.guildBank.itemLevelFontOutline = 'OUTLINE'

  E.db.general.afk = false
  E.db.general.autoAcceptInvite = true
  E.db.general.autoRepair = 'PLAYER'
  E.db.general.bottomPanel = false
  E.db.general.font = Private.Font

  E.db.general.lootRoll.nameFont = Private.Font
  E.db.general.lootRoll.statusBarTexture = Private.GetProfileTexture()

  E.db.general.minimap.clusterBackdrop = false
  E.db.general.minimap.locationFont = Private.Font
  E.db.general.minimap.timeFont = Private.Font
  E.db.general.minimap.icons = E.db.general.minimap.icons or {}
  E.db.general.minimap.icons.mail = E.db.general.minimap.icons.mail or {}
  E.db.general.minimap.icons.mail.position = 'BOTTOM'
  E.db.general.minimap.icons.mail.position = 'BOTTOM'
  E.db.general.minimap.icons.mail.texture = 'Mail1'
  E.db.general.minimap.icons.mail.xOffset = 0
  E.db.general.minimap.icons.mail.yOffset = 15

  E.db.general.valuecolor.b = 0
  E.db.general.valuecolor.g = 0.42352941176471
  E.db.general.valuecolor.r = 1

  E.db.general.backdropfadecolor = E.db.general.backdropfadecolor or {}
  E.db.general.backdropfadecolor.a = 0.8

  E.db.general.totems = E.db.general.totems or {}
  E.db.general.totems.font = Private.Font
  E.db.general.totems.mouseover = true
  E.db.general.totems.spacing = 1
  E.db.general.totems.growthDirection = 'HORIZONTAL'
  E.db.general.totems.spacing = 1

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.general.fontSize = 14
    E.db.general.lootRoll.nameFontSize = 14
    E.db.general.minimap.size = 226
    E.db.general.minimap.timeFontSize = 14
    E.db.general.totems.fontSize = 16
    E.db.general.guildBank.countFontSize = 14
    E.db.general.guildBank.itemLevelFontSize = 14
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.general.fontSize = 13
    E.db.general.lootRoll.nameFontSize = 12
    E.db.general.minimap.size = 178
    E.db.general.minimap.timeFontSize = 12
    E.db.general.totems.fontSize = 14
    E.db.general.guildBank.countFontSize = 13
    E.db.general.guildBank.itemLevelFontSize = 13
  end
end

db.auras = function()
  E.db.auras.buffs.countFont = Private.Font
  E.db.auras.buffs.countFontOutline = 'OUTLINE'
  E.db.auras.buffs.timeFont = Private.Font
  E.db.auras.buffs.timeFontOutline = 'OUTLINE'
  E.db.auras.debuffs.countFont = Private.Font
  E.db.auras.debuffs.countFontOutline = 'OUTLINE'
  E.db.auras.debuffs.timeFont = Private.Font
  E.db.auras.debuffs.timeFontOutline = 'OUTLINE'

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.auras.buffs.countFontSize = 16
    E.db.auras.buffs.horizontalSpacing = 3
    E.db.auras.buffs.size = 36
    E.db.auras.buffs.timeFontSize = 16
    E.db.auras.buffs.wrapAfter = 16
    E.db.auras.debuffs.countFontSize = 16
    E.db.auras.debuffs.horizontalSpacing = 3
    E.db.auras.debuffs.size = 36
    E.db.auras.debuffs.timeFontSize = 16
    E.db.auras.debuffs.wrapAfter = 14
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.auras.buffs.countFontSize = 14
    E.db.auras.buffs.horizontalSpacing = 3
    E.db.auras.buffs.size = 34
    E.db.auras.buffs.timeFontSize = 14
    E.db.auras.buffs.wrapAfter = 14
    E.db.auras.debuffs.countFontSize = 14
    E.db.auras.debuffs.horizontalSpacing = 3
    E.db.auras.debuffs.size = 34
    E.db.auras.debuffs.timeFontSize = 14
    E.db.auras.debuffs.wrapAfter = 14
  end
end

db.cooldowns = function()
  E.db['cooldown'] = E.db['cooldown'] or {}
  E.db['cooldown']['actionbar'] = E.db['cooldown']['actionbar'] or {}
  E.db['cooldown']['actionbar']['font'] = 'Merfin Font 1'

  E.db['cooldown']['aurabars'] = E.db['cooldown']['aurabars'] or {}
  E.db['cooldown']['aurabars']['font'] = 'Merfin Font 1'

  E.db['cooldown']['auraindicator'] = E.db['cooldown']['auraindicator'] or {}
  E.db['cooldown']['auraindicator']['font'] = 'Merfin Font 1'

  E.db['cooldown']['auras'] = E.db['cooldown']['auras'] or {}
  E.db['cooldown']['auras']['font'] = 'Merfin Font 1'

  E.db['cooldown']['bags'] = E.db['cooldown']['bags'] or {}
  E.db['cooldown']['bags']['font'] = 'Merfin Font 1'

  E.db['cooldown']['bossbutton'] = E.db['cooldown']['bossbutton'] or {}
  E.db['cooldown']['bossbutton']['font'] = 'Merfin Font 1'

  E.db['cooldown']['global'] = E.db['cooldown']['global'] or {}
  E.db['cooldown']['global']['font'] = 'Merfin Font 1'

  E.db['cooldown']['nameplates'] = E.db['cooldown']['nameplates'] or {}
  E.db['cooldown']['nameplates']['font'] = 'Merfin Font 1'

  E.db['cooldown']['totemtracker'] = E.db['cooldown']['totemtracker'] or {}
  E.db['cooldown']['totemtracker']['font'] = 'Merfin Font 1'

  E.db['cooldown']['unitframe'] = E.db['cooldown']['unitframe'] or {}
  E.db['cooldown']['unitframe']['font'] = 'Merfin Font 1'

  E.db['cooldown']['zonebutton'] = E.db['cooldown']['zonebutton'] or {}
  E.db['cooldown']['zonebutton']['font'] = 'Merfin Font 1'

  local fontSize = 16
  if Private.GetProfileResolution() == 'QUAD_HD' then
    fontSize = 16
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    fontSize = 15
  end

  E.db['cooldown']['global']['fontSize'] = 18
  E.db['cooldown']['actionbar']['fontSize'] = 17
  E.db['cooldown']['bags']['fontSize'] = fontSize
  E.db['cooldown']['nameplates']['fontSize'] = fontSize
  E.db['cooldown']['auras']['fontSize'] = fontSize
  E.db['cooldown']['unitframe']['fontSize'] = 15
  E.db['cooldown']['aurabars']['fontSize'] = fontSize
  E.db['cooldown']['auraindicator']['fontSize'] = 10
  E.db['cooldown']['totemtracker']['fontSize'] = fontSize
  E.db['cooldown']['bossbutton']['fontSize'] = fontSize
  E.db['cooldown']['zonebutton']['fontSize'] = fontSize
end

db.bags = function()
  E.db.bags.autoToggle.trade = true
  E.db.bags.bagBar.growthDirection = 'HORIZONTAL'
  E.db.bags.bagBar.justBackpack = true
  E.db.bags.bagBar.mouseover = true
  E.db.bags.bagBar.spacing = -1
  E.db.bags.bagButtonSpacing = 0
  E.db.bags.clearSearchOnClose = true
  E.db.bags.countFont = Private.Font
  E.db.bags.countFontOutline = 'OUTLINE'
  E.db.bags.countxOffset = 1
  E.db.bags.countyOffset = 1
  E.db.bags.itemInfoFont = Private.Font
  E.db.bags.itemInfoFontOutline = 'OUTLINE'
  E.db.bags.itemLevelFontOutline = 'OUTLINE'
  E.db.bags.moneyCoins = false
  E.db.bags.moneyFormat = 'CONDENSED'
  E.db.bags.split.bagSpacing = 2
  E.db.bags.itemLevelxOffset = 1
  E.db.bags.itemLevelyOffset = 1
  E.db.bags.itemLevelFont = Private.Font

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.bags.bagBar.size = 40
    E.db.bags.bagSize = 43
    E.db.bags.bagWidth = 444
    E.db.bags.bankSize = 42
    E.db.bags.bankWidth = 464
    E.db.bags.countFontSize = 16
    E.db.bags.itemInfoFontSize = 16
    E.db.bags.itemLevelFontSize = 16
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.bags.bagBar.size = 40
    E.db.bags.bagSize = 38
    E.db.bags.bagWidth = 400
    E.db.bags.bankSize = 38
    E.db.bags.bankWidth = 464
    E.db.bags.countFontSize = 14
    E.db.bags.itemInfoFontSize = 14
    E.db.bags.itemLevelFontSize = 14
  end

  if E.Mists then
    E.private.bags.enable = false
    BAGANATOR_CONFIG = BAGANATOR_CONFIG or {}
    BAGANATOR_CONFIG.Profiles = BAGANATOR_CONFIG.Profiles or {}
    BAGANATOR_CONFIG.Profiles.DEFAULT = BAGANATOR_CONFIG.Profiles.DEFAULT or {}

    local baganatorDB = BAGANATOR_CONFIG.Profiles.DEFAULT

    baganatorDB.icon_text_font_size = 13
    baganatorDB.bag_icon_size = 40
    baganatorDB.bag_view_type = 'category'
    baganatorDB.icon_text_quality_colors = true
    baganatorDB.bag_view_position = {
      'BOTTOMRIGHT',
      -4.000244140625,
      28.00033760070801,
    }
  end
end

db.chat = function()
  E.db.chat.editBoxPosition = 'ABOVE_CHAT_INSIDE'
  E.db.chat.font = Private.Font
  E.db.chat.panelBackdrop = 'LEFT'
  E.db.chat.panelBackdropNameLeft = ''
  E.db.chat.panelColor.a = 0.55000001192093
  E.db.chat.panelColor.b = 0.05882353335619
  E.db.chat.panelColor.g = 0.05882353335619
  E.db.chat.panelColor.r = 0.05882353335619
  E.db.chat.panelTabBackdrop = false
  E.db.chat.panelTabTransparency = true
  E.db.chat.separateSizes = true
  E.db.chat.showHistory.CHANNEL = false
  E.db.chat.showHistory.EMOTE = false
  E.db.chat.showHistory.INSTANCE = false
  E.db.chat.tabFont = Private.Font
  E.db.chat.tabSelector = 'ARROW3'
  E.db.chat.timeStampFormat = '%H:%M:%S '

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.chat.panelHeight = 250
    E.db.chat.panelWidth = 451
    E.db.chat.panelHeightRight = 270
    E.db.chat.panelWidthRight = 293
    E.db.chat.tabFontSize = 15
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.chat.panelHeight = 200
    E.db.chat.panelWidth = 361
    E.db.chat.panelHeightRight = 270
    E.db.chat.panelWidthRight = 200
    E.db.chat.tabFontSize = 13
  end
end

db.databars = function()
  E.db.databars.azerite.enable = false
  E.db.databars.experience.enable = false
  E.db.databars.experience.font = Private.Font
  E.db.databars.experience.fontOutline = 'OUTLINE'
  E.db.databars.experience.showLevel = true
  E.db.databars.experience.showQuestXP = false
  E.db.databars.experience.textFormat = 'CURMAX'
  E.db.databars.honor.enable = false
  E.db.databars.petExperience.enable = false
  E.db.databars.petExperience.font = Private.Font
  E.db.databars.petExperience.textFormat = 'CURMAX'
  E.db.databars.petExperience.hideAtMaxLevel = true
  E.db.databars.threat.enable = false
  E.db.databars.threat.font = Private.Font

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.databars.experience.fontSize = 16
    E.db.databars.experience.height = 30
    E.db.databars.experience.width = 450
    E.db.databars.petExperience.fontSize = 16
    E.db.databars.petExperience.height = 25
    E.db.databars.petExperience.width = 350
    E.db.databars.reputation.fontSize = 16
    E.db.databars.threat.fontSize = 16
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.databars.experience.fontSize = 14
    E.db.databars.experience.height = 27
    E.db.databars.experience.width = 396
    E.db.databars.petExperience.fontSize = 14
    E.db.databars.petExperience.height = 20
    E.db.databars.petExperience.width = 300
    E.db.databars.reputation.fontSize = 14
    E.db.databars.threat.fontSize = 14
  end
end

db.datatext = function()
  E.db.datatexts.panels.CustomPanel_Left = E.db.datatexts.panels.CustomPanel_Left or {}
  E.db.datatexts.panels.CustomPanel_Right = E.db.datatexts.panels.CustomPanel_Right or {}
  E.db.datatexts.panels.LeftChatDataPanel = E.db.datatexts.panels.LeftChatDataPanel or {}

  E.db.datatexts.font = Private.GetProfileFont('bold')
  E.db.datatexts.panels.CustomPanel_Left[1] = 'System'
  E.db.datatexts.panels.CustomPanel_Left[2] = 'Time'
  E.db.datatexts.panels.CustomPanel_Left.battleground = false
  E.db.datatexts.panels.CustomPanel_Left.enable = true
  E.db.datatexts.panels.CustomPanel_Right[1] = 'Durability'
  E.db.datatexts.panels.CustomPanel_Right[2] = 'Gold'
  E.db.datatexts.panels.CustomPanel_Right.battleground = false
  E.db.datatexts.panels.CustomPanel_Right.enable = true
  E.db.datatexts.panels.LeftChatDataPanel[2] = ''
  E.db.datatexts.panels.LeftChatDataPanel[3] = 'Durability'
  E.db.datatexts.panels.LeftChatDataPanel.enable = false
  E.db.datatexts.panels.MinimapPanel[1] = 'Time'
  E.db.datatexts.panels.MinimapPanel[2] = 'Time'
  E.db.datatexts.panels.MinimapPanel.enable = false
  E.db.datatexts.panels.MinimapPanel.numPoints = 1
  E.db.datatexts.panels.RightChatDataPanel.enable = false

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.datatexts.fontSize = 14
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.datatexts.fontSize = 12
  end
end

db.tooltip = function()
  E.db.tooltip.font = Private.Font
  E.db.tooltip.fontOutline = 'OUTLINE'
  E.db.tooltip.headerFont = Private.Font
  E.db.tooltip.headerFontOutline = 'OUTLINE'
  E.db.tooltip.healthBar.font = Private.Font
  E.db.tooltip.healthBar.text = false
  E.db.tooltip.cursorAnchor = false
  E.db.tooltip.healthBar.height = 7
  E.db.tooltip.healthBar.statusPosition = 'DISABLED'

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.tooltip.headerFontSize = 13
    E.db.tooltip.healthBar.fontSize = 13
    E.db.tooltip.smallTextFontSize = 13
    E.db.tooltip.textFontSize = 13
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.tooltip.headerFontSize = 11
    E.db.tooltip.healthBar.fontSize = 11
    E.db.tooltip.smallTextFontSize = 11
    E.db.tooltip.textFontSize = 11
  end
end

db.actionbars = function(force)
  if Private.GetBlacklist('actionBars') and not force then
    return
  end

  E.db.cooldown = E.db.cooldown or {}
  E.db.cooldown.targetaura = E.db.cooldown.targetaura or {}
  E.db.cooldown.targetaura.enable = false

  E.db.cooldown.actionbar = E.db.cooldown.actionbar or {}
  E.db.cooldown.actionbar.fontSize = 17
  E.db.actionbar.desaturateOnCooldown = true

  E.db.actionbar.bar1 = E.db.actionbar.bar1 or {}
  E.db.actionbar.bar1.paging = E.db.actionbar.bar1.paging or {}
  if not E.TBC then
    E.db.actionbar.bar1.paging.WARLOCK = ''
  end
  E.db.actionbar.bar1.visibility = '[petbattle] hide; show'

  E.db.actionbar.flashAnimation = true
  E.db.actionbar.font = Private.Font
  E.db.actionbar.fontOutline = 'OUTLINE'
  E.db.actionbar.macroTextPosition = 'BOTTOMLEFT'
  E.db.actionbar.noRangeColor.b = 0.10196078431373
  E.db.actionbar.noRangeColor.g = 0.10196078431373

  E.db.actionbar.barPet.showGrid = false
  E.db.actionbar.barPet.mouseover = true
  E.db.actionbar.barPet.alpha = 0.85
  E.db.actionbar.barPet.backdrop = false
  E.db.actionbar.barPet.buttonSpacing = -1
  E.db.actionbar.barPet.buttonsPerRow = 10
  E.db.actionbar.barPet.countFont = Private.Font
  E.db.actionbar.barPet.countFontOutline = 'OUTLINE'
  E.db.actionbar.barPet.hotkeyFont = Private.Font
  E.db.actionbar.barPet.hotkeyFontOutline = 'OUTLINE'
  E.db.actionbar.barPet.hotkeyTextXOffset = 1
  E.db.actionbar.barPet.mouseover = true
  E.db.actionbar.barPet.point = 'TOPLEFT'

  E.db.actionbar.extraActionButton.clean = true
  E.db.actionbar.extraActionButton.hotkeyFont = Private.Font
  E.db.actionbar.extraActionButton.hotkeyFontOutline = 'OUTLINE'

  E.db.actionbar.microbar.alpha = 0.85
  E.db.actionbar.microbar.backdropSpacing = 0
  E.db.actionbar.microbar.buttonSpacing = 1
  E.db.actionbar.microbar.enabled = true
  E.db.actionbar.microbar.mouseover = true
  E.db.actionbar.microbar.useIcons = false

  E.db.actionbar.stanceBar.alpha = 0.85
  E.db.actionbar.stanceBar.buttonSpacing = -1
  E.db.actionbar.stanceBar.hotkeyFont = Private.Font
  E.db.actionbar.stanceBar.hotkeyFontOutline = 'OUTLINE'
  E.db.actionbar.stanceBar.mouseover = true
  E.db.actionbar.stanceBar.style = 'classic'

  E.db.actionbar.bar1.enabled = true
  E.db.actionbar.bar2.enabled = false
  E.db.actionbar.bar3.enabled = true
  E.db.actionbar.bar4.enabled = true
  E.db.actionbar.bar5.enabled = true
  E.db.actionbar.bar6.enabled = true

  local showMouseover, showGrid = Private.GetActionBarsSettings()
  for i = 1, 9 do
    E.db.actionbar['bar' .. i].buttons = 12
    E.db.actionbar['bar' .. i].buttonsPerRow = 12
    E.db.actionbar['bar' .. i].mouseover = showMouseover
    E.db.actionbar['bar' .. i].showGrid = showGrid
    E.db.actionbar['bar' .. i].backdrop = false
    E.db.actionbar['bar' .. i].alpha = 0.85
    E.db.actionbar['bar' .. i].buttonSpacing = -1
    E.db.actionbar['bar' .. i].countFont = Private.Font
    E.db.actionbar['bar' .. i].countFontOutline = 'OUTLINE'
    E.db.actionbar['bar' .. i].hotkeyFont = Private.Font
    E.db.actionbar['bar' .. i].hotkeyFontOutline = 'OUTLINE'
    E.db.actionbar['bar' .. i].macroFont = Private.Font
    E.db.actionbar['bar' .. i].macroFontOutline = 'OUTLINE'
    E.db.actionbar['bar' .. i].macroTextPosition = 'BOTTOM'
    E.db.actionbar['bar' .. i].macroTextYOffset = 2
    E.db.actionbar['bar' .. i].macrotext = true
    E.db.actionbar['bar' .. i].visibility = ''
  end

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.actionbar.fontSize = 12
    E.db.actionbar.extraActionButton.hotkeyFontSize = 14

    for i = 1, 9 do
      E.db.actionbar['bar' .. i].buttonSize = 36
      E.db.actionbar['bar' .. i].hotkeyFontSize = 14
      E.db.actionbar['bar' .. i].countFontSize = 14
      E.db.actionbar['bar' .. i].macroFontSize = 13
    end

    E.db.actionbar.vehicleExitButton = E.db.actionbar.vehicleExitButton or {}
    E.db.actionbar.vehicleExitButton.buttonSize = 36
    E.db.actionbar.vehicleExitButton.hotkeyFontSize = 14
    E.db.actionbar.stanceBar = E.db.actionbar.stanceBar or {}
    E.db.actionbar.stanceBar.buttonSize = 36
    E.db.actionbar.stanceBar.hotkeyFontSize = 14
    E.db.actionbar.microbar = E.db.actionbar.microbar or {}
    E.db.actionbar.microbar.buttonHeight = 22
    E.db.actionbar.microbar.buttonSize = 19
    E.db.actionbar.barPet = E.db.actionbar.barPet or {}
    E.db.actionbar.barPet.buttonSize = 36
    E.db.actionbar.barPet.countFontSize = 14
    E.db.actionbar.barPet.hotkeyFontSize = 14
    E.db.actionbar.totemBar = E.db.actionbar.totemBar or {}
    E.db.actionbar.totemBar.buttonSize = 36
    E.db.actionbar.totemBar.spacing = 1
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.actionbar.fontSize = 14
    E.db.actionbar.extraActionButton.hotkeyFontSize = 14

    for i = 1, 9 do
      E.db.actionbar['bar' .. i].buttonSize = 30
      E.db.actionbar['bar' .. i].hotkeyFontSize = 14
      E.db.actionbar['bar' .. i].countFontSize = 14
      E.db.actionbar['bar' .. i].macroFontSize = 12
    end

    E.db.actionbar.vehicleExitButton = E.db.actionbar.vehicleExitButton or {}
    E.db.actionbar.vehicleExitButton.buttonSize = 34
    E.db.actionbar.vehicleExitButton.hotkeyFontSize = 14
    E.db.actionbar.stanceBar = E.db.actionbar.stanceBar or {}
    E.db.actionbar.stanceBar.buttonSize = 32
    E.db.actionbar.stanceBar.hotkeyFontSize = 14
    E.db.actionbar.microbar = E.db.actionbar.microbar or {}
    E.db.actionbar.microbar.buttonHeight = 22
    E.db.actionbar.microbar.buttonSize = 19
    E.db.actionbar.barPet = E.db.actionbar.barPet or {}
    E.db.actionbar.barPet.buttonSize = 32
    E.db.actionbar.barPet.countFontSize = 14
    E.db.actionbar.barPet.hotkeyFontSize = 14
    E.db.actionbar.totemBar = E.db.actionbar.totemBar or {}
    E.db.actionbar.totemBar.buttonSize = 34
    E.db.actionbar.totemBar.spacing = 1
  end
end

db.unitframes = function(layout)
  E.db.unitframe.multiplier = 0.8

  -- Colors
  E.db.unitframe.colors.transparentHealth = false
  E.db.unitframe.colors.castColor.b = 0
  E.db.unitframe.colors.castColor.g = 0.67843137254902
  E.db.unitframe.colors.castColor.r = 1
  E.db.unitframe.colors.castNoInterrupt.b = 0.25098039215686
  E.db.unitframe.colors.castNoInterrupt.g = 0.25098039215686
  E.db.unitframe.colors.castNoInterrupt.r = 0.78039215686275
  E.db.unitframe.colors.castbar_backdrop.b = 0.10588235294118
  E.db.unitframe.colors.castbar_backdrop.g = 0.10588235294118
  E.db.unitframe.colors.castbar_backdrop.r = 0.2078431372549
  E.db.unitframe.colors.colorhealthbyvalue = false
  E.db.unitframe.colors.customcastbarbackdrop = true
  E.db.unitframe.colors.customhealthbackdrop = true
  E.db.unitframe.colors.debuffHighlight.blendMode = 'ALPHAKEY'
  E.db.unitframe.colors.frameGlow.mouseoverGlow.enable = false
  E.db.unitframe.colors.frameGlow.targetGlow.enable = false
  E.db.unitframe.colors.health.b = 0.17254901960784
  E.db.unitframe.colors.health.g = 0.17254901960784
  E.db.unitframe.colors.health.r = 0.1921568627451
  E.db.unitframe.colors.health_backdrop.b = not E.Cata and 0.98039221763611 or 0.12549019607843
  E.db.unitframe.colors.health_backdrop.g = not E.Cata and 0.98039221763611 or 0.12549019607843
  E.db.unitframe.colors.health_backdrop.r = not E.Cata and 0.98039221763611 or 0.14901960784314
  E.db.unitframe.colors.health_backdrop_dead.b = 0.46274509803922
  E.db.unitframe.colors.health_backdrop_dead.g = 0.46274509803922
  E.db.unitframe.colors.health_backdrop_dead.r = 0.51764705882353
  E.db.unitframe.colors.healthclass = true
  E.db.unitframe.colors.power.MANA.b = 1
  E.db.unitframe.colors.power.MANA.g = 0.86274509803922
  E.db.unitframe.colors.power.MANA.r = 0.019607843137255
  E.db.unitframe.colors.happiness[1].b = 0.24705883860588
  E.db.unitframe.colors.happiness[1].g = 0.24705883860588
  E.db.unitframe.colors.happiness[1].r = 0.55294120311737
  E.db.unitframe.colors.happiness[2].b = 0.27843138575554
  E.db.unitframe.colors.happiness[2].g = 0.50588238239288
  E.db.unitframe.colors.happiness[2].r = 0.52156865596771
  E.db.unitframe.colors.happiness[3].b = 0.21176472306252
  E.db.unitframe.colors.happiness[3].g = 0.36862745881081
  E.db.unitframe.colors.happiness[3].r = 0.21176472306252

  -- Cooldown
  if E.db.cooldown and E.db.cooldown.unitframe then
    E.db.cooldown.unitframe.font = Private.Font
    if Private.GetProfileResolution() == 'QUAD_HD' then
      E.db.cooldown.unitframe.fontSize = 13
    elseif Private.GetProfileResolution() == 'FULL_HD' then
      E.db.cooldown.unitframe.fontSize = 13
    end
  end
  if E.Classic or E.TBC then
    E.db.unitframe.maxAllowedGroups = false
  end
  E.db.unitframe.statusbar = Private.GetProfileTexture()
  E.db.unitframe.font = Private.Font
  E.db.unitframe.fontOutline = 'OUTLINE'
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.fontSize = 16
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.fontSize = 13
  end

  E.db.unitframe.units = E.db.unitframe.units or {}

  -- UF: Player
  E.db.unitframe.units.player.RestIcon.enable = false
  E.db.unitframe.units.player.aurabar.enable = false
  E.db.unitframe.units.player.buffs.anchorPoint = 'TOPRIGHT'
  E.db.unitframe.units.player.buffs.countFont = Private.Font
  E.db.unitframe.units.player.castbar.enable = E.Retail
  E.db.unitframe.units.player.castbar.customTextFont.enable = true
  E.db.unitframe.units.player.castbar.customTextFont.font = Private.Font
  E.db.unitframe.units.player.castbar.customTimeFont.enable = true
  E.db.unitframe.units.player.castbar.customTimeFont.font = Private.Font
  E.db.unitframe.units.player.castbar.format = 'CURRENTMAX'
  E.db.unitframe.units.player.castbar.spark = true
  E.db.unitframe.units.player.castbar.textColor.b = 1
  E.db.unitframe.units.player.castbar.textColor.g = 1
  E.db.unitframe.units.player.castbar.textColor.r = 0
  E.db.unitframe.units.player.classbar.enable = false
  E.db.unitframe.units.player.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.player.customTexts = E.db.unitframe.units.player.customTexts or {}
  E.db.unitframe.units.player.customTexts.UnitPower = E.db.unitframe.units.player.customTexts.UnitPower or {}
  E.db.unitframe.units.player.customTexts.UnitPower.attachTextTo = 'Power'
  E.db.unitframe.units.player.customTexts.UnitPower.enable = false
  E.db.unitframe.units.player.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.player.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.player.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.player.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  E.db.unitframe.units.player.customTexts.UnitPower.xOffset = 0
  E.db.unitframe.units.player.customTexts.UnitPower.yOffset = 0
  E.db.unitframe.units.player.customTexts.UnitHealth = E.db.unitframe.units.player.customTexts.UnitHealth or {}
  E.db.unitframe.units.player.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.player.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.player.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.player.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.player.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.player.customTexts.UnitHealth.text_format = '[health:current:shortvalue]'
  E.db.unitframe.units.player.customTexts.UnitHealth.xOffset = -2
  E.db.unitframe.units.player.customTexts.UnitHealth.yOffset = 0
  E.db.unitframe.units.player.customTexts.UnitName = E.db.unitframe.units.player.customTexts.UnitName or {}
  E.db.unitframe.units.player.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.player.customTexts.UnitName.enable = false
  E.db.unitframe.units.player.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.player.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.player.customTexts.UnitName.justifyH = 'LEFT'
  E.db.unitframe.units.player.customTexts.UnitName.text_format = '[name]'
  E.db.unitframe.units.player.customTexts.UnitName.xOffset = 5
  E.db.unitframe.units.player.customTexts.UnitName.yOffset = 20
  E.db.unitframe.units.player.debuffs.anchorPoint = 'TOPRIGHT'
  E.db.unitframe.units.player.debuffs.enable = false
  E.db.unitframe.units.player.healPrediction.enable = false
  E.db.unitframe.units.player.health.text_format = ''
  E.db.unitframe.units.player.partyIndicator.enable = false
  E.db.unitframe.units.player.power.EnergyManaRegen = true
  E.db.unitframe.units.player.power.detachFromFrame = true
  E.db.unitframe.units.player.power.enable = false
  E.db.unitframe.units.player.power.powerPrediction = true
  E.db.unitframe.units.player.power.text_format = ''
  E.db.unitframe.units.player.pvp.text_format = ''
  E.db.unitframe.units.player.raidRoleIcons.enable = false
  E.db.unitframe.units.player.threatStyle = 'NONE'
  E.db.unitframe.units.player.raidicon.attachTo = 'CENTER'
  E.db.unitframe.units.player.raidicon.attachToObject = 'Health'
  E.db.unitframe.units.player.raidicon.xOffset = -35
  E.db.unitframe.units.player.raidicon.yOffset = 17
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.player.castbar.displayTarget = false
  elseif layout == 'Healer-H' or layout == 'Healer-V' then
    E.db.unitframe.units.player.castbar.displayTarget = true
  end
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.player.CombatIcon.size = 23
    E.db.unitframe.units.player.castbar.customTextFont.fontSize = 15
    E.db.unitframe.units.player.castbar.customTimeFont.fontSize = 15
    E.db.unitframe.units.player.customTexts.UnitPower.size = 15
    E.db.unitframe.units.player.customTexts.UnitHealth.size = 16
    E.db.unitframe.units.player.customTexts.UnitName.size = 15
    E.db.unitframe.units.player.height = 42
    E.db.unitframe.units.player.power.height = 8
    E.db.unitframe.units.player.width = 250
    E.db.unitframe.units.player.raidicon.size = 25
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.player.castbar.height = 33
      E.db.unitframe.units.player.castbar.width = 307
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.player.castbar.height = 27
      E.db.unitframe.units.player.castbar.width = 619
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.player.CombatIcon.size = 23
    E.db.unitframe.units.player.castbar.customTextFont.fontSize = 13
    E.db.unitframe.units.player.castbar.customTimeFont.fontSize = 13
    E.db.unitframe.units.player.customTexts.UnitPower.size = 13
    E.db.unitframe.units.player.customTexts.UnitHealth.size = 14
    E.db.unitframe.units.player.customTexts.UnitName.size = 13
    E.db.unitframe.units.player.height = 35
    E.db.unitframe.units.player.power.height = 8
    E.db.unitframe.units.player.width = 205
    E.db.unitframe.units.player.raidicon.size = 19
    E.db.unitframe.units.player.raidicon.xOffset = 5
    E.db.unitframe.units.player.raidicon.yOffset = 0
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.player.castbar.height = 28
      E.db.unitframe.units.player.castbar.width = 307
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.player.castbar.height = 28
      E.db.unitframe.units.player.castbar.width = 497
    end
  end

  -- UF: Target
  E.db.unitframe.units.target.CombatIcon.anchorPoint = 'BOTTOMRIGHT'
  E.db.unitframe.units.target.aurabar.enable = false
  --E.db.unitframe.units.target.buffs.attachTo = "DEBUFFS"
  E.db.unitframe.units.target.auras = E.db.unitframe.units.target.auras or {}
  E.db.unitframe.units.target.auras.enable = true
  E.db.unitframe.units.target.buffs.keepSizeRatio = false
  E.db.unitframe.units.target.buffs.countFont = Private.Font
  E.db.unitframe.units.target.buffs.spacing = -1
  E.db.unitframe.units.target.buffs.priority = 'Blacklist,Personal,Friendly:nonPersonal,CastByNPC'
  E.db.unitframe.units.target.castbar.enable = false
  E.db.unitframe.units.target.castbar.customTextFont.enable = true
  E.db.unitframe.units.target.castbar.customTextFont.font = Private.Font
  E.db.unitframe.units.target.castbar.customTimeFont.enable = true
  E.db.unitframe.units.target.castbar.customTimeFont.font = Private.Font
  E.db.unitframe.units.target.castbar.spark = false
  E.db.unitframe.units.target.castbar.strataAndLevel.useCustomLevel = true
  E.db.unitframe.units.target.castbar.textColor.b = 1
  E.db.unitframe.units.target.castbar.textColor.g = 1
  E.db.unitframe.units.target.castbar.textColor.r = 1
  E.db.unitframe.units.target.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.target.customTexts = E.db.unitframe.units.target.customTexts or {}
  E.db.unitframe.units.target.customTexts.UnitPower = E.db.unitframe.units.target.customTexts.UnitPower or {}
  E.db.unitframe.units.target.customTexts.UnitPower.attachTextTo = 'Health'
  E.db.unitframe.units.target.customTexts.UnitPower.enable = true
  E.db.unitframe.units.target.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.target.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.target.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.target.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  --E.db.unitframe.units.target.customTexts.UnitPower.xOffset = -3
  --E.db.unitframe.units.target.customTexts.UnitPower.yOffset = 0
  E.db.unitframe.units.target.customTexts.UnitHealth = E.db.unitframe.units.target.customTexts.UnitHealth or {}
  E.db.unitframe.units.target.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.target.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.target.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.target.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.target.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.target.customTexts.UnitHealth.text_format = E.Retail and '[perhp]% | [health:current:shortvalue]' or '[health:percent] | [health:current:shortvalue]'
  --E.db.unitframe.units.target.customTexts.UnitHealth.xOffset = 3
  --E.db.unitframe.units.target.customTexts.UnitHealth.yOffset = -10
  E.db.unitframe.units.target.customTexts.UnitName = E.db.unitframe.units.target.customTexts.UnitName or {}
  E.db.unitframe.units.target.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.target.customTexts.UnitName.enable = true
  E.db.unitframe.units.target.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.target.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.target.customTexts.UnitName.justifyH = 'RIGHT'
  E.db.unitframe.units.target.customTexts.UnitName.text_format = '[name:long]'
  --E.db.unitframe.units.target.customTexts.UnitName.xOffset = 3
  --E.db.unitframe.units.target.customTexts.UnitName.yOffset = 10
  E.db.unitframe.units.target.debuffs.enable = E.Retail
  E.db.unitframe.units.target.debuffs.attachTo = 'FRAME'
  E.db.unitframe.units.target.debuffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.target.debuffs.spacing = -1
  E.db.unitframe.units.target.debuffs.priority = 'Blacklist,Personal,Friendly:RaidDebuffs,CCDebuffs,Friendly:Dispellable,Friendly:notCastByUnit,CastByNPC'
  E.db.unitframe.units.target.debuffs.perrow = 8
  E.db.unitframe.units.target.fader.enable = false
  E.db.unitframe.units.target.fader.range = false
  E.db.unitframe.units.target.healPrediction.enable = false
  E.db.unitframe.units.target.health.text_format = ''
  E.db.unitframe.units.target.name.text_format = ''
  E.db.unitframe.units.target.power.text_format = ''
  E.db.unitframe.units.target.raidRoleIcons.enable = false
  E.db.unitframe.units.target.raidicon.attachTo = 'CENTER'
  E.db.unitframe.units.target.raidicon.attachToObject = 'Health'
  E.db.unitframe.units.target.raidicon.yOffset = 0
  E.db.unitframe.units.target.auras = E.db.unitframe.units.target.auras or {}
  E.db.unitframe.units.target.auras.enable = false
  --E.db.unitframe.units.target.smartAuraPosition = "FLUID_BUFFS_ON_DEBUFFS"
  E.db.unitframe.units.target.threatStyle = 'NONE'
  E.db.unitframe.units.target.buffs.numrows = 3

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.target.width = 250
    E.db.unitframe.units.target.height = 42
    E.db.unitframe.units.target.power.height = 7
    E.db.unitframe.units.target.CombatIcon.size = 23
    E.db.unitframe.units.target.CombatIcon.yOffset = -1
    E.db.unitframe.units.target.CombatIcon.xOffset = -3
    E.db.unitframe.units.target.buffs.countFontSize = 14
    E.db.unitframe.units.target.buffs.sizeOverride = 30
    E.db.unitframe.units.target.buffs.width = 30
    E.db.unitframe.units.target.buffs.height = 25
    E.db.unitframe.units.target.buffs.yOffset = 7
    E.db.unitframe.units.target.buffs.perrow = 8
    E.db.unitframe.units.target.debuffs.sizeOverride = 26
    E.db.unitframe.units.target.debuffs.countFontSize = 14
    E.db.unitframe.units.target.debuffs.yOffset = 22
    E.db.unitframe.units.target.castbar.customTextFont.fontSize = 15
    E.db.unitframe.units.target.castbar.customTimeFont.fontSize = 15
    E.db.unitframe.units.target.castbar.height = 30
    E.db.unitframe.units.target.castbar.width = 260
    E.db.unitframe.units.target.customTexts.UnitPower.size = 15
    E.db.unitframe.units.target.customTexts.UnitHealth.size = 15
    E.db.unitframe.units.target.customTexts.UnitName.size = 15
    E.db.unitframe.units.target.raidicon.size = 21
    E.db.unitframe.units.target.raidicon.xOffset = -40
    E.db.unitframe.units.target.raidicon.yOffset = 11
    E.db.unitframe.units.target.customTexts.UnitHealth.yOffset = -3
    E.db.unitframe.units.target.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.target.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.target.customTexts.UnitName.yOffset = 17
    E.db.unitframe.units.target.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.target.customTexts.UnitPower.yOffset = -20
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.target.width = 205
    E.db.unitframe.units.target.height = 33
    E.db.unitframe.units.target.power.height = 6
    E.db.unitframe.units.target.CombatIcon.size = 17
    E.db.unitframe.units.target.CombatIcon.yOffset = 28
    E.db.unitframe.units.target.CombatIcon.xOffset = 1
    E.db.unitframe.units.target.buffs.countFontSize = 13
    E.db.unitframe.units.target.buffs.sizeOverride = 28
    E.db.unitframe.units.target.buffs.width = 24
    E.db.unitframe.units.target.buffs.height = 20
    E.db.unitframe.units.target.buffs.yOffset = 7
    E.db.unitframe.units.target.buffs.perrow = 8
    E.db.unitframe.units.target.debuffs.sizeOverride = 23
    E.db.unitframe.units.target.debuffs.countFontSize = 13
    E.db.unitframe.units.target.debuffs.yOffset = 17
    E.db.unitframe.units.target.castbar.customTextFont.fontSize = 13
    E.db.unitframe.units.target.castbar.customTimeFont.fontSize = 13
    E.db.unitframe.units.target.castbar.height = 27
    E.db.unitframe.units.target.castbar.width = 236
    E.db.unitframe.units.target.customTexts.UnitPower.size = 13
    E.db.unitframe.units.target.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.target.customTexts.UnitName.size = 13
    E.db.unitframe.units.target.raidicon.size = 18
    E.db.unitframe.units.target.raidicon.xOffset = -37
    E.db.unitframe.units.target.raidicon.yOffset = 14
    E.db.unitframe.units.target.customTexts.UnitHealth.yOffset = -2
    E.db.unitframe.units.target.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.target.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.target.customTexts.UnitName.yOffset = 13
    E.db.unitframe.units.target.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.target.customTexts.UnitPower.yOffset = -17
  end

  if E.Retail or E.Classic or E.TBC then
    E.db.unitframe.units.raid1.buffs.anchorPoint = 'BOTTOMRIGHT'
    E.db.unitframe.units.raid1.buffs.countFont = Private.Font
    E.db.unitframe.units.raid1.buffs.countFontSize = 14
    E.db.unitframe.units.raid1.buffs.enable = true
    E.db.unitframe.units.raid1.buffs.growthX = 'LEFT'
    E.db.unitframe.units.raid1.buffs.spacing = -1

    E.db.unitframe.units.raid1.debuffs.anchorPoint = 'TOPRIGHT'
    E.db.unitframe.units.raid1.debuffs.countFont = Private.Font
    E.db.unitframe.units.raid1.debuffs.countFontSize = 14
    E.db.unitframe.units.raid1.debuffs.enable = true
    E.db.unitframe.units.raid1.debuffs.growthY = 'DOWN'
    E.db.unitframe.units.raid1.debuffs.growthX = 'LEFT'
    E.db.unitframe.units.raid1.debuffs.spacing = -1

    E.db.unitframe.units.raid2.buffs.anchorPoint = 'BOTTOMRIGHT'
    E.db.unitframe.units.raid2.buffs.countFont = Private.Font
    E.db.unitframe.units.raid2.buffs.countFontSize = 14
    E.db.unitframe.units.raid2.buffs.enable = true
    E.db.unitframe.units.raid2.buffs.growthX = 'LEFT'
    E.db.unitframe.units.raid2.buffs.spacing = -1

    E.db.unitframe.units.raid2.debuffs.anchorPoint = 'TOPRIGHT'
    E.db.unitframe.units.raid2.debuffs.countFont = Private.Font
    E.db.unitframe.units.raid2.debuffs.countFontSize = 14
    E.db.unitframe.units.raid2.debuffs.enable = true
    E.db.unitframe.units.raid2.debuffs.growthY = 'DOWN'
    E.db.unitframe.units.raid2.debuffs.growthX = 'LEFT'
    E.db.unitframe.units.raid2.debuffs.spacing = -1

    E.db.unitframe.units.raid3.buffs.anchorPoint = 'BOTTOMRIGHT'
    E.db.unitframe.units.raid3.buffs.countFont = Private.Font
    E.db.unitframe.units.raid3.buffs.countFontSize = 14
    E.db.unitframe.units.raid3.buffs.enable = true
    E.db.unitframe.units.raid3.buffs.growthX = 'LEFT'
    E.db.unitframe.units.raid3.buffs.spacing = -1

    E.db.unitframe.units.raid3.debuffs.anchorPoint = 'TOPRIGHT'
    E.db.unitframe.units.raid3.debuffs.countFont = Private.Font
    E.db.unitframe.units.raid3.debuffs.countFontSize = 14
    E.db.unitframe.units.raid3.debuffs.enable = true
    E.db.unitframe.units.raid3.debuffs.growthY = 'DOWN'
    E.db.unitframe.units.raid3.debuffs.growthX = 'LEFT'
    E.db.unitframe.units.raid3.debuffs.spacing = -1
  end

  E.db.unitframe.units.targettarget.power.enable = false
  E.db.unitframe.units.targettarget.name.text_format = ''
  E.db.unitframe.units.targettarget.fader.enable = false
  E.db.unitframe.units.targettarget.customTexts = E.db.unitframe.units.targettarget.customTexts or {}
  E.db.unitframe.units.targettarget.customTexts.UnitName = E.db.unitframe.units.targettarget.customTexts.UnitName or {}
  E.db.unitframe.units.targettarget.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.targettarget.customTexts.UnitName.enable = true
  E.db.unitframe.units.targettarget.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.targettarget.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.targettarget.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.targettarget.customTexts.UnitName.text_format = '[name:abbrev:short]'
  E.db.unitframe.units.targettarget.customTexts.UnitName.xOffset = 0
  E.db.unitframe.units.targettarget.customTexts.UnitName.yOffset = 0
  E.db.unitframe.units.targettarget.debuffs = E.db.unitframe.units.targettarget.debuffs or {}
  E.db.unitframe.units.targettarget.debuffs.enable = false
  E.db.unitframe.units.targettarget.raidicon.enable = false

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.targettarget.width = 100
    E.db.unitframe.units.targettarget.height = 20
    E.db.unitframe.units.targettarget.customTexts.UnitName.size = 15
    E.db.unitframe.units.targettarget.customTexts.UnitName.yOffset = 9
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.targettarget.width = 80
    E.db.unitframe.units.targettarget.height = 20
    E.db.unitframe.units.targettarget.customTexts.UnitName.size = 13
    E.db.unitframe.units.targettarget.customTexts.UnitName.yOffset = 9
  end

  -- UF: Pet
  E.db.unitframe.units.pet.buffs.priority = 'Blacklist,Personal,PlayerBuffs,Dispellable'
  E.db.unitframe.units.pet.debuffs.attachTo = 'BUFFS'
  E.db.unitframe.units.pet.debuffs.priority = 'Blacklist,Personal,Boss,RaidDebuffs,CCDebuffs,Dispellable,Whitelist'
  E.db.unitframe.units.pet.fader.enable = false
  E.db.unitframe.units.pet.healPrediction.enable = false
  E.db.unitframe.units.pet.name.text_format = ''
  E.db.unitframe.units.pet.power.attachTextTo = 'Frame'
  E.db.unitframe.units.pet.power.height = 7
  E.db.unitframe.units.pet.power.xOffset = 0
  E.db.unitframe.units.pet.threatStyle = 'NONE'
  E.db.unitframe.units.pet.castbar.enable = false
  E.db.unitframe.units.pet.castbar.spark = false
  E.db.unitframe.units.pet.castbar.textColor.b = 0.77647058823529
  E.db.unitframe.units.pet.castbar.textColor.g = 0.89411764705882
  E.db.unitframe.units.pet.castbar.textColor.r = 1
  E.db.unitframe.units.pet.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.pet.customTexts = E.db.unitframe.units.pet.customTexts or {}
  E.db.unitframe.units.pet.customTexts.UnitPower = E.db.unitframe.units.pet.customTexts.UnitPower or {}
  E.db.unitframe.units.pet.customTexts.UnitPower.attachTextTo = 'Power'
  E.db.unitframe.units.pet.customTexts.UnitPower.enable = false
  E.db.unitframe.units.pet.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.pet.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.pet.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.pet.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  E.db.unitframe.units.pet.customTexts.UnitPower.xOffset = 0
  E.db.unitframe.units.pet.customTexts.UnitPower.yOffset = 0
  E.db.unitframe.units.pet.customTexts.UnitHealth = E.db.unitframe.units.pet.customTexts.UnitHealth or {}
  E.db.unitframe.units.pet.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.pet.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.pet.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.pet.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.pet.customTexts.UnitHealth.justifyH = 'CENTER'
  E.db.unitframe.units.pet.customTexts.UnitHealth.text_format = '[health:current:shortvalue]'
  E.db.unitframe.units.pet.customTexts.UnitHealth.xOffset = 0
  E.db.unitframe.units.pet.customTexts.UnitHealth.yOffset = 0
  E.db.unitframe.units.pet.customTexts.UnitName = E.db.unitframe.units.pet.customTexts.UnitName or {}
  E.db.unitframe.units.pet.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.pet.customTexts.UnitName.enable = false
  E.db.unitframe.units.pet.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.pet.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.pet.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.pet.customTexts.UnitName.text_format = '[name:abbrev:short]'
  E.db.unitframe.units.pet.customTexts.UnitName.xOffset = 0
  E.db.unitframe.units.pet.customTexts.UnitName.yOffset = 0
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.pet.height = 20
    E.db.unitframe.units.pet.width = 100
    E.db.unitframe.units.pet.castbar.height = 20
    E.db.unitframe.units.pet.castbar.width = 200
    E.db.unitframe.units.pet.customTexts.UnitPower.size = 15
    E.db.unitframe.units.pet.customTexts.UnitHealth.size = 15
    E.db.unitframe.units.pet.customTexts.UnitName.size = 15
    E.db.unitframe.units.pet.customTexts.UnitHealth.yOffset = 6
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.pet.height = 20
    E.db.unitframe.units.pet.width = 80
    E.db.unitframe.units.pet.castbar.height = 20
    E.db.unitframe.units.pet.castbar.width = 200
    E.db.unitframe.units.pet.customTexts.UnitPower.size = 13
    E.db.unitframe.units.pet.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.pet.customTexts.UnitName.size = 13
    E.db.unitframe.units.pet.customTexts.UnitHealth.yOffset = 5
  end

  -- UF: Focus
  E.db.unitframe.units.focus.CombatIcon.enable = false
  E.db.unitframe.units.focus.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.focus.castbar.enable = false
  E.db.unitframe.units.focus.disableTargetGlow = true
  E.db.unitframe.units.focus.fader.enable = false
  E.db.unitframe.units.focus.healPrediction.enable = false
  E.db.unitframe.units.focus.name.text_format = ''
  E.db.unitframe.units.focus.orientation = 'RIGHT'
  E.db.unitframe.units.focus.power.attachTextTo = 'Power'
  E.db.unitframe.units.focus.power.height = 7
  E.db.unitframe.units.focus.power.position = 'CENTER'
  E.db.unitframe.units.focus.threatStyle = 'NONE'
  E.db.unitframe.units.focus.buffs.anchorPoint = 'TOPRIGHT'
  E.db.unitframe.units.focus.buffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.focus.buffs.enable = false
  E.db.unitframe.units.focus.buffs.growthX = 'LEFT'
  E.db.unitframe.units.focus.buffs.maxDuration = 0
  E.db.unitframe.units.focus.buffs.priority = 'Blacklist,Personal,nonPersonal,CastByNPC'
  E.db.unitframe.units.focus.buffs.spacing = -1
  E.db.unitframe.units.focus.buffs.yOffset = -2
  E.db.unitframe.units.focus.debuffs.anchorPoint = 'LEFT'
  E.db.unitframe.units.focus.debuffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.focus.debuffs.enable = false
  E.db.unitframe.units.focus.debuffs.perrow = 6
  E.db.unitframe.units.focus.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable'
  E.db.unitframe.units.focus.debuffs.spacing = -1
  E.db.unitframe.units.focus.debuffs.xOffset = -7
  E.db.unitframe.units.focus.debuffs.yOffset = -2
  E.db.unitframe.units.focus.castbar.customTextFont.enable = true
  E.db.unitframe.units.focus.castbar.customTextFont.font = Private.Font
  E.db.unitframe.units.focus.castbar.customTimeFont.enable = true
  E.db.unitframe.units.focus.castbar.customTimeFont.font = Private.Font
  E.db.unitframe.units.focus.castbar.spark = false
  E.db.unitframe.units.focus.castbar.strataAndLevel.frameStrata = 'BACKGROUND'
  E.db.unitframe.units.focus.castbar.strataAndLevel.useCustomStrata = true
  E.db.unitframe.units.focus.castbar.textColor.b = 1
  E.db.unitframe.units.focus.castbar.textColor.g = 1
  E.db.unitframe.units.focus.castbar.textColor.r = 1
  E.db.unitframe.units.focus.customTexts = E.db.unitframe.units.focus.customTexts or {}
  E.db.unitframe.units.focus.customTexts.UnitPower = E.db.unitframe.units.focus.customTexts.UnitPower or {}
  E.db.unitframe.units.focus.customTexts.UnitPower.attachTextTo = 'Health'
  E.db.unitframe.units.focus.customTexts.UnitPower.enable = true
  E.db.unitframe.units.focus.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.focus.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.focus.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.focus.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  --E.db.unitframe.units.focus.customTexts.UnitPower.xOffset = -3
  E.db.unitframe.units.focus.customTexts.UnitPower.yOffset = 0
  E.db.unitframe.units.focus.customTexts.UnitHealth = E.db.unitframe.units.focus.customTexts.UnitHealth or {}
  E.db.unitframe.units.focus.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.focus.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.focus.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.focus.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.focus.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.focus.customTexts.UnitHealth.text_format = '[perhp]% | [health:current:shortvalue]'
  --E.db.unitframe.units.focus.customTexts.UnitHealth.xOffset = 3
  --E.db.unitframe.units.focus.customTexts.UnitHealth.yOffset = -10
  E.db.unitframe.units.focus.customTexts.UnitName = E.db.unitframe.units.focus.customTexts.UnitName or {}
  E.db.unitframe.units.focus.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.focus.customTexts.UnitName.enable = true
  E.db.unitframe.units.focus.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.focus.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.focus.customTexts.UnitName.justifyH = 'RIGHT'
  E.db.unitframe.units.focus.customTexts.UnitName.text_format = '[name:long]'
  --E.db.unitframe.units.focus.customTexts.UnitName.xOffset = 3
  --E.db.unitframe.units.focus.customTexts.UnitName.yOffset = 10
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.focus.height = 42
    E.db.unitframe.units.focus.width = 200
    E.db.unitframe.units.focus.castbar.height = 30
    E.db.unitframe.units.focus.castbar.width = 221
    E.db.unitframe.units.focus.castbar.customTextFont.fontSize = 14
    E.db.unitframe.units.focus.castbar.customTimeFont.fontSize = 14
    E.db.unitframe.units.focus.buffs.countFontSize = 14
    E.db.unitframe.units.focus.debuffs.countFontSize = 14
    E.db.unitframe.units.focus.debuffs.sizeOverride = 37
    E.db.unitframe.units.focus.customTexts.UnitPower.size = 15
    E.db.unitframe.units.focus.customTexts.UnitHealth.size = 15
    E.db.unitframe.units.focus.customTexts.UnitName.size = 15
    E.db.unitframe.units.focus.customTexts.UnitHealth.yOffset = -3
    E.db.unitframe.units.focus.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.focus.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.focus.customTexts.UnitName.yOffset = 17
    E.db.unitframe.units.focus.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.focus.customTexts.UnitPower.yOffset = -20
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.focus.height = 33
    E.db.unitframe.units.focus.width = 170
    E.db.unitframe.units.focus.castbar.height = 27
    E.db.unitframe.units.focus.castbar.width = 181
    E.db.unitframe.units.focus.castbar.customTextFont.fontSize = 11
    E.db.unitframe.units.focus.castbar.customTimeFont.fontSize = 11
    E.db.unitframe.units.focus.buffs.countFontSize = 11
    E.db.unitframe.units.focus.debuffs.countFontSize = 11
    E.db.unitframe.units.focus.debuffs.sizeOverride = 37
    E.db.unitframe.units.focus.customTexts.UnitPower.size = 13
    E.db.unitframe.units.focus.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.focus.customTexts.UnitName.size = 13
    E.db.unitframe.units.focus.customTexts.UnitHealth.yOffset = -3
    E.db.unitframe.units.focus.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.focus.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.focus.customTexts.UnitName.yOffset = 13
    E.db.unitframe.units.focus.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.focus.customTexts.UnitPower.yOffset = -17
  end

  -- UF: Arena
  E.db.unitframe.units.arena.buffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.arena.buffs.enable = false
  E.db.unitframe.units.arena.buffs.maxDuration = 0
  E.db.unitframe.units.arena.buffs.priority = 'Blacklist,CastByUnit,Dispellable,Whitelist,RaidBuffsElvUI'
  E.db.unitframe.units.arena.customTexts = E.db.unitframe.units.arena.customTexts or {}
  E.db.unitframe.units.arena.customTexts.UnitPower = E.db.unitframe.units.arena.customTexts.UnitPower or {}
  E.db.unitframe.units.arena.customTexts.UnitPower.attachTextTo = 'Health'
  E.db.unitframe.units.arena.customTexts.UnitPower.enable = true
  E.db.unitframe.units.arena.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.arena.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.arena.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.arena.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  --E.db.unitframe.units.arena.customTexts.UnitPower.xOffset = -3
  E.db.unitframe.units.arena.customTexts.UnitHealth = E.db.unitframe.units.arena.customTexts.UnitHealth or {}
  E.db.unitframe.units.arena.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.arena.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.arena.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.arena.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.arena.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.arena.customTexts.UnitHealth.text_format = '[health:percent]'
  --E.db.unitframe.units.arena.customTexts.UnitHealth.xOffset = 3
  --E.db.unitframe.units.arena.customTexts.UnitHealth.yOffset = -10
  E.db.unitframe.units.arena.customTexts.UnitName = E.db.unitframe.units.arena.customTexts.UnitName or {}
  E.db.unitframe.units.arena.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.arena.customTexts.UnitName.enable = true
  E.db.unitframe.units.arena.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.arena.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.arena.customTexts.UnitName.justifyH = 'RIGHT'
  E.db.unitframe.units.arena.customTexts.UnitName.text_format = '[name:abbrev:short]'
  --E.db.unitframe.units.arena.customTexts.UnitName.xOffset = 3
  --E.db.unitframe.units.arena.customTexts.UnitName.yOffset = 10
  E.db.unitframe.units.arena.debuffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.arena.debuffs.desaturate = true
  E.db.unitframe.units.arena.debuffs.enable = false
  E.db.unitframe.units.arena.debuffs.maxDuration = 0
  E.db.unitframe.units.arena.debuffs.priority = 'Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,Whitelist'
  E.db.unitframe.units.arena.debuffs.yOffset = -3
  E.db.unitframe.units.arena.growthDirection = 'UP'
  E.db.unitframe.units.arena.healPrediction.enable = false
  E.db.unitframe.units.arena.health.text_format = ''
  E.db.unitframe.units.arena.name.text_format = ''
  E.db.unitframe.units.arena.power.text_format = ''
  E.db.unitframe.units.arena.castbar.customTimeFont.enable = true
  E.db.unitframe.units.arena.castbar.customTimeFont.font = Private.GetProfileFont()
  E.db.unitframe.units.arena.castbar.customTextFont.enable = true
  E.db.unitframe.units.arena.castbar.customTextFont.font = Private.GetProfileFont()
  E.db.unitframe.units.arena.castbar.positionsGroup.yOffset = 1
  E.db.unitframe.units.arena.castbar.strataAndLevel.useCustomLevel = true
  E.db.unitframe.units.arena.castbar.xOffsetText = 1
  E.db.unitframe.units.arena.castbar.xOffsetTime = -1

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.arena.spacing = 30
    E.db.unitframe.units.arena.height = 40
    E.db.unitframe.units.arena.width = 200
    E.db.unitframe.units.arena.power.height = 6
    E.db.unitframe.units.arena.buffs.countFontSize = 14
    E.db.unitframe.units.arena.buffs.sizeOverride = 22
    E.db.unitframe.units.arena.buffs.yOffset = 20
    E.db.unitframe.units.arena.debuffs.countFontSize = 14
    E.db.unitframe.units.arena.debuffs.sizeOverride = 22
    E.db.unitframe.units.arena.customTexts.UnitPower.size = 14
    E.db.unitframe.units.arena.customTexts.UnitHealth.size = 15
    E.db.unitframe.units.arena.customTexts.UnitName.size = 15
    E.db.unitframe.units.arena.pvpTrinket.size = 40
    E.db.unitframe.units.arena.customTexts.UnitHealth.yOffset = -4
    E.db.unitframe.units.arena.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.arena.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.arena.customTexts.UnitName.yOffset = 15
    E.db.unitframe.units.arena.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.arena.customTexts.UnitPower.yOffset = -18
    E.db.unitframe.units.arena.castbar.customTimeFont.fontSize = 13
    E.db.unitframe.units.arena.castbar.customTextFont.fontSize = 13
    E.db.unitframe.units.arena.castbar.height = 15
    E.db.unitframe.units.arena.castbar.positionsGroup.yOffset = 1
    E.db.unitframe.units.arena.castbar.strataAndLevel.useCustomLevel = true
    E.db.unitframe.units.arena.castbar.width = 200
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.arena.spacing = 20
    E.db.unitframe.units.arena.height = 33
    E.db.unitframe.units.arena.width = 160
    E.db.unitframe.units.arena.power.height = 6
    E.db.unitframe.units.arena.buffs.countFontSize = 11
    E.db.unitframe.units.arena.buffs.sizeOverride = 22
    E.db.unitframe.units.arena.buffs.yOffset = 20
    E.db.unitframe.units.arena.debuffs.countFontSize = 11
    E.db.unitframe.units.arena.debuffs.sizeOverride = 22
    E.db.unitframe.units.arena.customTexts.UnitPower.size = 13
    E.db.unitframe.units.arena.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.arena.customTexts.UnitName.size = 13
    E.db.unitframe.units.arena.pvpTrinket.size = 44
    E.db.unitframe.units.arena.customTexts.UnitHealth.yOffset = -3
    E.db.unitframe.units.arena.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.arena.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.arena.customTexts.UnitName.yOffset = -12
    E.db.unitframe.units.arena.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.arena.customTexts.UnitPower.yOffset = -16
    E.db.unitframe.units.arena.castbar.customTimeFont.fontSize = 11
    E.db.unitframe.units.arena.castbar.customTextFont.fontSize = 11
    E.db.unitframe.units.arena.castbar.height = 13
    E.db.unitframe.units.arena.castbar.positionsGroup.yOffset = 1
    E.db.unitframe.units.arena.castbar.strataAndLevel.useCustomLevel = true
    E.db.unitframe.units.arena.castbar.width = 160
  end

  -- UF: Assist
  E.db.unitframe.units.assist.enable = false

  -- UF: Boss
  E.db.unitframe.units.boss.buffIndicator.enable = false
  E.db.unitframe.units.boss.buffs.countFont = Private.GetProfileFont('bold')
  E.db.unitframe.units.boss.buffs.enable = true
  E.db.unitframe.units.boss.buffs.anchorPoint = 'TOPRIGHT'
  E.db.unitframe.units.boss.buffs.countFont = Private.Font
  E.db.unitframe.units.boss.buffs.growthY = 'DOWN'
  E.db.unitframe.units.boss.buffs.numrows = 2
  E.db.unitframe.units.boss.buffs.spacing = -1
  E.db.unitframe.units.boss.buffs.xOffset = 3
  E.db.unitframe.units.boss.buffs.yOffset = 0
  E.db.unitframe.units.boss.buffs.priority = 'Blacklist,Dispellable,RaidBuffsElvUI,CastByNPC'
  E.db.unitframe.units.boss.buffs.countYOffset = 0
  E.db.unitframe.units.boss.debuffs.enable = E.Retail
  E.db.unitframe.units.boss.debuffs.desaturate = false
  E.db.unitframe.units.boss.debuffs.countFont = Private.Font
  E.db.unitframe.units.boss.debuffs.yOffset = 0
  E.db.unitframe.units.boss.debuffs.spacing = 0
  E.db.unitframe.units.boss.castbar.enable = false
  E.db.unitframe.units.boss.growthDirection = 'UP'
  E.db.unitframe.units.boss.health.text_format = ''
  E.db.unitframe.units.boss.name.text_format = ''
  E.db.unitframe.units.boss.power.height = 7
  E.db.unitframe.units.boss.power.text_format = ''
  E.db.unitframe.units.boss.customTexts = E.db.unitframe.units.boss.customTexts or {}
  E.db.unitframe.units.boss.customTexts.UnitPower = E.db.unitframe.units.boss.customTexts.UnitPower or {}
  E.db.unitframe.units.boss.customTexts.UnitPower.attachTextTo = 'Health'
  E.db.unitframe.units.boss.customTexts.UnitPower.enable = true
  E.db.unitframe.units.boss.customTexts.UnitPower.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.boss.customTexts.UnitPower.fontOutline = 'OUTLINE'
  E.db.unitframe.units.boss.customTexts.UnitPower.justifyH = 'CENTER'
  E.db.unitframe.units.boss.customTexts.UnitPower.text_format = '[power:current:shortvalue]'
  E.db.unitframe.units.boss.customTexts.UnitPower.xOffset = -3
  E.db.unitframe.units.boss.customTexts.UnitPower.yOffset = 0
  E.db.unitframe.units.boss.customTexts.UnitHealth = E.db.unitframe.units.boss.customTexts.UnitHealth or {}
  E.db.unitframe.units.boss.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.boss.customTexts.UnitHealth.enable = true
  E.db.unitframe.units.boss.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.boss.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.boss.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.boss.customTexts.UnitHealth.text_format = '[health:percent]'
  E.db.unitframe.units.boss.customTexts.UnitHealth.xOffset = 3
  E.db.unitframe.units.boss.customTexts.UnitHealth.yOffset = -10
  E.db.unitframe.units.boss.customTexts.UnitName = E.db.unitframe.units.boss.customTexts.UnitName or {}
  E.db.unitframe.units.boss.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.boss.customTexts.UnitName.enable = true
  E.db.unitframe.units.boss.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.boss.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.boss.customTexts.UnitName.justifyH = 'RIGHT'
  E.db.unitframe.units.boss.customTexts.UnitName.text_format = '[name:long]'
  E.db.unitframe.units.boss.customTexts.UnitName.xOffset = 3
  E.db.unitframe.units.boss.customTexts.UnitName.yOffset = 10
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.boss.height = 40
    E.db.unitframe.units.boss.width = 200
    E.db.unitframe.units.boss.spacing = 10
    E.db.unitframe.units.boss.buffs.countFontSize = 13
    E.db.unitframe.units.boss.buffs.sizeOverride = 24
    E.db.unitframe.units.boss.debuffs.countFontSize = 15
    E.db.unitframe.units.boss.debuffs.sizeOverride = 35
    E.db.unitframe.units.boss.debuffs.xOffset = -5
    E.db.unitframe.units.boss.debuffs.perrow = 7
    E.db.unitframe.units.boss.customTexts.UnitPower.size = 15
    E.db.unitframe.units.boss.customTexts.UnitHealth.size = 15
    E.db.unitframe.units.boss.customTexts.UnitName.size = 15
    E.db.unitframe.units.boss.customTexts.UnitHealth.yOffset = -4
    E.db.unitframe.units.boss.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.boss.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.boss.customTexts.UnitName.yOffset = 15
    E.db.unitframe.units.boss.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.boss.customTexts.UnitPower.yOffset = -17
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.boss.height = 33
    E.db.unitframe.units.boss.width = 160
    E.db.unitframe.units.boss.spacing = 10
    E.db.unitframe.units.boss.buffs.countFontSize = 11
    E.db.unitframe.units.boss.buffs.sizeOverride = 16
    E.db.unitframe.units.boss.debuffs.countFontSize = 13
    E.db.unitframe.units.boss.debuffs.sizeOverride = 33
    E.db.unitframe.units.boss.debuffs.xOffset = -3
    E.db.unitframe.units.boss.debuffs.perrow = 7
    E.db.unitframe.units.boss.customTexts.UnitPower.size = 13
    E.db.unitframe.units.boss.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.boss.customTexts.UnitName.size = 13
    E.db.unitframe.units.boss.customTexts.UnitHealth.yOffset = -3
    E.db.unitframe.units.boss.customTexts.UnitHealth.xOffset = -2
    E.db.unitframe.units.boss.customTexts.UnitName.xOffset = -2
    E.db.unitframe.units.boss.customTexts.UnitName.yOffset = 12
    E.db.unitframe.units.boss.customTexts.UnitPower.xOffset = 0
    E.db.unitframe.units.boss.customTexts.UnitPower.yOffset = -16
  end

  -- UF: Tank
  E.db.unitframe.units.tank.enable = false

  -- UF: Party
  E.db.unitframe.units.party = E.db.unitframe.units.party or {}
  E.db.unitframe.units.party.buffIndicator.enable = false
  E.db.unitframe.units.party.buffs.enable = E.Retail or E.Classic or E.TBC
  E.db.unitframe.units.party.buffs.anchorPoint = 'BOTTOMLEFT'
  E.db.unitframe.units.party.buffs.growthX = 'RIGHT'
  E.db.unitframe.units.party.buffs.growthY = 'UP'
  E.db.unitframe.units.party.buffs.countFont = Private.Font
  E.db.unitframe.units.party.buffs.perrow = 5
  E.db.unitframe.units.party.buffs.spacing = -1
  E.db.unitframe.units.party.buffs.yOffset = 0
  E.db.unitframe.units.party.debuffs.enable = E.Retail or E.Classic or E.Cata or E.Mists or E.TBC
  E.db.unitframe.units.party.debuffs.desaturate = false
  E.db.unitframe.units.party.debuffs.countFont = Private.Font
  E.db.unitframe.units.party.debuffs.anchorPoint = 'TOPLEFT'
  E.db.unitframe.units.party.debuffs.growthX = 'RIGHT'
  E.db.unitframe.units.party.debuffs.growthY = 'DOWN'
  E.db.unitframe.units.party.debuffs.spacing = -1
  E.db.unitframe.units.party.debuffs.xOffset = 0
  E.db.unitframe.units.party.debuffs.yOffset = 1
  E.db.unitframe.units.party.debuffs.perrow = 5
  E.db.unitframe.units.party.debuffs.priority = 'Blacklist,Dispellable,RaidDebuffs,CCDebuffs,CastByNPC'
  E.db.unitframe.units.party.raidRoleIcons.enable = true
  E.db.unitframe.units.party.rdebuffs.enable = false
  E.db.unitframe.units.party.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.party.customTexts = E.db.unitframe.units.party.customTexts or {}
  E.db.unitframe.units.party.customTexts.DeadGhostStatus = E.db.unitframe.units.party.customTexts.DeadGhostStatus or {}
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.attachTextTo = 'Health'
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.enable = false
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.font = Private.Font
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.justifyH = 'CENTER'
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.xOffset = 0
  E.db.unitframe.units.party.customTexts.DeadGhostStatus.yOffset = 0
  E.db.unitframe.units.party.customTexts.OfflineStatus = E.db.unitframe.units.party.customTexts.OfflineStatus or {}
  E.db.unitframe.units.party.customTexts.OfflineStatus.attachTextTo = 'Health'
  E.db.unitframe.units.party.customTexts.OfflineStatus.enable = false
  E.db.unitframe.units.party.customTexts.OfflineStatus.font = Private.Font
  E.db.unitframe.units.party.customTexts.OfflineStatus.fontOutline = 'OUTLINE'
  E.db.unitframe.units.party.customTexts.OfflineStatus.justifyH = 'CENTER'
  E.db.unitframe.units.party.customTexts.OfflineStatus.text_format = '[namecolor][offline]'
  E.db.unitframe.units.party.customTexts.OfflineStatus.xOffset = 0
  E.db.unitframe.units.party.customTexts.OfflineStatus.yOffset = 0
  E.db.unitframe.units.party.customTexts.UnitHealth = E.db.unitframe.units.party.customTexts.UnitHealth or {}
  E.db.unitframe.units.party.customTexts.UnitHealth.attachTextTo = 'Health'
  E.db.unitframe.units.party.customTexts.UnitHealth.enable = false
  E.db.unitframe.units.party.customTexts.UnitHealth.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.party.customTexts.UnitHealth.fontOutline = 'OUTLINE'
  E.db.unitframe.units.party.customTexts.UnitHealth.justifyH = 'RIGHT'
  E.db.unitframe.units.party.customTexts.UnitHealth.text_format = '[healthcolor][health:deficit:shortvalue]'
  E.db.unitframe.units.party.customTexts.UnitHealth.xOffset = -5
  E.db.unitframe.units.party.customTexts.UnitHealth.yOffset = 0
  E.db.unitframe.units.party.customTexts.UnitName = E.db.unitframe.units.party.customTexts.UnitName or {}
  E.db.unitframe.units.party.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.party.customTexts.UnitName.enable = true
  E.db.unitframe.units.party.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.party.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.party.customTexts.UnitName.justifyH = 'CENTER'
  --E.db.unitframe.units.party.customTexts.UnitName.text_format = "[name:abbrev:short]"
  E.db.unitframe.units.party.customTexts.UnitName.xOffset = 0
  E.db.unitframe.units.party.customTexts.UnitName.yOffset = 0
  E.db.unitframe.units.party.groupBy = 'ROLE'
  E.db.unitframe.units.party.healPrediction.enable = true
  E.db.unitframe.units.party.health.text_format = ''
  E.db.unitframe.units.party.name.text_format = ''
  E.db.unitframe.units.party.petsGroup.enable = false
  E.db.unitframe.units.party.petsGroup.name.text_format = '[health:current:shortvalue]'
  E.db.unitframe.units.party.power.enable = false
  E.db.unitframe.units.party.power.text_format = ''
  E.db.unitframe.units.party.rdebuffs.enable = false
  E.db.unitframe.units.party.rdebuffs.font = Private.Font
  E.db.unitframe.units.party.rdebuffs.yOffset = 15
  E.db.unitframe.units.party.readycheckIcon.attachTo = 'CENTER'
  E.db.unitframe.units.party.readycheckIcon.yOffset = 13
  E.db.unitframe.units.party.roleIcon.enable = true
  E.db.unitframe.units.party.roleIcon.combatHide = false
  E.db.unitframe.units.party.roleIcon.size = 10
  E.db.unitframe.units.party.roleIcon.tank = true
  E.db.unitframe.units.party.roleIcon.damager = true
  E.db.unitframe.units.party.roleIcon.healer = true
  E.db.unitframe.units.party.sortDir = 'DESC'
  E.db.unitframe.units.party.threatStyle = 'ICONLEFT'
  E.db.unitframe.units.party.horizontalSpacing = -1
  E.db.unitframe.units.party.verticalSpacing = -1
  E.db.unitframe.units.party.threatStyle = 'ICONLEFT'
  E.db.unitframe.units.party.classbar.enable = false
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.party.growthDirection = 'UP_RIGHT'
    E.db.unitframe.units.party.petsGroup.anchorPoint = 'LEFT'
    E.db.unitframe.units.party.petsGroup.xOffset = -5
    E.db.unitframe.units.party.petsGroup.yOffset = 0
    E.db.unitframe.units.party.debuffs.anchorPoint = 'RIGHT'
    E.db.unitframe.units.party.debuffs.growthX = 'RIGHT'
    E.db.unitframe.units.party.debuffs.growthY = 'DOWN'
    E.db.unitframe.units.party.debuffs.xOffset = 2
    E.db.unitframe.units.party.debuffs.yOffset = 0
    E.db.unitframe.units.party.debuffs.numrows = 2
  elseif layout == 'Healer-H' then
    E.db.unitframe.units.party.growthDirection = 'RIGHT_DOWN'
    E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
    E.db.unitframe.units.party.petsGroup.xOffset = 0
    E.db.unitframe.units.party.petsGroup.yOffset = -3
  elseif layout == 'Healer-V' then
    E.db.unitframe.units.party.growthDirection = 'UP_RIGHT'
    E.db.unitframe.units.party.petsGroup.anchorPoint = 'LEFT'
    E.db.unitframe.units.party.petsGroup.xOffset = -5
    E.db.unitframe.units.party.petsGroup.yOffset = 0
    E.db.unitframe.units.party.debuffs.anchorPoint = 'RIGHT'
    E.db.unitframe.units.party.debuffs.growthX = 'RIGHT'
    E.db.unitframe.units.party.debuffs.growthY = 'DOWN'
    E.db.unitframe.units.party.debuffs.xOffset = 2
    E.db.unitframe.units.party.debuffs.yOffset = 0
    E.db.unitframe.units.party.debuffs.numrows = 2
  end
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.party.rdebuffs.fontSize = 12
    E.db.unitframe.units.party.customTexts.DeadGhostStatus.size = 13
    E.db.unitframe.units.party.customTexts.OfflineStatus.size = 15
    E.db.unitframe.units.party.customTexts.UnitHealth.size = 14
    E.db.unitframe.units.party.customTexts.UnitName.size = 15
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
      E.db.unitframe.units.party.height = 60
      E.db.unitframe.units.party.width = 260
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 20
      E.db.unitframe.units.party.debuffs.sizeOverride = 30
      E.db.unitframe.units.party.debuffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.sizeOverride = 23
      E.db.unitframe.units.party.buffIndicator.countFontSize = 15
      E.db.unitframe.units.party.petsGroup.height = 40
      E.db.unitframe.units.party.petsGroup.width = 100
    elseif layout == 'Healer-H' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:veryshort]'
      E.db.unitframe.units.party.height = 65
      E.db.unitframe.units.party.width = 130
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 20
      E.db.unitframe.units.party.debuffs.sizeOverride = 18
      E.db.unitframe.units.party.debuffs.countFontSize = 14
      E.db.unitframe.units.party.buffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.sizeOverride = 23
      E.db.unitframe.units.party.buffIndicator.countFontSize = 15
      E.db.unitframe.units.party.petsGroup.height = 25
      E.db.unitframe.units.party.petsGroup.width = 100
      E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
    elseif layout == 'Healer-V' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
      E.db.unitframe.units.party.height = 65
      E.db.unitframe.units.party.width = 260
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 20
      E.db.unitframe.units.party.debuffs.sizeOverride = 30
      E.db.unitframe.units.party.debuffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.sizeOverride = 23
      E.db.unitframe.units.party.buffIndicator.countFontSize = 15
      E.db.unitframe.units.party.petsGroup.height = 40
      E.db.unitframe.units.party.petsGroup.width = 100
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.party.rdebuffs.fontSize = 11
    E.db.unitframe.units.party.customTexts.DeadGhostStatus.size = 13
    E.db.unitframe.units.party.customTexts.OfflineStatus.size = 13
    E.db.unitframe.units.party.customTexts.UnitHealth.size = 13
    E.db.unitframe.units.party.customTexts.UnitName.size = 13
    E.db.unitframe.units.party.buffIndicator.countFontSize = 11
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
      E.db.unitframe.units.party.height = 55
      E.db.unitframe.units.party.width = 230
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 20
      E.db.unitframe.units.party.debuffs.sizeOverride = 25
      E.db.unitframe.units.party.debuffs.countFontSize = 12
      E.db.unitframe.units.party.buffs.countFontSize = 12
      E.db.unitframe.units.party.buffs.sizeOverride = 20
      E.db.unitframe.units.party.petsGroup.height = 35
      E.db.unitframe.units.party.petsGroup.width = 90
    elseif layout == 'Healer-H' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:veryshort]'
      E.db.unitframe.units.party.height = 55
      E.db.unitframe.units.party.width = 100
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 16
      E.db.unitframe.units.party.debuffs.sizeOverride = 18
      E.db.unitframe.units.party.debuffs.countFontSize = 12
      E.db.unitframe.units.party.buffs.countFontSize = 12
      E.db.unitframe.units.party.buffs.sizeOverride = 20
      E.db.unitframe.units.party.petsGroup.height = 25
      E.db.unitframe.units.party.petsGroup.width = 100
      E.db.unitframe.units.party.petsGroup.anchorPoint = 'BOTTOM'
    elseif layout == 'Healer-V' then
      E.db.unitframe.units.party.customTexts.UnitName.text_format = '[name:abbrev:short]'
      E.db.unitframe.units.party.height = 55
      E.db.unitframe.units.party.width = 235
      E.db.unitframe.units.party.power.height = 6
      E.db.unitframe.units.party.readycheckIcon.size = 20
      E.db.unitframe.units.party.debuffs.sizeOverride = 25
      E.db.unitframe.units.party.debuffs.countFontSize = 13
      E.db.unitframe.units.party.buffs.countFontSize = 12
      E.db.unitframe.units.party.buffs.sizeOverride = 20
      E.db.unitframe.units.party.petsGroup.height = 35
      E.db.unitframe.units.party.petsGroup.width = 90
    end
  end

  -- DPS/TANK UF: Raid 1
  E.db.unitframe.units.raid1 = E.db.unitframe.units.raid1 or {}
  E.db.unitframe.units.raid1.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.raid1.customName = E.Retail and 'Raid-20' or 'Raid-10'
  E.db.unitframe.units.raid1.buffIndicator.enable = false
  E.db.unitframe.units.raid1.buffs.enable = E.Retail or E.Classic or E.TBC
  E.db.unitframe.units.raid1.buffs.anchorPoint = 'BOTTOMLEFT'
  E.db.unitframe.units.raid1.buffs.growthY = 'UP'
  E.db.unitframe.units.raid1.buffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid1.buffs.yOffset = -1
  E.db.unitframe.units.raid1.buffs.perrow = 5
  E.db.unitframe.units.raid1.debuffs.enable = E.Retail or E.Classic or E.TBC
  E.db.unitframe.units.raid1.debuffs.desaturate = false
  E.db.unitframe.units.raid1.debuffs.anchorPoint = 'TOPLEFT'
  E.db.unitframe.units.raid1.debuffs.growthY = 'DOWN'
  E.db.unitframe.units.raid1.debuffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid1.debuffs.yOffset = 1
  E.db.unitframe.units.raid1.debuffs.perrow = 5
  E.db.unitframe.units.raid1.rdebuffs.enable = false
  E.db.unitframe.units.raid1.fader.smooth = 0.1
  E.db.unitframe.units.raid1.groupBy = 'ROLE'
  E.db.unitframe.units.raid1.healPrediction.enable = true
  E.db.unitframe.units.raid1.health.position = 'LEFT'
  E.db.unitframe.units.raid1.health.text_format = ''
  E.db.unitframe.units.raid1.health.yOffset = 0
  E.db.unitframe.units.raid1.horizontalSpacing = -1
  E.db.unitframe.units.raid1.name.text_format = ''
  E.db.unitframe.units.raid1.numGroups = E.Retail and 4 or 2
  E.db.unitframe.units.raid1.groupsPerRowCol = 1
  E.db.unitframe.units.raid1.orientation = 'LEFT'
  E.db.unitframe.units.raid1.power.enable = false
  E.db.unitframe.units.raid1.power.height = 4
  E.db.unitframe.units.raid1.power.position = 'RIGHT'
  E.db.unitframe.units.raid1.power.yOffset = 0
  E.db.unitframe.units.raid1.raidRoleIcons.enable = true
  E.db.unitframe.units.raid1.raidRoleIcons.yOffset = 3
  E.db.unitframe.units.raid1.readycheckIcon.attachTo = 'CENTER'
  E.db.unitframe.units.raid1.readycheckIcon.yOffset = 13
  E.db.unitframe.units.raid1.roleIcon.enable = true
  E.db.unitframe.units.raid1.roleIcon.combatHide = false
  E.db.unitframe.units.raid1.roleIcon.tank = true
  E.db.unitframe.units.raid1.roleIcon.damager = false
  E.db.unitframe.units.raid1.roleIcon.healer = true
  E.db.unitframe.units.raid1.verticalSpacing = -1
  E.db.unitframe.units.raid1.classbar.enable = false
  E.db.unitframe.units.raid1.threatStyle = 'ICONLEFT'
  E.db.unitframe.units.raid1.customTexts = E.db.unitframe.units.raid1.customTexts or {}
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus = E.db.unitframe.units.raid1.customTexts.DeadGhostStatus or {}
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.attachTextTo = 'Health'
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.enable = true
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.font = Private.Font
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.justifyH = 'CENTER'
  E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'
  E.db.unitframe.units.raid1.customTexts.UnitName = E.db.unitframe.units.raid1.customTexts.UnitName or {}
  E.db.unitframe.units.raid1.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.raid1.customTexts.UnitName.enable = true
  E.db.unitframe.units.raid1.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.raid1.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid1.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.raid1.customTexts.UnitName.text_format = '[name:veryshort]'
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.raid1.growthDirection = 'RIGHT_UP'
  elseif layout == 'Healer-H' or layout == 'Healer-V' then
    E.db.unitframe.units.raid1.growthDirection = 'RIGHT_DOWN'
  end
  E.db.unitframe.units.raid1.privateAuras = E.db.unitframe.units.raid1.privateAuras or {}
  E.db.unitframe.units.raid1.privateAuras.icon = E.db.unitframe.units.raid1.privateAuras.icon or {}
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.raid1.buffIndicator.countFontSize = 13
    E.db.unitframe.units.raid1.buffs.countFontSize = 13
    E.db.unitframe.units.raid1.debuffs.countFontSize = 13
    E.db.unitframe.units.raid1.privateAuras.icon.size = 25
    E.db.unitframe.units.raid1.customTexts.UnitName.size = 15
    E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid1.width = 91
      E.db.unitframe.units.raid1.height = E.Retail and 60 or 40
      E.db.unitframe.units.raid1.buffs.sizeOverride = E.Retail and 20 or 18
      E.db.unitframe.units.raid1.debuffs.sizeOverride = E.Retail and 20 or 18
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.yOffset = 13
      E.db.unitframe.units.raid1.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid1.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid1.width = 130
      E.db.unitframe.units.raid1.height = E.Retail and 75 or 65
      E.db.unitframe.units.raid1.buffs.sizeOverride = E.Retail and 23 or 20
      E.db.unitframe.units.raid1.debuffs.sizeOverride = E.Retail and 23 or 20
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid1.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid1.readycheckIcon.size = 20
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.raid1.buffIndicator.countFontSize = 11
    E.db.unitframe.units.raid1.buffs.countFontSize = 11
    E.db.unitframe.units.raid1.debuffs.countFontSize = 11
    E.db.unitframe.units.raid1.privateAuras.icon.size = 20
    E.db.unitframe.units.raid1.customTexts.UnitName.size = 13
    E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid1.width = 73
      E.db.unitframe.units.raid1.height = E.Retail and 50 or 35
      E.db.unitframe.units.raid1.buffs.sizeOverride = E.Retail and 17 or 15
      E.db.unitframe.units.raid1.debuffs.sizeOverride = E.Retail and 17 or 15
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.yOffset = 13
      E.db.unitframe.units.raid1.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid1.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid1.width = 100
      E.db.unitframe.units.raid1.height = E.Retail and 60 or 50
      E.db.unitframe.units.raid1.buffs.sizeOverride = E.Retail and 20 or 17
      E.db.unitframe.units.raid1.debuffs.sizeOverride = E.Retail and 20 or 17
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.size = 13
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid1.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid1.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid1.readycheckIcon.size = 20
    end
  end

  -- DPS/TANK UF: Raid 2
  E.db.unitframe.units.raid2 = E.db.unitframe.units.raid2 or {}
  E.db.unitframe.units.raid2.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.raid2.customName = E.Retail and 'Raid-30' or 'Raid-25'
  E.db.unitframe.units.raid2.buffIndicator.enable = false
  E.db.unitframe.units.raid2.buffs.enable = E.Retail or E.Classic or E.TBC
  E.db.unitframe.units.raid2.buffs.anchorPoint = 'BOTTOMLEFT'
  E.db.unitframe.units.raid2.buffs.growthY = 'UP'
  E.db.unitframe.units.raid2.buffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid2.buffs.yOffset = -1
  E.db.unitframe.units.raid2.buffs.perrow = 5
  E.db.unitframe.units.raid2.debuffs.desaturate = false
  E.db.unitframe.units.raid2.debuffs.anchorPoint = 'TOPLEFT'
  E.db.unitframe.units.raid2.debuffs.growthY = 'DOWN'
  E.db.unitframe.units.raid2.debuffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid2.debuffs.yOffset = 1
  E.db.unitframe.units.raid2.debuffs.perrow = 5
  E.db.unitframe.units.raid2.rdebuffs.enable = false
  E.db.unitframe.units.raid2.customTexts = E.db.unitframe.units.raid2.customTexts or {}
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus = E.db.unitframe.units.raid2.customTexts.DeadGhostStatus or {}
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.attachTextTo = 'Health'
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.enable = true
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.font = Private.Font
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.justifyH = 'CENTER'
  E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'
  E.db.unitframe.units.raid2.customTexts.UnitName = E.db.unitframe.units.raid2.customTexts.UnitName or {}
  E.db.unitframe.units.raid2.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.raid2.customTexts.UnitName.enable = true
  E.db.unitframe.units.raid2.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.raid2.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid2.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.raid2.customTexts.UnitName.text_format = '[name:veryshort]'
  E.db.unitframe.units.raid2.fader.smooth = 0.1
  E.db.unitframe.units.raid2.groupBy = 'ROLE'
  E.db.unitframe.units.raid2.healPrediction.enable = true
  E.db.unitframe.units.raid2.health.position = 'LEFT'
  E.db.unitframe.units.raid2.health.text_format = ''
  E.db.unitframe.units.raid2.health.yOffset = 0
  E.db.unitframe.units.raid2.horizontalSpacing = -1
  E.db.unitframe.units.raid2.name.text_format = ''
  E.db.unitframe.units.raid2.orientation = 'LEFT'
  E.db.unitframe.units.raid2.power.height = 4
  E.db.unitframe.units.raid2.power.position = 'RIGHT'
  E.db.unitframe.units.raid2.power.yOffset = 0
  E.db.unitframe.units.raid2.raidRoleIcons.enable = true
  E.db.unitframe.units.raid2.raidRoleIcons.yOffset = 3
  E.db.unitframe.units.raid2.readycheckIcon.attachTo = 'CENTER'
  E.db.unitframe.units.raid2.readycheckIcon.yOffset = 13
  E.db.unitframe.units.raid2.roleIcon.enable = true
  E.db.unitframe.units.raid2.roleIcon.combatHide = false
  E.db.unitframe.units.raid2.roleIcon.tank = true
  E.db.unitframe.units.raid2.roleIcon.damager = false
  E.db.unitframe.units.raid2.roleIcon.healer = true
  E.db.unitframe.units.raid2.verticalSpacing = -1
  E.db.unitframe.units.raid2.numGroups = E.Retail and 6 or 5
  E.db.unitframe.units.raid2.classbar.enable = false
  E.db.unitframe.units.raid2.threatStyle = 'ICONLEFT'
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.raid2.growthDirection = 'RIGHT_UP'
  elseif layout == 'Healer-H' or layout == 'Healer-V' then
    E.db.unitframe.units.raid2.growthDirection = 'RIGHT_DOWN'
  end
  E.db.unitframe.units.raid2.privateAuras = E.db.unitframe.units.raid2.privateAuras or {}
  E.db.unitframe.units.raid2.privateAuras.icon = E.db.unitframe.units.raid2.privateAuras.icon or {}
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.raid2.buffIndicator.countFontSize = 13
    E.db.unitframe.units.raid2.buffs.sizeOverride = E.Retail and 20 or 18
    E.db.unitframe.units.raid2.buffs.countFontSize = 13
    E.db.unitframe.units.raid2.debuffs.sizeOverride = E.Retail and 20 or 18
    E.db.unitframe.units.raid2.debuffs.countFontSize = 13
    E.db.unitframe.units.raid2.privateAuras.icon.size = 25
    E.db.unitframe.units.raid2.customTexts.UnitName.size = 15
    E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid2.width = 91
      E.db.unitframe.units.raid2.height = E.Retail and 45 or 35
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.yOffset = 13
      E.db.unitframe.units.raid2.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid2.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid2.width = 130
      E.db.unitframe.units.raid2.height = E.Retail and 54 or 65
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid2.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid2.readycheckIcon.size = 20
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.raid2.buffIndicator.countFontSize = 11
    E.db.unitframe.units.raid2.buffs.countFontSize = 11
    E.db.unitframe.units.raid2.debuffs.countFontSize = 11
    E.db.unitframe.units.raid2.privateAuras.icon.size = 20
    E.db.unitframe.units.raid2.customTexts.UnitName.size = 13
    E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid2.width = 73
      E.db.unitframe.units.raid2.height = E.Retail and 40 or 35
      E.db.unitframe.units.raid2.buffs.sizeOverride = E.Retail and 16 or 15
      E.db.unitframe.units.raid2.debuffs.sizeOverride = E.Retail and 16 or 15
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid2.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid2.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid2.width = 100
      E.db.unitframe.units.raid2.height = E.Retail and 40 or 50
      E.db.unitframe.units.raid2.buffs.sizeOverride = E.Retail and 17 or 15
      E.db.unitframe.units.raid2.debuffs.sizeOverride = E.Retail and 17 or 15
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.size = 13
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid2.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid2.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid2.readycheckIcon.size = 20
    end
  end

  -- DPS/TANK UF: Raid 3
  E.db.unitframe.units.raid3 = E.db.unitframe.units.raid3 or {}
  E.db.unitframe.units.raid3.colorOverride = 'FORCE_ON'
  E.db.unitframe.units.raid3.customName = 'Raid-40'
  E.db.unitframe.units.raid3.buffIndicator.enable = false
  E.db.unitframe.units.raid3.buffs.enable = E.Retail or E.Classic or E.TBC
  E.db.unitframe.units.raid3.buffs.anchorPoint = 'BOTTOMLEFT'
  E.db.unitframe.units.raid3.buffs.growthY = 'UP'
  E.db.unitframe.units.raid3.buffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid3.buffs.yOffset = -1
  E.db.unitframe.units.raid3.debuffs.perrow = 5
  E.db.unitframe.units.raid3.debuffs.enable = E.Retail
  E.db.unitframe.units.raid3.debuffs.desaturate = false
  E.db.unitframe.units.raid3.debuffs.anchorPoint = 'TOPLEFT'
  E.db.unitframe.units.raid3.debuffs.growthY = 'DOWN'
  E.db.unitframe.units.raid3.debuffs.growthX = 'RIGHT'
  E.db.unitframe.units.raid3.debuffs.yOffset = 1
  E.db.unitframe.units.raid3.debuffs.perrow = 5
  E.db.unitframe.units.raid3.rdebuffs.enable = false
  E.db.unitframe.units.raid3.customTexts = E.db.unitframe.units.raid3.customTexts or {}
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus = E.db.unitframe.units.raid3.customTexts.DeadGhostStatus or {}
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.attachTextTo = 'Health'
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.enable = true
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.font = Private.Font
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.justifyH = 'CENTER'
  E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.text_format = '[namecolor][dead]'
  E.db.unitframe.units.raid3.customTexts.UnitName = E.db.unitframe.units.raid3.customTexts.UnitName or {}
  E.db.unitframe.units.raid3.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.raid3.customTexts.UnitName.enable = true
  E.db.unitframe.units.raid3.customTexts.UnitName.font = Private.GetProfileFont('bold')
  E.db.unitframe.units.raid3.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raid3.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.raid3.customTexts.UnitName.text_format = '[name:veryshort]'
  E.db.unitframe.units.raid3.fader.smooth = 0.1
  E.db.unitframe.units.raid3.groupBy = 'ROLE'
  E.db.unitframe.units.raid3.healPrediction.enable = true
  E.db.unitframe.units.raid3.health.position = 'LEFT'
  E.db.unitframe.units.raid3.health.text_format = ''
  E.db.unitframe.units.raid3.health.yOffset = 0
  E.db.unitframe.units.raid3.horizontalSpacing = -1
  E.db.unitframe.units.raid3.name.text_format = ''
  E.db.unitframe.units.raid3.numGroups = 8
  E.db.unitframe.units.raid3.groupsPerRowCol = 1
  E.db.unitframe.units.raid3.orientation = 'LEFT'
  E.db.unitframe.units.raid3.power.height = 4
  E.db.unitframe.units.raid3.power.position = 'RIGHT'
  E.db.unitframe.units.raid3.power.yOffset = 0
  E.db.unitframe.units.raid3.raidRoleIcons.enable = true
  E.db.unitframe.units.raid3.raidRoleIcons.yOffset = 3
  E.db.unitframe.units.raid3.readycheckIcon.attachTo = 'CENTER'
  E.db.unitframe.units.raid3.readycheckIcon.yOffset = 13
  E.db.unitframe.units.raid3.roleIcon.enable = true
  E.db.unitframe.units.raid3.roleIcon.combatHide = false
  E.db.unitframe.units.raid3.roleIcon.tank = true
  E.db.unitframe.units.raid3.roleIcon.damager = false
  E.db.unitframe.units.raid3.roleIcon.healer = true
  E.db.unitframe.units.raid3.verticalSpacing = -1
  E.db.unitframe.units.raid3.numGroups = (E.Retail or E.Classic or E.TBC) and 8 or 5
  E.db.unitframe.units.raid3.classbar.enable = false
  E.db.unitframe.units.raid3.threatStyle = 'ICONLEFT'
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.raid3.growthDirection = 'RIGHT_UP'
  elseif layout == 'Healer-H' or layout == 'Healer-V' then
    E.db.unitframe.units.raid3.growthDirection = 'RIGHT_DOWN'
  end
  E.db.unitframe.units.raid3.privateAuras = E.db.unitframe.units.raid3.privateAuras or {}
  E.db.unitframe.units.raid3.privateAuras.icon = E.db.unitframe.units.raid3.privateAuras.icon or {}
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.raid3.buffIndicator.countFontSize = 13
    E.db.unitframe.units.raid3.buffs.sizeOverride = 18
    E.db.unitframe.units.raid3.buffs.countFontSize = 13
    E.db.unitframe.units.raid3.debuffs.sizeOverride = 18
    E.db.unitframe.units.raid3.debuffs.countFontSize = 13
    E.db.unitframe.units.raid3.privateAuras.icon.size = 25
    E.db.unitframe.units.raid3.customTexts.UnitName.size = 15
    E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid3.width = 91
      E.db.unitframe.units.raid3.height = (E.Retail and 42) or ((E.Classic or E.TBC) and 30) or 50
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.yOffset = 13
      E.db.unitframe.units.raid3.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid3.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid3.width = 130
      E.db.unitframe.units.raid3.height = (E.Retail and 42) or ((E.Classic or E.TBC) and 41) or 65
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid3.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid3.readycheckIcon.size = 20
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.raid3.buffIndicator.countFontSize = 11
    E.db.unitframe.units.raid3.buffs.countFontSize = 11
    E.db.unitframe.units.raid3.debuffs.countFontSize = 11
    E.db.unitframe.units.raid3.privateAuras.icon.size = 20
    E.db.unitframe.units.raid3.customTexts.UnitName.size = 13
    E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raid3.width = 73
      E.db.unitframe.units.raid3.height = E.Retail and 32 or 33
      E.db.unitframe.units.raid3.buffs.sizeOverride = 13
      E.db.unitframe.units.raid3.debuffs.sizeOverride = 13
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.yOffset = 11
      E.db.unitframe.units.raid3.customTexts.UnitName.size = 15
      E.db.unitframe.units.raid3.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid3.readycheckIcon.size = 20
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raid3.width = 100
      --E.db.unitframe.units.raid3.height = E.Retail and 32 or 50
      E.db.unitframe.units.raid3.height = (E.Retail and 32) or ((E.Classic or E.TBC) and 32) or 50
      E.db.unitframe.units.raid3.buffs.sizeOverride = 13
      E.db.unitframe.units.raid3.debuffs.sizeOverride = 13
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.size = 13
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.DeadGhostStatus.yOffset = 15
      E.db.unitframe.units.raid3.customTexts.UnitName.xOffset = 0
      E.db.unitframe.units.raid3.customTexts.UnitName.yOffset = 0
      E.db.unitframe.units.raid3.readycheckIcon.size = 20
    end
  end

  -- UF: Raid Pet
  E.db.unitframe.units.raidpet.health.text_format = ''
  E.db.unitframe.units.raidpet.horizontalSpacing = -1
  E.db.unitframe.units.raidpet.name.text_format = ''
  E.db.unitframe.units.raidpet.numGroups = 3
  E.db.unitframe.units.raidpet.orientation = 'LEFT'
  E.db.unitframe.units.raidpet.verticalSpacing = -1
  E.db.unitframe.units.raidpet.buffs.enable = false
  E.db.unitframe.units.raidpet.buffIndicator.enable = false
  E.db.unitframe.units.raidpet.rdebuffs.enable = false
  E.db.unitframe.units.raidpet.debuffs.anchorPoint = 'TOPRIGHT'
  E.db.unitframe.units.raidpet.debuffs.countFont = Private.Font
  E.db.unitframe.units.raidpet.debuffs.countFontSize = 13
  E.db.unitframe.units.raidpet.debuffs.enable = true
  E.db.unitframe.units.raidpet.debuffs.growthX = 'LEFT'
  E.db.unitframe.units.raidpet.debuffs.growthY = 'DOWN'
  E.db.unitframe.units.raidpet.debuffs.sizeOverride = 20
  E.db.unitframe.units.raidpet.debuffs.spacing = -1
  E.db.unitframe.units.raidpet.enable = true
  E.db.unitframe.units.raidpet.customTexts = E.db.unitframe.units.raidpet.customTexts or {}
  E.db.unitframe.units.raidpet.customTexts.UnitName = E.db.unitframe.units.raidpet.customTexts.UnitName or {}
  E.db.unitframe.units.raidpet.customTexts.UnitName.attachTextTo = 'Health'
  E.db.unitframe.units.raidpet.customTexts.UnitName.enable = true
  E.db.unitframe.units.raidpet.customTexts.UnitName.font = Private.Font
  E.db.unitframe.units.raidpet.customTexts.UnitName.fontOutline = 'OUTLINE'
  E.db.unitframe.units.raidpet.customTexts.UnitName.justifyH = 'CENTER'
  E.db.unitframe.units.raidpet.customTexts.UnitName.text_format = '[name:veryshort]'
  E.db.unitframe.units.raidpet.customTexts.UnitName.xOffset = 0
  E.db.unitframe.units.raidpet.customTexts.UnitName.yOffset = 0
  if layout == 'DPS/Tank' then
    E.db.unitframe.units.raidpet.enable = false
  elseif layout == 'Healer-H' or layout == 'Healer-V' then
    E.db.unitframe.units.raidpet.enable = true
  end
  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.db.unitframe.units.raidpet.debuffs.countFontSize = 12
    E.db.unitframe.units.raidpet.debuffs.sizeOverride = 20
    E.db.unitframe.units.raidpet.rdebuffs.fontSize = 12
    E.db.unitframe.units.raidpet.customTexts.UnitName.size = 15
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raidpet.height = 45
      E.db.unitframe.units.raidpet.width = 65
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raidpet.height = 47
      E.db.unitframe.units.raidpet.width = 84
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.db.unitframe.units.raidpet.debuffs.countFontSize = 11
    E.db.unitframe.units.raidpet.debuffs.sizeOverride = 20
    E.db.unitframe.units.raidpet.rdebuffs.fontSize = 11
    E.db.unitframe.units.raidpet.customTexts.UnitName.size = 13
    if layout == 'DPS/Tank' then
      E.db.unitframe.units.raidpet.height = 35
      E.db.unitframe.units.raidpet.width = 47
    elseif layout == 'Healer-H' or layout == 'Healer-V' then
      E.db.unitframe.units.raidpet.height = 35
      E.db.unitframe.units.raidpet.width = 70
    end
  end

  if E.Retail then
    local units = { 'party', 'raid1', 'raid2', 'raid3', 'raidpet' }
    for _, unit in ipairs(units) do
      local unitDB = E.db.unitframe.units[unit]
      unitDB.buffIndicator.enable = false
      unitDB.buffs.allowList = 'Whitelist'
      unitDB.buffs.allowOthers = false
      unitDB.buffs.isAuraPlayer = true
      unitDB.buffs.maxDuration = 0
      unitDB.buffs.useAllowlist = true
    end
  end

end

db.filters = function()
  if not E.TBC then
    return
  end
  E.global.unitframe.aurafilters.RaidDebuffs = E.global.unitframe.aurafilters.RaidDebuffs or {}
  E.global.unitframe.aurafilters.RaidDebuffs.spells = E.global.unitframe.aurafilters.RaidDebuffs.spells or {}

  local spells = {
    13737,
    15708,
    16856,
    17547,
    19643,
    24573,
  }

  for _, spellID in ipairs(spells) do
    E.global.unitframe.aurafilters.RaidDebuffs.spells[spellID] = {
      enable = true,
      priority = 0,
      stackThreshold = 0,
    }
  end
end

function Private.LoadPlugins()
  Private.ClassColorsDB()
  Private.ProjectAzilrokaDB(profileName)
  Private.AddOnSkinsDB(profileName)
  if not E.Retail then
    Private.CataArmoryDB()
  end
end

function Private.ImportElvUI(layout)
  local profileLayout = (layout == 'Healer' and 'Healer-V') or layout

  local profileName = Private.GetLayoutProfileName(profileLayout)
  local keepMovers = Private.GetBlacklist('movers')
  local keepActionBars = Private.GetBlacklist('actionBars')
  local currentMovers = keepMovers and CopyDBValue(E.db.movers)
  local currentActionBars = keepActionBars and CopyDBValue(E.db.actionbar)

  E.data:SetProfile(profileName)

  Private.GlobalDB()
  Private.PrivateDB()
  Private.NameplatesDB()
  Private.LoadPlugins()

  db.movers(profileLayout, keepMovers)
  db.general()
  db.auras()
  db.bags()
  db.chat()
  db.databars()
  db.datatext()
  db.tooltip()
  db.actionbars(keepActionBars)
  RestoreDBValues(E.db.movers, currentMovers)
  RestoreDBValues(E.db.actionbar, currentActionBars)
  db.cooldowns()
  db.unitframes(profileLayout)
  db.filters()

  Private.ChangeTheme('DARK')

  E:UpdateAll(true)

  Private:PluginInstallStepComplete(string.format('%s Profile', profileLayout))
end
