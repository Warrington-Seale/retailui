local Private = select(2, ...)

function Private.CreateEditModeImportButtons()
  Private.EditModeLogoTexture = 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_classic1.png'

  if not EditModeImportLayoutDialog then
    return
  end

  local parent = EditModeImportLayoutDialog

  if parent.MUIButtons then
    return
  end

  local profiles = {
    {
      name = 'MerfinUI Full HD',
      data = "2 28 0 0 1 6 6 MainMenuBarArtFrame 8.0 4.0 -1 ##$$%/&('))#+#,# 0 1 1 8 7 UIParent -6.0 52.0 -1 ##$$%/&(')(#,# 0 2 1 6 7 UIParent 6.0 52.0 -1 ##$$%/&(')(#,# 0 3 1 5 5 UIParent -2.0 -35.0 -1 #$$$%/&(')(#,# 0 4 1 5 5 UIParent -2.0 -35.0 -1 #$$$%/&(')(#,# 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(')(#,# 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(')(#,# 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(')(#,# 0 10 1 6 7 UIParent -470.5 51.0 -1 ##$$&('* 0 11 1 6 7 UIParent -441.0 50.0 -1 ##$$&('+,# 0 12 1 6 7 UIParent -470.5 51.0 -1 ##$$&('* 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 0 0 UIParent -1.0 0.0 -1 3# 3 1 1 0 0 UIParent 232.0 0.0 -1 %#3# 3 2 1 0 0 UIParent 174.0 -178.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 12.0 -1 '#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 6 0 1 2 2 UIParent -187.0 -13.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -202.0 -152.0 -1 ##$#%#'+(()( 8 -1 0 7 7 UIParent -1037.5 34.0 -1 #'$A%$&7 9 -1 1 6 7 UIParent -470.5 51.0 -1 # 13 -1 1 6 7 MainMenuBarArtFrame 40.0 2.0 -1 ##$#%) 14 -1 1 8 8 MainMenuBarArtFrame -6.0 2.0 -1 ##$#%(&( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 10.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #(",
    },
    {
      name = 'MerfinUI Quad HD',
      data = "2 28 0 0 1 6 6 MainMenuBarArtFrame 8.0 4.0 -1 ##$$%/&('))#+#,# 0 1 1 8 7 UIParent -6.0 52.0 -1 ##$$%/&(')(#,# 0 2 1 6 7 UIParent 6.0 52.0 -1 ##$$%/&(')(#,# 0 3 1 5 5 UIParent -2.0 -35.0 -1 #$$$%/&(')(#,# 0 4 1 5 5 UIParent -2.0 -35.0 -1 #$$$%/&(')(#,# 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(')(#,# 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(')(#,# 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(')(#,# 0 10 1 6 7 UIParent -470.5 51.0 -1 ##$$&('* 0 11 1 6 7 UIParent -441.0 50.0 -1 ##$$&('+,# 0 12 1 6 7 UIParent -470.5 51.0 -1 ##$$&('* 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 0 0 UIParent -1.0 0.0 -1 3# 3 1 1 0 0 UIParent 232.0 0.0 -1 %#3# 3 2 1 0 0 UIParent 174.0 -178.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 12.0 -1 '#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 6 0 1 2 2 UIParent -187.0 -13.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -202.0 -152.0 -1 ##$#%#'+(()( 8 -1 0 7 7 UIParent -1037.5 34.0 -1 #'$A%$&7 9 -1 1 6 7 UIParent -470.5 51.0 -1 # 13 -1 1 6 7 MainMenuBarArtFrame 40.0 2.0 -1 ##$#%) 14 -1 1 8 8 MainMenuBarArtFrame -6.0 2.0 -1 ##$#%(&( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 10.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #(",
    },
  }

  Private.CreateImportProfileButtons(parent, profiles, nil, nil, function(info)
    return '|T' .. Private.EditModeLogoTexture .. ':14:14:0:0:64:64:4:60:4:60|t ' .. info.name
  end)
end
