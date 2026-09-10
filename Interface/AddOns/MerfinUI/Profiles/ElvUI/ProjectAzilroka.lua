local E = unpack(ElvUI)
local Private = select(2, ...)
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

function Private.ProjectAzilrokaDB(profileName)
  if not IsAddOnLoaded('ProjectAzilroka') or not ProjectAzilrokaDB then
    return
  end

  local db = ProjectAzilrokaDB
  db.profiles = db.profiles or {}
  db.profiles.Default = db.profiles.Default or {}

  local profile = db.profiles.Default

  -- modules
  profile.EnhancedShadows = profile.EnhancedShadows or {}
  profile.EnhancedShadows.Enable = false
  profile.EnhancedShadows.Size = 1

  profile.AuraReminder = profile.AuraReminder or {}
  profile.AuraReminder.Enable = false

  profile.EnhancedFriendsList = profile.EnhancedFriendsList or {}
  profile.EnhancedFriendsList.Enable = false
  profile.EnhancedFriendsList.DiffLevel = false
  profile.EnhancedFriendsList.Texture = Private.GetProfileTexture()

  profile.DragonOverlay = profile.DragonOverlay or {}
  profile.DragonOverlay.Enable = false

  profile.MovableFrames = profile.MovableFrames or {}
  profile.MovableFrames.Enable = false

  profile.OzCooldowns = profile.OzCooldowns or {}
  profile.OzCooldowns.Enable = false

  profile.QuestSounds = profile.QuestSounds or {}
  profile.QuestSounds.Enable = false

  profile.stAddonManager = profile.stAddonManager or {}
  profile.stAddonManager.Enable = false

  profile.MouseoverAuras = profile.MouseoverAuras or {}
  profile.MouseoverAuras.Enable = false

  profile.iFilger = profile.iFilger or {}
  profile.iFilger.Enable = false

  profile.BrokerLDB = profile.BrokerLDB or {}
  profile.BrokerLDB.Enable = false

  profile.MovableFrames = profile.MovableFrames or {}
  profile.MovableFrames.Enable = true
  profile.MovableFrames.ClampedToScreen = true

  profile.EnhancedPetBattleUI = profile.EnhancedPetBattleUI or {}
  profile.EnhancedPetBattleUI.Enable = false

  profile.FasterLoot = profile.FasterLoot or {}
  profile.FasterLoot.Enable = false

  profile.MasterExperience = profile.MasterExperience or {}
  profile.MasterExperience.Enable = false

  profile.Cooldown = profile.Cooldown or {}
  profile.Cooldown.Enable = false

  profile.TorghastBuffs = profile.TorghastBuffs or {}
  profile.TorghastBuffs.Enable = false

  profile.SquareMinimapButtons = profile.SquareMinimapButtons or {}
  profile.SquareMinimapButtons.Enable = true

  profile.SquareMinimapButtons.MoveMail = false
  profile.SquareMinimapButtons.MoveGarrison = false
  profile.SquareMinimapButtons.MoveQueue = false
  profile.SquareMinimapButtons.MoveTracker = false

  profile.SquareMinimapButtons.ButtonSpacing = -1
  profile.SquareMinimapButtons.ReverseDirection = true
  profile.SquareMinimapButtons.Backdrop = false
  profile.SquareMinimapButtons.BarMouseOver = true
  profile.SquareMinimapButtons.Shadows = false
  profile.SquareMinimapButtons.Strata = 'HIGH'
  profile.SquareMinimapButtons.Level = 12

  if Private.GetProfileResolution() == 'QUAD_HD' then
    profile.SquareMinimapButtons.ButtonsPerRow = 10
    profile.SquareMinimapButtons.IconSize = 23
    profile.EnhancedFriendsList.InfoFontSize = 14
    profile.EnhancedFriendsList.NameFontSize = 14
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    profile.SquareMinimapButtons.ButtonsPerRow = 10
    profile.SquareMinimapButtons.IconSize = 19
    profile.EnhancedFriendsList.InfoFontSize = 13
    profile.EnhancedFriendsList.NameFontSize = 13
  end

  -- profile key
  db.profileKeys = db.profileKeys or {}
  db.profileKeys[profileName] = 'Default'
end
