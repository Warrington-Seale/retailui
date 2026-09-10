local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local LoadFilters = function()
  if not E.Retail then
    return
  end

  local unitframe = E.global and E.global.unitframe
  local auraFilters = unitframe and unitframe.aurafilters
  local auraWatch = unitframe and unitframe.aurawatch
  local whitelist = auraFilters and auraFilters.Whitelist
  local classIndicators = auraWatch and auraWatch[E.myclass]

  if not whitelist or not classIndicators then
    return
  end

  whitelist.spells = whitelist.spells or {}

  local function AddToWhitelist(spellID)
    if type(spellID) ~= 'number' then
      return
    end

    local spell = whitelist.spells[spellID] or {}
    spell.enable = true
    spell.priority = 0
    spell.stackThreshold = 0
    whitelist.spells[spellID] = spell
  end

  for spellID, indicator in pairs(classIndicators) do
    if type(indicator) == 'table' then
      AddToWhitelist(spellID)
      AddToWhitelist(indicator.id)

      if type(indicator.includeIDs) == 'table' then
        for _, includedSpellID in pairs(indicator.includeIDs) do
          AddToWhitelist(includedSpellID)
        end
      end
    end
  end
end

function Private.GlobalDB()
  ElvDB.global = ElvDB.global or {}
  ElvDB.global.general = ElvDB.global.general or {}

  -- Raid Debuff Indicator
  E.global.unitframe.raidDebuffIndicator = E.global.unitframe.raidDebuffIndicator or {}
  E.global.unitframe.raidDebuffIndicator.otherFilter = 'Debuff Indicators'
  E.global.unitframe.raidDebuffIndicator.instanceFilter = 'Debuff Indicators'

  DT:BuildPanelFrame('CustomPanel_Left')
  DT:BuildPanelFrame('CustomPanel_Right')

  -- Custom Panels
  E.global.datatexts.customPanels = E.global.datatexts.customPanels or {}
  E.global.datatexts.customPanels.CustomPanel_Left = E.global.datatexts.customPanels.CustomPanel_Left or {}
  E.global.datatexts.customPanels.CustomPanel_Left.backdrop = true
  E.global.datatexts.customPanels.CustomPanel_Left.benikuiStyle = true
  E.global.datatexts.customPanels.CustomPanel_Left.border = true
  E.global.datatexts.customPanels.CustomPanel_Left.enable = false
  E.global.datatexts.customPanels.CustomPanel_Left.fonts = E.global.datatexts.customPanels.CustomPanel_Left.fonts or {}
  E.global.datatexts.customPanels.CustomPanel_Left.fonts.enable = true
  E.global.datatexts.customPanels.CustomPanel_Left.fonts.font = Private.GetProfileFont('bold')
  E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontOutline = 'OUTLINE'
  E.global.datatexts.customPanels.CustomPanel_Left.frameLevel = 1
  E.global.datatexts.customPanels.CustomPanel_Left.frameStrata = 'LOW'
  E.global.datatexts.customPanels.CustomPanel_Left.growth = 'HORIZONTAL'
  E.global.datatexts.customPanels.CustomPanel_Left.height = 23
  E.global.datatexts.customPanels.CustomPanel_Left.mouseover = false
  E.global.datatexts.customPanels.CustomPanel_Left.name = 'CustomPanel_Left'
  E.global.datatexts.customPanels.CustomPanel_Left.numPoints = 2
  E.global.datatexts.customPanels.CustomPanel_Left.panelTransparency = true
  E.global.datatexts.customPanels.CustomPanel_Left.textJustify = 'CENTER'
  E.global.datatexts.customPanels.CustomPanel_Left.tooltipAnchor = 'ANCHOR_TOPLEFT'
  E.global.datatexts.customPanels.CustomPanel_Left.tooltipXOffset = -17
  E.global.datatexts.customPanels.CustomPanel_Left.tooltipYOffset = 4
  E.global.datatexts.customPanels.CustomPanel_Left.visibility = '[petbattle] hide;show'
  E.global.datatexts.customPanels.CustomPanel_Left.width = 451
  E.global.datatexts.customPanels.CustomPanel_Right = E.global.datatexts.customPanels.CustomPanel_Right or {}
  E.global.datatexts.customPanels.CustomPanel_Right.backdrop = true
  E.global.datatexts.customPanels.CustomPanel_Right.benikuiStyle = true
  E.global.datatexts.customPanels.CustomPanel_Right.border = true
  E.global.datatexts.customPanels.CustomPanel_Right.enable = false
  E.global.datatexts.customPanels.CustomPanel_Right.fonts = E.global.datatexts.customPanels.CustomPanel_Right.fonts or {}
  E.global.datatexts.customPanels.CustomPanel_Right.fonts.enable = true
  E.global.datatexts.customPanels.CustomPanel_Right.fonts.font = Private.GetProfileFont('bold')
  E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontOutline = 'OUTLINE'
  E.global.datatexts.customPanels.CustomPanel_Right.frameLevel = 1
  E.global.datatexts.customPanels.CustomPanel_Right.frameStrata = 'LOW'
  E.global.datatexts.customPanels.CustomPanel_Right.growth = 'HORIZONTAL'
  E.global.datatexts.customPanels.CustomPanel_Right.height = 23
  E.global.datatexts.customPanels.CustomPanel_Right.mouseover = false
  E.global.datatexts.customPanels.CustomPanel_Right.name = 'CustomPanel_Right'
  E.global.datatexts.customPanels.CustomPanel_Right.numPoints = 2
  E.global.datatexts.customPanels.CustomPanel_Right.panelTransparency = true
  E.global.datatexts.customPanels.CustomPanel_Right.textJustify = 'CENTER'
  E.global.datatexts.customPanels.CustomPanel_Right.tooltipAnchor = 'ANCHOR_TOPLEFT'
  E.global.datatexts.customPanels.CustomPanel_Right.tooltipXOffset = -17
  E.global.datatexts.customPanels.CustomPanel_Right.tooltipYOffset = 4
  E.global.datatexts.customPanels.CustomPanel_Right.visibility = '[petbattle] hide;show'

  if Private.GetProfileResolution() == 'QUAD_HD' then
    ElvDB.global.general.UIScale = 0.53333333333333
    E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontSize = 14
    E.global.datatexts.customPanels.CustomPanel_Left.height = 23
    E.global.datatexts.customPanels.CustomPanel_Left.width = 451
    E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontSize = 14
    E.global.datatexts.customPanels.CustomPanel_Right.height = 23
    E.global.datatexts.customPanels.CustomPanel_Right.width = 451
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    ElvDB.global.general.UIScale = 0.71111111111111
    E.global.datatexts.customPanels.CustomPanel_Left.fonts.fontSize = 13
    E.global.datatexts.customPanels.CustomPanel_Left.height = 21
    E.global.datatexts.customPanels.CustomPanel_Left.width = 361
    E.global.datatexts.customPanels.CustomPanel_Right.fonts.fontSize = 13
    E.global.datatexts.customPanels.CustomPanel_Right.height = 21
    E.global.datatexts.customPanels.CustomPanel_Right.width = 361
  end

  LoadFilters()

  E.global.datatexts.settings.Gold.goldFormat = 'CONDENSED'
end
