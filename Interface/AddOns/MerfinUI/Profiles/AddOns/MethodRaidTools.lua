local addonName, Private = ...
local L = Private.L
local E, _, V, P, G = unpack(ElvUI)

function Private.ImportMRT()
  if not E:IsAddOnEnabled('MRT') then
    Private:Print(string.format(L['You need to enable %s to apply profile settings.'], 'MethodRaidTools'))
    return
  end

  VMRT = VMRT or {}
  -- Raid Cooldowns
  if E.Retail then
    VMRT['ExCD2'] = VMRT['ExCD2'] or {}
    VMRT['ExCD2']['upd4525'] = true
    VMRT['ExCD2']['upd4380'] = true
    VMRT['ExCD2']['enabled'] = true
    VMRT['ExCD2']['NoRaid'] = true
    VMRT['ExCD2']['Left'] = 3.13593316078186
    VMRT['ExCD2']['Top'] = 1148.866943359375
    VMRT['ExCD2']['lock'] = true
    VMRT['ExCD2']['colSet'] = {
      {
        ['enabled'] = true,
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [1]
      {
        ['enabled'] = true,
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [2]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [3]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [4]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [5]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [6]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [7]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [8]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [9]
      {
        ['frameGeneral'] = true,
        ['iconGray'] = true,
        ['textGeneral'] = true,
        ['methodsGeneral'] = true,
        ['blacklistGeneral'] = true,
        ['textureGeneral'] = true,
        ['iconGeneral'] = true,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['fontGeneral'] = true,
        ['textureAnimation'] = true,
        ['fontShadow'] = false,
      }, -- [10]
      {
        ['fontLeftSize'] = 12,
        ['fontSize'] = 15,
        ['iconGray'] = true,
        ['visibilityPartyType'] = 2,
        ['frameBetweenLines'] = 0,
        ['frameWidth'] = 146,
        ['fontOutline'] = true,
        ['visibilityGeneral'] = true,
        ['visibilityDisable5ppl'] = true,
        ['methodsStyleAnimation'] = 2,
        ['frameLines'] = 18,
        ['textureFile'] = Private.GetMediaPath('statusbar', Private.GetProfileTexture()),
        ['textureAlphaBackground'] = 0.5,
        ['methodsAlphaNotInRangeNum'] = 89,
        ['frameBlackBack'] = 0,
        ['fontName'] = Private.GetMediaPath('font', Private.Font),
        ['blacklistGeneral'] = true,
        ['iconHideBlizzardEdges'] = true,
        ['textureBorderSize'] = 0,
        ['iconCooldownExRTNumbers'] = true,
        ['visibilityDisableArena'] = true,
        ['frameScale'] = 125,
        ['textureAnimation'] = true,
        ['textureClassTimeLine'] = true,
      }, -- [11]
    }
    VMRT['ExCD2']['CDE'] = {
      [740] = true,
      [108280] = true,
      [97462] = true,
      [98008] = true,
      [196718] = true,
    }
  end

  -- Note
  VMRT['Note'] = VMRT['Note'] or {}
  VMRT['Note']['Scale'] = 100
  VMRT['Note']['FontName'] = Private.GetMediaPath('font', Private.Font)
  VMRT['Note']['Outline'] = true
  VMRT['Note']['OptionsFormatting'] = true
  VMRT['Note']['HideOutsideRaid'] = true
  VMRT['Note']['ShowOnlyInRaid'] = true
  VMRT['Note']['OnlyPromoted'] = true
  VMRT['Note']['Fix'] = true
  VMRT['Note']['enabled'] = true
  VMRT['Note']['ScaleBack'] = 0
  VMRT['Note']['Strata'] = 'BACKGROUND'

  if Private.GetProfileResolution() == 'QUAD_HD' then
    VMRT['Note']['Left'] = 4
    VMRT['Note']['Width'] = 450
    VMRT['Note']['Height'] = 400
    VMRT['Note']['Top'] = 1164
    VMRT['Note']['FontSize'] = 12
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    VMRT['Note']['Left'] = 4
    VMRT['Note']['Width'] = 335
    VMRT['Note']['Height'] = 290
    VMRT['Note']['Top'] = 840
    VMRT['Note']['FontSize'] = 11
  end

  Private:PluginInstallStepComplete('MethodRaidTools')
end
