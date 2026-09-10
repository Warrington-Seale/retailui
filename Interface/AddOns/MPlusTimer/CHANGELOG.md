# MPlusTimer

## [1.0.42](https://github.com/Reloe/MPlusTimer/tree/1.0.42) (2026-08-04)
[Full Changelog](https://github.com/Reloe/MPlusTimer/compare/1.0.41...1.0.42) [Previous Releases](https://github.com/Reloe/MPlusTimer/releases)

- make langauges always appear in their native language  
- Merge pull request #25 from CN2714/main  
    Update zhCN & Fix AceLocale "Missing entry" localization errors in MPlusTimer options for non-English locales (remove double localization)  
- Fix AceLocale "Missing entry" localization errors in MPlusTimer options for non-English locales (remove double localization)  
    Error Cause  
    All call sites of CreateTextSetting / CreateStatusBarSettings in UI.lua passed L["..."] (an already-translated string) as the name parameter, while the function internally performs a second lookup via L[name].  
    On enUS, AceLocale converts true back to the key itself, so L["PB Info"] returns "PB Info" (key == value) and the lookup "accidentally" succeeds.  
    On zhCN / deDE / koKR / ruRU, L["PB Info"] returns the translated value (e.g. "个人最佳信息"), which is not a key in the locale table, triggering AceLocale's \_\_index metamethod → Missing entry for '...'.  
    Impact  
    In non-English locales, every setting item fires one Missing entry error each time the options panel renders its tree (AceLocale caches via rawset, so the same key only warns once per session — hence the 1x in logs).  
    Only produces error logs; actual display behavior is unaffected (the fallback still returns the original translated value).  
    The fix uniformly passes the raw key string, letting the function's internal L[name] do the translation — behavior is identical to before.  
- Update zhCN.lua  
    update zhCN  
- Merge pull request #24 from Hollicsh/main  
    Update ruRU.lua  
- Update ruRU.lua  