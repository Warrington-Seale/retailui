local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

function Private.CataArmoryDB()
  if not IsAddOnLoaded('ElvUI_CataArmory') then
    return
  end

  E.db['cataarmory'] = E.db['cataarmory'] or {}

  E.db['cataarmory']['character'] = E.db['cataarmory']['character'] or {}
  E.db['cataarmory']['character']['avgItemLevel']['text']['font'] = Private.Font

  E.db['cataarmory']['character']['enchant'] = E.db['cataarmory']['character']['enchant'] or {}
  E.db['cataarmory']['character']['enchant']['font'] = Private.Font
  E.db['cataarmory']['character']['enchant']['fontSize'] = 12

  E.db['cataarmory']['character']['itemLevel'] = E.db['cataarmory']['character']['itemLevel'] or {}

  E.db['cataarmory']['character']['itemLevel']['color'] = E.db['cataarmory']['character']['itemLevel']['color'] or {}
  E.db['cataarmory']['character']['itemLevel']['color']['g'] = 0.98823535442352
  E.db['cataarmory']['character']['itemLevel']['color']['r'] = 0.59215688705444
  E.db['cataarmory']['character']['itemLevel']['font'] = Private.Font
  E.db['cataarmory']['character']['itemLevel']['fontSize'] = 13
  E.db['cataarmory']['character']['itemLevel']['qualityColor'] = false
  E.db['cataarmory']['character']['itemLevel']['yOffset'] = 3

  E.db['cataarmory']['inspect'] = E.db['cataarmory']['inspect'] or {}
  E.db['cataarmory']['inspect']['avgItemLevel']['text']['font'] = Private.Font
  E.db['cataarmory']['inspect']['enchant']['font'] = Private.Font

  E.db['cataarmory']['inspect']['itemLevel'] = E.db['cataarmory']['inspect']['itemLevel'] or {}
  E.db['cataarmory']['inspect']['itemLevel']['color']['g'] = 1
  E.db['cataarmory']['inspect']['itemLevel']['color']['r'] = 1
  E.db['cataarmory']['inspect']['itemLevel']['font'] = Private.Font
  E.db['cataarmory']['inspect']['itemLevel']['fontSize'] = 13
  E.db['cataarmory']['inspect']['itemLevel']['qualityColor'] = false
  E.db['cataarmory']['inspect']['itemLevel']['yOffset'] = 3
end
