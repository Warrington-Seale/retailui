local E, L, V, P, G = unpack(ElvUI)
local Private = select(2, ...)

local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

function Private.AddOnSkinsDB(profileName)
  if not IsAddOnLoaded('AddOnSkins') then
    return
  end

  AddOnSkinsDB.profiles = AddOnSkinsDB.profiles or {}
  AddOnSkinsDB.profiles.Default = {
    ColorPickerPlus = false,
    ItemRack = false,
    RareScanner = false,
  }

  AddOnSkinsDB.profileKeys = AddOnSkinsDB.profileKeys or {}
  AddOnSkinsDB.profileKeys[profileName] = 'Default'
end
