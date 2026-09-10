local addonName, Private = ...
local L = Private.L

local E, _, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local DisableAddOn = C_AddOns and C_AddOns.DisableAddOn or DisableAddOn

function Private.Import_xCT(layout)
  if layout == 'Blizzard' then
    if IsAddOnLoaded('xCT+') then
      DisableAddOn('xCT+')
    end

    SetCVar('floatingCombatTextCombatDamage', 1)
    SetCVar('floatingCombatTextCombatHealing', 1)
    SetCVar('floatingCombatTextPetMeleeDamage', 1)
    SetCVar('floatingCombatTextPetSpellDamage', 1)
    SetCVar('floatingCombatTextCombatLogPeriodicSpells', 1)
    SetCVar('floatingCombatTextCombatDamageDirectionalScale', 0)

    Private:PluginInstallStepComplete(L['Blizzard Combat Text'])
    return
  end

  if not E:IsAddOnEnabled('xCT+') then
    Private:Print(string.format(L['You need to enable %s to apply profile settings.'], 'xCT'))
    return
  end

  xCTSavedDB['profiles'] = xCTSavedDB['profiles'] or {}
  xCTSavedDB['profileKeys'] = xCTSavedDB['profileKeys'] or {}

  local profileName = Private.GetLayoutProfileName(layout)

  xCTSavedDB['profiles'][profileName] = {
    ['megaDamage'] = {
      ['thousandSymbol'] = '|cffFF8000K|r ',
      ['billionSymbol'] = '|cffFF0000G|r ',
      ['millionSymbol'] = '|cffFF0000M|r ',
    },
    ['spells'] = {
      ['mergePet'] = true,
      ['mergeHideMergedCriticals'] = true,
      ['items'] = {
        ['Quiver'] = {
          ['Quiver'] = false,
          ['Ammo Pouch'] = false,
        },
        ['Weapon'] = {
          ['One-Handed Axes'] = false,
          ['One-Handed Swords'] = false,
          ['Staves'] = false,
          ['Crossbows'] = false,
          ['Polearms'] = false,
          ['One-Handed Maces'] = false,
          ['Bows'] = false,
          ['Two-Handed Swords'] = false,
          ['Miscellaneous'] = false,
          ['Fishing Poles'] = false,
          ['Two-Handed Maces'] = false,
          ['Guns'] = false,
          ['Fist Weapons'] = false,
          ['Daggers'] = false,
          ['Wands'] = false,
          ['Thrown'] = false,
          ['Two-Handed Axes'] = false,
        },
        ['Glyph'] = {
          ['Warrior'] = false,
          ['Paladin'] = false,
          ['Shaman'] = false,
          ['Rogue'] = false,
          ['Mage'] = false,
          ['Warlock'] = false,
          ['Priest'] = false,
          ['Hunter'] = false,
          ['Death Knight'] = false,
          ['Druid'] = false,
        },
        ['Trade Goods'] = {
          ['Other'] = false,
          ['Elemental'] = false,
          ['Herb'] = false,
          ['Jewelcrafting'] = false,
          ['Metal & Stone'] = false,
          ['Parts'] = false,
          ['Devices'] = false,
          ['Leather'] = false,
          ['Armor Enchantment'] = false,
          ['Materials'] = false,
          ['Enchanting'] = false,
          ['Cloth'] = false,
          ['Explosives'] = false,
          ['Meat'] = false,
          ['Weapon Enchantment'] = false,
        },
        ['Miscellaneous'] = {
          ['Other'] = false,
          ['Reagent'] = false,
          ['Mount'] = false,
          ['Junk'] = false,
          ['Holiday'] = false,
          ['Pet'] = false,
        },
        ['Recipe'] = {
          ['Tailoring'] = false,
          ['Blacksmithing'] = false,
          ['Alchemy'] = false,
          ['First Aid'] = false,
          ['Book'] = false,
          ['Cooking'] = false,
          ['Jewelcrafting'] = false,
          ['Fishing'] = false,
          ['Engineering'] = false,
          ['Leatherworking'] = false,
          ['Inscription'] = false,
          ['Enchanting'] = false,
        },
        ['Consumable'] = {
          ['Other'] = false,
          ['Elixir'] = false,
          ['Food & Drink'] = false,
          ['Potion'] = false,
          ['Scroll'] = false,
          ['Flask'] = false,
          ['Bandage'] = false,
          ['Item Enhancement'] = false,
        },
        ['Gem'] = {
          ['Simple'] = false,
          ['Blue'] = false,
          ['Meta'] = false,
          ['Prismatic'] = false,
          ['Purple'] = false,
          ['Green'] = false,
          ['Yellow'] = false,
          ['Orange'] = false,
          ['Red'] = false,
        },
        ['version'] = 1,
        ['Projectile'] = {
          ['Arrow'] = false,
          ['Bullet'] = false,
        },
        ['Armor'] = {
          ['Totems'] = false,
          ['Shields'] = false,
          ['Librams'] = false,
          ['Miscellaneous'] = false,
          ['Leather'] = false,
          ['Idols'] = false,
          ['Mail'] = false,
          ['Plate'] = false,
          ['Cloth'] = false,
          ['Sigils'] = false,
        },
        ['Quest'] = {
          ['Quest'] = false,
        },
        ['Container'] = {
          ['Bag'] = false,
          ['Mining Bag'] = false,
          ['Soul Bag'] = false,
          ['Gem Bag'] = false,
          ['Engineering Bag'] = false,
          ['Herb Bag'] = false,
          ['Inscription Bag'] = false,
          ['Leatherworking Bag'] = false,
          ['Enchanting Bag'] = false,
        },
      },
      ['mergeDontMergeCriticals'] = false,
      ['merge'] = {
        [980] = {
          ['enabled'] = false,
        },
        [20153] = {
          ['enabled'] = false,
        },
        [172] = {
          ['enabled'] = false,
        },
        [348] = {
          ['enabled'] = false,
        },
      },
    },
    ['frames'] = {
      ['general'] = {
        ['showDispells'] = false,
        ['showPartyKills'] = false,
        ['showDebuffs'] = false,
        ['font'] = 'Merfin Font 1',
        ['showHonorGains'] = false,
        ['showInterrupts'] = false,
        ['showRepChanges'] = false,
        ['showBuffs'] = false,
        ['showLowManaHealth'] = false,
      },
      ['outgoing'] = {
        ['fontShadowOffsetX'] = 1,
        ['enableFontShadow'] = false,
        ['fontShadowOffsetY'] = -1,
        ['enableOverhealing'] = false,
        ['font'] = 'Merfin Font 1',
        ['enableOutHeal'] = false,
        ['enableOutAbsorbs'] = false,
        ['insertText'] = 'top',
        ['enableHots'] = false,
      },
      ['loot'] = {
        ['enableFontShadow'] = false,
        ['font'] = 'Merfin Font 1',
        ['enabledFrame'] = false,
        ['Y'] = 226,
        ['X'] = 5,
      },
      ['power'] = {
        ['enabledFrame'] = false,
      },
      ['critical'] = {
        ['secondaryFrame'] = 2,
        ['enabledFrame'] = false,
      },
      ['healing'] = {
        ['enableFontShadow'] = false,
        ['font'] = 'Merfin Font 1',
        ['enableRealmNames'] = false,
        ['fontSize'] = 13,
        ['enabledFrame'] = false,
        ['fontJustify'] = 'RIGHT',
        ['Y'] = 213,
        ['X'] = -403,
      },
      ['procs'] = {
        ['fontSize'] = 17,
        ['enabledFrame'] = false,
        ['Y'] = 71,
        ['font'] = 'Merfin Font 1',
        ['X'] = 8,
      },
      ['damage'] = {
        ['font'] = 'Merfin Font 1',
        ['fontSize'] = 15,
        ['enabledFrame'] = false,
        ['Y'] = -417,
        ['X'] = -412,
      },
    },
    ['dbVersion'] = '4.6.1',
    ['spellFilter'] = {
      ['listHealing'] = {
        ['15290'] = false,
      },
      ['listSpells'] = {
        ['15290'] = false,
      },
    },
    ['SpellColors'] = {
      ['64'] = {
        ['color'] = {
          1, -- [1]
          0.5, -- [2]
          1, -- [3]
        },
      },
      ['1'] = {
        ['color'] = {
          [3] = 0,
        },
      },
      ['2'] = {
        ['color'] = {
          nil, -- [1]
          0.9, -- [2]
          0.5, -- [3]
        },
      },
      ['4'] = {
        ['color'] = {
          nil, -- [1]
          0.5, -- [2]
          0, -- [3]
        },
      },
      ['8'] = {
        ['color'] = {
          0.3, -- [1]
          [3] = 0.3,
        },
      },
      ['16'] = {
        ['color'] = {
          0.5, -- [1]
          1, -- [2]
          1, -- [3]
        },
      },
      ['32'] = {
        ['color'] = {
          0.5, -- [1]
          0.5, -- [2]
        },
      },
    },
  }

  if layout == 'Tank' then
    local healing = xCTSavedDB['profiles'][profileName]['frames']['healing']
    healing.enabledFrame = true
  end

  if Private.GetProfileResolution() == 'QUAD_HD' then
    xCTSavedDB.profiles[profileName].frames.general.Y = 520
    xCTSavedDB.profiles[profileName].frames.general.X = 0
    xCTSavedDB.profiles[profileName].frames.general.fontSize = 15
    xCTSavedDB.profiles[profileName].frames.outgoing.Width = 167
    xCTSavedDB.profiles[profileName].frames.outgoing.Height = 127
    xCTSavedDB.profiles[profileName].frames.outgoing.fontSize = 15

    if layout == 'DPS' or layout == 'Tank' or layout == 'DPS/Tank' then
      xCTSavedDB.profiles[profileName].frames.outgoing.Y = -428
      xCTSavedDB.profiles[profileName].frames.outgoing.X = 345
      xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = false
    elseif layout == 'Healer' then
      xCTSavedDB.profiles[profileName].frames.outgoing.Y = -500
      xCTSavedDB.profiles[profileName].frames.outgoing.X = 863
      xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = true
    end

    if layout == 'Tank' then
      local healing = xCTSavedDB['profiles'][profileName]['frames']['healing']
      healing.Width = 275
      healing.fontSize = 14
      healing.Y = -279
      healing.X = -580
      healing.Height = 104
    end
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    xCTSavedDB.profiles[profileName].frames.general.Y = 300
    xCTSavedDB.profiles[profileName].frames.general.X = 0
    xCTSavedDB.profiles[profileName].frames.general.fontSize = 14
    xCTSavedDB.profiles[profileName].frames.outgoing.Width = 167
    xCTSavedDB.profiles[profileName].frames.outgoing.Height = 100
    xCTSavedDB.profiles[profileName].frames.outgoing.fontSize = 14

    if layout == 'DPS' or layout == 'Tank' or layout == 'DPS/Tank' then
      xCTSavedDB.profiles[profileName].frames.outgoing.Y = -341
      xCTSavedDB.profiles[profileName].frames.outgoing.X = 314
      xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = false
    elseif layout == 'Healer' then
      xCTSavedDB.profiles[profileName].frames.outgoing.Y = -424
      xCTSavedDB.profiles[profileName].frames.outgoing.X = 583
      xCTSavedDB.profiles[profileName].frames.outgoing.enableOutHeal = true
    end

    if layout == 'Tank' then
      local healing = xCTSavedDB['profiles'][profileName]['frames']['healing']
      healing.Width = 216
      healing.fontSize = 13
      healing.Y = -215
      healing.X = -510
      healing.Height = 90
    end
  end

  xCTSavedDB['profileKeys'][Private.AceProfileName] = profileName

  Private:PluginInstallStepComplete('xCT+')
end
