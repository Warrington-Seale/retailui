
local L, addon, ns = {}, ...;
ns.L = setmetatable(L,{__index=function(t,k)
	local v = tostring(k);
	rawset(t,k,v);
	return v;
end});

L["CmdListInfo1"] = "Realm info.";
L["CmdListInfo2"] = "Example: /ttri info Area 52";

-- Do you want to help localize this addon?
-- https://www.curseforge.com/wow/addons/@cf-project-name@/localization

L["AddOnLoaded"] = "AddOn loaded..."
L["AddOnLoadedDesc"] = "Show 'AddOn Loaded...' message on logins and UI reloads."
L["AddOnLoadedDescAlt"] = "Alternatively you can hold shift key on loading screen to display this message for this login only."
L["battlegroup"] = "battlegroup"
L["CmdListInfo"] = "Chat command list for /ttri or /tooltiprealminfo"
L["CmdListLoadedMsg"] = "Toggle 'AddOn loaded...' message"
L["CmdListOptHide"] = "Hide %s in tooltip"
L["CmdListOptions"] = "Open option panel"
L["CmdListOptShow"] = "Show %s in tooltip"
L["CmdLoadedMsg"] = "'AddOn loaded...' message:"
L["CmdNowIsHidden"] = "Tooltip line '%s' is now hidden"
L["CmdNowIsShown"] = "Tooltip line '%s' is now shown"
L["CmdOnLoadInfo"] = "For options use /ttri or /tooltiprealminfo"
L["CmdSlashStringLong"] = "/tooltiprealminfo"
L["CmdSlashStringShort"] = "/ttri"
L["CtryFlg"] = "Country flag"
L["CtryFlgChatDesc1"] = "For which chat types should the country flags be shown?"
L["CtryFlgChatDesc2"] = "For which languages should the country flags be shown?"
L["CtryFlgChatHeader"] = "Country flags in chat messages"
L["CtryFlgCommDesc"] = "Prepend country flag on character name in community member lists"
L["CtryFlgDesc"] = "Display the country flag without text on the left side in tooltip"
L["CtryFlgGrpFndrDesc"] = "Prepend country flag on character name in group finder"
L["CtryFlgSelLang"] = "Behind language in 'Realm language' line"
L["CtryFlgSelName"] = "Behind the character name"
L["CtryFlgSelOwn"] = "In own tooltip line on the left site"
L["CtryFlgTipTacInfo"] = "(Currently doesn't work with TipTac)"
L["RlmConn"] = "Connected realms"
L["RlmInfoDesc"] = "You can \"Enable\" or \"Disable\" this option. Or you choose a modifier key to be held for visibility of this line in tooltip. But you must hold the key before tooltip will be displayed or you must move the mouse short out of area of the reason for the tooltip."
L["RlmLang"] = "Realm language"
L["RlmPvPGrp"] = "Realm battlegroup"
L["RlmType"] = "Realm type"
L["RlmTZ"] = "Realm timezone"
L["timezone"] = ""
L["Tooltip"] = "Tooltip"
L["TTDisplay"] = "Tooltips"
L["TTDisplayDesc"] = "Add informations to following tooltips."
L["TTDisplayFriends"] = "Friend list"
L["TTDisplayGrpFinder"] = "Group finder tooltips"
L["TTDisplayPlayer"] = "Player tooltips"
L["TTLines"] = "Tooltip lines"
L["TTLinesDesc"] = "Add following information to choosen tooltips."

if LOCALE_deDE then
L["AddOnLoaded"] = "AddOn geladen..."
L["AddOnLoadedDesc"] = "Zeigt die Nachricht 'AddOn geladen...' beim Einloggen und Neuladen des UIs."
L["AddOnLoadedDescAlt"] = "Alternativ kannst du die Umschalt-Taste beim Ladebildschirm gedrückt halten zum anzeigen der Nachricht nur diesen Login."
L["battlegroup"] = "Schlachtgruppe"
L["CmdListInfo"] = "Chatbefehlsliste für /ttri oder /tooltiprealminfo"
L["CmdListLoadedMsg"] = "Die Nachricht \"Addon geladen\" ein-/ausschalten"
L["CmdListOptHide"] = "%s im Tooltip verstecken"
L["CmdListOptions"] = "Öffne Optionpanel"
L["CmdListOptShow"] = "%s im Tooltip zeigen"
L["CmdLoadedMsg"] = "'Addon geladen...' Nachricht:"
L["CmdNowIsHidden"] = "Tooltipzeile '%s' wird jetzt versteckt"
L["CmdNowIsShown"] = "Tooltipzeile '%s' wird jetzt gezeigt"
L["CmdOnLoadInfo"] = "Gib /ttri oder /tooltiprealminfo ein, um zu den Optionen zu gelangen"
L["CmdSlashStringLong"] = "/tootiprealminfo"
L["CmdSlashStringShort"] = "/ttri"
L["CtryFlg"] = "Landesflagge"
L["CtryFlgChatDesc1"] = "Für welche Chat-Typen sollen die Landesflaggen angezeigt werden?"
L["CtryFlgChatDesc2"] = "Für welche Sprachen sollen die Landesflaggen angezeigt werden?"
L["CtryFlgChatHeader"] = "Landesflaggen in Chatnachrichten"
L["CtryFlgCommDesc"] = "Die Landesflagge dem Charakternamen voranstellen in Community Mitgliederlisten"
L["CtryFlgDesc"] = "Zeige Landesflagge ohne Text auf der rechten Seite im Tooltip"
L["CtryFlgGrpFndrDesc"] = "Die Landesflagge dem Charakternamen voranstellen in der Gruppensuche"
L["CtryFlgSelLang"] = "Hinter der Sprache in der Zeile 'Realmsprache'"
L["CtryFlgSelName"] = "Hinter dem Charakternamen"
L["CtryFlgSelOwn"] = "In eigener Tooltipzeile auf der rechten Seite"
L["CtryFlgTipTacInfo"] = "(Funktioniert zurzeit nicht mit TipTac)"
L["RlmConn"] = "Verbundene Realms"
L["RlmInfoDesc"] = "Sie können diese Option \"Aktivieren\" oder \"Deaktivieren\". Oder Sie wählen eine Modifizierertaste, die für die Sichtbarkeit dieser Zeile im Tooltip gehalten werden soll. Sie müssen jedoch die Taste gedrückt halten, bevor der Tooltip angezeigt wird, oder Sie müssen die Maus kurz aus dem Bereich des Grunds für den Tooltip bewegen."
L["RlmLang"] = "Realmsprache"
L["RlmPvPGrp"] = "Realm Schlachtgruppe"
L["RlmType"] = "Realmtyp"
L["RlmTZ"] = "Realmzeitzone"
L["timezone"] = "Zeitzone"
L["Tooltip"] = "Tooltip"
L["TTDisplay"] = "Tooltips"
L["TTDisplayDesc"] = "Informationen an folgende Tooltips anheften."
L["TTDisplayFriends"] = "Freundesliste"
L["TTDisplayGrpFinder"] = "Gruppenfinder-Tooltips"
L["TTDisplayPlayer"] = "Spielertooltips"
L["TTLines"] = "Tooltipzeilen"
L["TTLinesDesc"] = "Fügt folgende Informationen den gewählten Tooltips hinzu."

elseif LOCALE_esES then
L["AddOnLoaded"] = "Complemento cargado..."
L["battlegroup"] = "Grupo"
L["CmdListInfo"] = "Comandos de chat en /ttri o /tooltiprealminfo"
L["CmdListOptHide"] = "Ocultar %s en ventana emergente"
L["CmdListOptShow"] = "Mostrar %s en ventana emergente"
L["CmdNowIsHidden"] = "'%s' se ha ocultado de la ventana emergente"
L["CmdNowIsShown"] = "'%s' ya se muestra en la ventana emergente"
L["CmdOnLoadInfo"] = "Para ver las opciones utilice /ttri o /tooltiprealminfo"
L["RlmLang"] = "Idioma del servidor"
L["RlmPvPGrp"] = "Grupo de servidores"
L["RlmType"] = "Tipo de servidor"
L["RlmTZ"] = "Zona horaria del servidor"
L["timezone"] = "zona horaria"

elseif LOCALE_esMX then

elseif LOCALE_frFR then
L["AddOnLoaded"] = "Add-on chargé"
L["battlegroup"] = "Corps de Bataille"
L["CmdListInfo"] = "Liste de commandes pour /ttri ou /tooltiprealminfo"
L["CmdListLoadedMsg"] = "Afficher/masquer le message \"Add-on chargé\""
L["CmdListOptHide"] = "Masquer %s dans l'info-bulle"
L["CmdListOptions"] = "Ouvrir le panneau d'options"
L["CmdListOptShow"] = "Afficher %s dans l'info-bulle"
L["CmdLoadedMsg"] = "Message \"Add-on chargé\" :"
L["CmdNowIsHidden"] = "La ligne d'info '%s' est maintenant masquée"
L["CmdNowIsShown"] = "La ligne d'info '%s' est maintenant affichée"
L["CmdOnLoadInfo"] = "Pour les options, tapez /ttri ou /tooltiprealminfo"
L["CmdSlashStringLong"] = "/tooltiprealminfo"
L["CmdSlashStringShort"] = "/ttri"
L["CtryFlg"] = "Drapeau"
L["CtryFlgDesc"] = "Afficher le drapeau sans le texte du côté gauche de l'info-bulle"
L["CtryFlgGrpFndrDesc"] = "Mettre le drapeau devant le nom"
L["CtryFlgSelLang"] = "Derrière la langue dans la ligne \"Langue du Royaume\""
L["CtryFlgSelName"] = "Derrière le nom du personnage"
L["CtryFlgTipTacInfo"] = "(Ne fonctionne actuellement pas avec TipTac)"
L["RlmConn"] = "Royaumes connectés"
L["RlmLang"] = "Langue du Royaume"
L["RlmPvPGrp"] = "Corps de Bataille du Royaume"
L["RlmType"] = "Type de Royaume"
L["RlmTZ"] = "Fuseau horaire du Royaume"
L["timezone"] = "Fuseau horaire"
L["Tooltip"] = "Info-bulle"
L["TTDisplay"] = "Choisir les info-bulles"

elseif LOCALE_itIT then

elseif LOCALE_koKR then

elseif LOCALE_ptBR or LOCALE_ptPT then

elseif LOCALE_ruRU then
L["AddOnLoaded"] = "Аддон загружен..."
L["AddOnLoadedDesc"] = "Показывать сообщение 'Аддон загружен...' при входе в систему и при перезагрузке пользовательского интерфейса."
L["AddOnLoadedDescAlt"] = "Также Вы можете удерживать клавишу Shift на экране загрузки, чтобы отобразить это сообщение только для этого входа в систему."
L["battlegroup"] = "боевая группа"
L["CmdListInfo"] = "Список команд чата - /ttri или /tooltiprealminfo"
L["CmdListLoadedMsg"] = "Переключить сообщение 'Аддон загружен ...'"
L["CmdListOptHide"] = "Скрыть %s во всплывающей подсказке"
L["CmdListOptions"] = "Открыть панель опций"
L["CmdListOptShow"] = "Показать %s во всплывающей подсказке"
L["CmdLoadedMsg"] = "'Аддон загружен...' сообщение:"
L["CmdNowIsHidden"] = "Строка всплывающей подсказки '%s' теперь скрыта"
L["CmdNowIsShown"] = "Строка всплывающей подсказки '%s' теперь отображается"
L["CmdOnLoadInfo"] = "Для опций используйте - /ttri или /tooltiprealminfo"
L["CmdSlashStringLong"] = "/tooltiprealminfo"
L["CmdSlashStringShort"] = "/ttri"
L["CtryFlg"] = "Флаг страны"
L["CtryFlgChatDesc1"] = "Для каких типов чатов следует показывать флаги стран?"
L["CtryFlgChatDesc2"] = "Для каких языков должны отображаться флаги стран?"
L["CtryFlgChatHeader"] = "Флаги стран в сообщениях чата"
L["CtryFlgCommDesc"] = "Добавить флаг страны к имени персонажа в списках участников сообщества"
L["CtryFlgDesc"] = "Отображать флаг страны без текста слева во всплывающей подсказке"
L["CtryFlgGrpFndrDesc"] = "Добавить флаг страны к имени персонажа в поиске группы"
L["CtryFlgSelLang"] = "За языком в строке 'Язык игрового мира'"
L["CtryFlgSelName"] = "За именем персонажа"
L["CtryFlgSelOwn"] = "В собственной строке всплывающей подсказки с левой стороны"
L["CtryFlgTipTacInfo"] = "(В настоящее время не работает с TipTac)"
L["RlmConn"] = "Подключенные миры"
L["RlmInfoDesc"] = "Вы можете Включить или Отключить эту опцию. Или выбрать клавишу-модификатор, которую нужно удерживать для отображения этой строки во всплывающей подсказке. Но Вы должны удерживать клавишу до того, как всплывающая подсказка будет отображена, или Вы должны переместить мышь за пределы области причины всплывающей подсказки."
L["RlmLang"] = "Язык игрового мира"
L["RlmPvPGrp"] = "Боевая группа игрового мира"
L["RlmType"] = "Тип игрового мира"
L["RlmTZ"] = "Часовой пояс игрового мира"
L["timezone"] = "Часовой пояс"
L["Tooltip"] = "Подсказка"
L["TTDisplay"] = "Подсказки"
L["TTDisplayDesc"] = "Добавить информацию в следующие всплывающие подсказки"
L["TTDisplayFriends"] = "Список друзей"
L["TTDisplayGrpFinder"] = "Подсказки для поиска групп"
L["TTDisplayPlayer"] = "Подсказки игрока"
L["TTLines"] = "Строки всплывающих подсказок"
L["TTLinesDesc"] = "Добавить следующую информацию к выбранным всплывающим подсказкам."

elseif LOCALE_zhCN then

elseif LOCALE_zhTW then

end

L["type"]=TYPE;
L["language"]=LANGUAGE;
L["connectedrealms"] = L["Connected realms"];
