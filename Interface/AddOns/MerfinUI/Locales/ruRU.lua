local addonName, Private = ...
local L = Private.L or {}
Private.L = L

if (GAME_LOCALE or GetLocale()) ~= 'ruRU' then
  return
end

L['Welcome to the installation for %s.'] = 'Добро пожаловать на установку %s.'
L['Skip Process'] = 'Пропустить процесс'
L['Importance: |cff4beb2cOptional|r'] = 'Приоритет: |cff4beb2cНеобязательно|r'
L['Importance: |cff4beb2cHigh|r'] = 'Приоритет: |cff4beb2cВысокий|r'
L['Click the button to adjust the settings.'] = 'Нажмите кнопку, чтобы изменить настройки.'
L['Welcome'] = 'Добро пожаловать'
L['Account Settings'] = 'Настройки учетной записи'
L['Chat Settings'] = 'Настройки чата'
L['Installation Complete'] = 'Установка завершена'
L['This installer contains profiles for various addons in MerfinUI.'] =
  'Этот установщик содержит профили для различных дополнений в MerfinUI.'
L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'] =
  'Перед началом процесса установки я настоятельно рекомендую на всякий случай создать резервную копию текущей папки WTF, чтобы сохранить существующие настройки.'
L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."] =
  'Не забудьте нажать «Готово» на последнем этапе. Это перезагрузит ваш UI и применит все настройки.'
L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'] =
  'Игровой клиент World of Warcraft хранит все свои конфигурации в переменных консоли (CVars). Эти переменные управляют различными аспектами игры, включая графику, звук и пользовательский интерфейс.'
L['This step also includes settings for addons like Questie and Leatrix.'] =
  'Этот шаг также включает настройки таких дополнений, как Questie и Leatrix.'
L['Load CVars'] = 'Загрузить CVars'
L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'] =
  'Окна чата будут выглядеть следующим образом:\n\nGNL - Clog - LT - /W - LFG.'
L['Setup Chat'] = 'Настройка чата'
L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"] =
  'Нажмите кнопку ниже, чтобы применить выбранный вами макет в зависимости от вашей роли: DPS/Tank или Healer. Используйте Healer-H, если вы предпочитаете горизонтальные рамки групп (аналогично рамкам рейдов). Выберите Healer-V, если вы хотите, чтобы рамки вашей вечеринки росли вертикально. Лично я предпочитаю вертикальную компоновку, но решать вам!'
L['You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'] =
  'У вас должны быть загружены и включены эти плагины:\nAddOnSkins, ProjectAzilroka'
L['Normal Theme'] = 'Нормальная тема'
L['Dark Theme'] = 'Тёмная тема'
L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'] =
  'Здесь вы можете выбрать, как отображать боевой текст (урон, цифры исцеления и т. д.). Если вы предпочитаете обычные числа над мобами, нажмите Blizzard. Если вы предпочитаете, чтобы значения урона были сложены в одном месте, используйте xCT — либо xCT DPS/Tank, либо xCT Healer, в зависимости от вашей специализации.'
L['You have completed the installation process.'] = 'Вы завершили процесс установки.'
L['You must click the button below to finalize the process and automatically reload your UI.'] =
  'Вам необходимо нажать кнопку ниже, чтобы завершить процесс и автоматически перезагрузить UI.'
L['Finished'] = 'Готово'
L['Install'] = 'Установить'
L['Re-run the installation process.'] = 'Повторно запустите процесс установки.'
L['Action Bars'] = 'Панели действий'
L['Show Grid'] = 'Показать сетку'
L['Show Empty cells'] = 'Показать пустые ячейки'
L['Show Mouseover'] = 'Показать наведение курсора мыши'
L['Fonts and Textures'] = 'Шрифты и текстуры'
L['Shortcut to general media settings.'] = 'Ярлык к общим настройкам мультимедиа.'
L['Action Bar Settings'] = 'Настройки панели действий'
L['Click the button below to open the Action Bars options, where you can configure additional settings.'] =
  'Нажмите кнопку ниже, чтобы открыть параметры панели действий, где вы можете настроить дополнительные параметры.'
L['Shortcut to action bars settings.'] = 'Ярлык к настройкам панели действий.'
L['Media'] = 'Медиа'
L['Default Font'] = 'Шрифт по умолчанию'
L['The font that the core of the UI will use.'] = 'Шрифт, который будет использовать ядро ​​UI.'
L['Apply Font To All'] = 'Применить шрифт ко всем'
L['Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'] =
  'Применяет настройки шрифта и размера шрифта ко всему пользовательскому интерфейсу. Примечание. Некоторые настройки размера шрифта можно пропустить, поскольку по умолчанию они используют меньший размер шрифта.'
L['Default Texture'] = 'Текстура по умолчанию'
L['The texture that the core of the UI will use.'] = 'Текстура, которую будет использовать ядро ​​UI.'
L['Apply Texture To All'] = 'Применить текстуру ко всем'
L['Applies the texture across the entire user interface.'] = 'Применяет текстуру ко всему пользовательскому интерфейсу.'
L['Color Theme'] = 'Цветовая тема'
L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'] =
  'Нажмите кнопку ниже, чтобы установить цветовую тему рамок блока ElvUI.\n- Обычная тема будет включать цветные рамки классов;\n- Темная тема затемнила их и раскрасила тексты имен юнитов.'
L['Links'] = 'Ссылки'
L['Nameplates (Plater)'] = 'Паспортные таблички (Plater)'
L['Combat Text (xCT+)'] = 'Боевой текст (xCT+)'
L['Profiles (ElvUI)'] = 'Профили (ElvUI)'
L['Profile contains settings for Raid Cooldowns and Notes'] =
  'Профиль содержит настройки для рейдовых кулдаунов и примечаний.'
L['OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'] =
  'OmniCD используется для отображения времени восстановления вашей группы, разделенного на несколько категорий: самооборона, контроль, прерывания и защита рейда. В зависимости от выбранной вами планировки расположение панелей будет различаться. Используйте тот же макет, который вы выбрали в ElvUI.'
L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."] =
  'Выберите DBM, если вы предпочитаете играть с DBM, или BigWigs, если вы поклонник этого дополнения. Вы можете пропустить этот шаг, если используете мои Рейдовые Ауры, так как они уже включают в себя все необходимое для рейдов.'
L['Profile Settings'] = 'Настройки профиля'
L['Set Actual Version'] = 'Установить фактическую версию'
L['Actualize Profile Version'] = 'Актуализировать версию профиля'
L['Damage Meter (Details)'] = 'Счетчик урона (Details)'
L['Boss Mods'] = 'Моды Боссов'
L['Action Bars Visibility'] = 'Видимость панелей действий'
L['Click on the button to set action bars visibility.'] = 'Нажмите кнопку, чтобы настроить видимость панели действий.'
L['Click on the button to set color theme.'] = 'Нажмите кнопку, чтобы установить цветовую тему.'
L['Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'] =
  'Cell — это отдельное дополнение, включенное в мой пакет дополнений. Это мощный аддон для рейдовых фреймов, вдохновленный некоторыми из лучших — CompactRaid, Grid2, Aptechka и VuhDo. Благодаря удобному интерфейсу Cell предлагает более плавный и интуитивно понятный интерфейс, чем когда-либо прежде.'
L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'] =
  'Примените чистый и минималистичный профиль Details! для отслеживания повреждений, исцеления и многого другого.'
L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'] =
  'Примените мои макеты ElvUI для ролей DPS/Tank или Healer. Включает как горизонтальные, так и вертикальные макеты для рамок для вечеринок.'
L['Apply my MRT profile with raid cooldowns and notes preconfigured.'] =
  'Примените мой профиль MRT с предварительно настроенными рейдовыми кулдаунами и примечаниями.'
L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'] =
  'Примените мой профиль Plater, чтобы улучшить видимость паспортной таблички, настройку и производительность.'
L['Backdrop'] = 'фон'
L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'] =
  'Выберите боевой текст по умолчанию Blizzard или профили xCT для более компактных и настраиваемых номеров.'
L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'] =
  'Выбирайте профили DBM или BigWigs, созданные для рейдерства. Рекомендуется, если вы не используете мои Raid Auras.'
L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'] =
  'Выбирайте между рейдовыми рамками Cell или ElvUI и применяйте оптимизированные макеты для рейдов и подземелий.'
L['Combat Text'] = 'Боевой текст'
L['Dead'] = 'Мертвый'
L['Details'] = 'Details'
L['Ignore Modules'] = 'Игнорировать модули'
L['Installation Settings'] = 'Настройки установки'
L['Main'] = 'Основной'
L['Movers'] = 'Фреймы-перемещатели'
L['Player Castbar'] = 'Полоса заклинаний игрока'
L['Preferable Resolution'] = 'Предпочтительное разрешение'
L['Profiles'] = 'Профили'
L['Raid Frames'] = 'Рейд-фреймы'
L['Re quick installation process.'] = 'Повторный быстрый процесс установки.'
L['Reset to Defaults'] = 'Сброс к настройкам по умолчанию'
L['Set Default MerfinUI settings'] = 'Установить настройки MerfinUI по умолчанию'
L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'] =
  'Установите для важной игры и дополнения CVars рекомендуемые значения для улучшения визуального оформления, производительности и удобства использования.'
L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'] =
  'Настройте OmniCD для отображения групповых кулдаунов (защита, прерывания, рейды) с макетами, соответствующими вашему UI.'
L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'] =
  'Настройте окна чата с предварительно настроенными вкладками для общего, боевого журнала, шепота и группового контента.'
L['Set your action bars to always show or appear on mouseover.'] =
  'Настройте панели действий так, чтобы они всегда отображались или появлялись при наведении курсора мыши.'
L['Show Always'] = 'Показать всегда'
L['Show the Player Cast Bar provided by ElvUI.'] = 'Покажите панель актеров игрока, предоставленную ElvUI.'
L['Switch between Normal and Dark color themes for the UI.'] =
  'Переключайтесь между обычными и темными цветовыми темами для UI.'
L['UI Install'] = 'UI Установить'
L['UI Quick Install'] = 'UI Быстрая установка'
L['Unit Frames'] = 'Рамки юнитов'
L['You can install the profile from this section as an alternative to the installer.'] =
  'Вы можете установить профиль из этого раздела как альтернативу установщику.'
L['Target Debuffs'] = 'Целевые ослабления'
L['Enable or disable debuffs on the target frame.'] = 'Включите или отключите дебаффы на целевом кадре.'
L['Profile contains settings for Cooldown Manager Centered.'] = 'Профиль содержит настройки для Cooldown Manager Centered.'
L['Profile contains settings for SenseiClassResourceBar.'] = 'Профиль содержит настройки для SenseiClassResourceBar.'
L['Applies the Skyriding Bar profile for your selected layout.'] = 'Применяет профиль Skyriding Bar для выбранного макета.'
L['Profile contains settings for Simple Assisted Combat Icon.'] = 'Профиль содержит настройки для Simple Assisted Combat Icon.'
L['Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'] =
  'Показывает те же предложения, что и Single-Button-Assistant. Из-за изменений Blizzard на данный момент это единственный возможный помощник вращения (RIP Hekili). Полезно для изучения вашего класса/специализации.'
L['%s import failed: %s'] = 'Не удалось импортировать %s: %s.'
L['%s installed.'] = '%s установлен.'
L['%s is not available. Please enable it and reload your UI.'] = '%s недоступен. Пожалуйста, включите его и перезагрузите UI.'
L['%s profile installed.'] = 'Профиль %s установлен.'
L['%s profile installed: %s'] = 'Установлен профиль %s: %s'
L['%s profiles installed.'] = 'Установлены профили %s.'
L["ATM Classic Era/SoD doesn't support xCT."] = 'ATM Classic Era/SoD не поддерживает xCT.'
L["ATM Classic Vanilla doesn't support xCT."] = 'ATM Classic Vanilla не поддерживает xCT.'
L['Cell (DPS/Tank)'] = 'Cell (DPS/Tank)'
L['Cell (Healer)'] = 'Cell (Healer)'
L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'] =
  'Cell — это отдельное дополнение, включенное в мой пакет дополнений. Это мощный аддон для рейдовых фреймов, вдохновленный CompactRaid, Grid2, Aptechka и VuhDo. Cell благодаря удобному интерфейсу предлагает плавный и интуитивно понятный интерфейс.'
L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'] =
  'Выберите, как будет отображаться боевой текст. Используйте Blizzard для плавающих чисел по умолчанию или xCT, если вы предпочитаете компактную прокрутку урона и исцеляющего текста.'
L['Cooldown Manager'] = 'Cooldown Manager'
L['Cooldown Manager Centered'] = 'Cooldown Manager Centered'
L['Copied!'] = 'Скопировано!'
L['Current Layout: |cff00c0ff%s|r'] = 'Текущий макет: |cff00c0ff%s|r'
L['Current Layout: |cff00ff00%s|r'] = 'Текущий макет: |cff00ff00%s|r'
L['DPS/Tank'] = 'DPS/Tank'
L['Edit Mode'] = 'Режим редактирования'
L['Edit Mode is not available.'] = 'Режим редактирования недоступен.'
L['ElvUI Frames'] = 'Фреймы ElvUI'
L['Healer'] = 'Healer'
L['Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'] =
  'Импортируйте или выберите правильный макет режима редактирования, чтобы элементы чата и UI располагались правильно.'
L['Method Raid Tools'] = 'Method Raid Tools'
L['Open Edit Mode'] = 'Открыть режим редактирования'
L['Please make sure the correct profile is selected, or parts of the UI may be misplaced.'] =
  'Убедитесь, что выбран правильный профиль, иначе части UI могут оказаться не на своем месте.'
L['Profile version was updated to v%s.'] = 'Версия профиля обновлена ​​до v%s.'
L['Quick Install'] = 'Быстрая установка'
L['Reload required. Continue?'] = 'Требуется перезагрузка. Продолжать?'
L['Sensei Class Resource Bar'] = 'Sensei Class Resource Bar'
L['Settings are applied directly to your Edit Mode profile.'] =
  'Настройки применяются непосредственно к вашему профилю режима редактирования.'
L['Show Import Buttons'] = 'Показать кнопки импорта'
L['Game Menu'] = 'Игровое меню'
L['Show MerfinUI Button'] = 'Показать кнопку MerfinUI'
L['Shows the MerfinUI button in the Game Menu.'] = 'Показывает кнопку MerfinUI в игровом меню.'
L['Shows import buttons next to the Cooldown Manager import window.'] = 'Показывает кнопки импорта рядом с окном импорта Cooldown Manager.'
L['Shows import buttons next to the Edit Mode import window.'] =
  'Показывает кнопки импорта рядом с окном импорта в режиме редактирования.'
L['Skyriding Falcon'] = 'Skyriding Falcon'
L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."] =
  'Этот установщик быстро настроит все дополнения и профили (кроме WeakAuras, поскольку ни один полный установщик в настоящее время не поддерживает WeakAuras). Всего одним щелчком мыши все будет настроено с последующей перезагрузкой в ​​конце. Если вы не уверены, рассмотрите возможность использования стандартного установщика.'
L['Unknown'] = 'Неизвестный'
L['Welcome to the Quick installation for %s.'] = 'Добро пожаловать в раздел быстрой установки %s.'
L['You need to enable %s first.'] = 'Сначала вам нужно включить %s.'
L['You need to enable %s to apply profile settings.'] = 'Вам необходимо включить %s, чтобы применить настройки профиля.'
L['You need to enable %s.'] = 'Вам необходимо включить %s.'
L['Edit Mode layout imported and saved as %s.'] = 'Макет режима редактирования импортирован и сохранен как %s.'
L['Failed to import Edit Mode layout.'] = 'Не удалось импортировать макет режима редактирования.'
L['Class'] = 'Класс'
L['Class Theme'] = 'Классовая тема'
L['Dark'] = 'Темный'
L['Installation'] = 'Установка'
L['Quick Installation'] = 'Быстрая установка'
L['Dark Theme Applied'] = 'Применена темная тема'
L['Normal Theme Applied'] = 'Применена нормальная тема'
L['Blizzard Combat Text'] = 'Blizzard Боевой текст'
L['Socials'] = 'Соцсети'
L['AddOns'] = 'Модификации'
L['SUB CONTENT'] = 'КОНТЕНТ ПО ПОДПИСКЕ'
L['WeakAuras Package'] = 'Пакет WeakAuras'
L['Class Auras, General Auras, Raid Packs, and more.'] =
  'Классовые и общие ауры, рейдовые пакеты и многое другое.'
