local E, L, V, P, G = unpack(ElvUI)
local Private = select(2, ...)
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

function Private.ClassColorsDB()
  if not IsAddOnLoaded('!ClassColors') then
    return
  end

  ClassColorsDB = ClassColorsDB or {}
  ClassColorsDB.DEATHKNIGHT = {
    b = 0.2509803921568627,
    colorStr = 'ffff3f3f',
    g = 0.2509803921568627,
    r = 1,
  }
end
