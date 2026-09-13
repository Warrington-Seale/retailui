# Raider.IO Mythic Plus, Raiding, and Recruitment

## [v202609120600](https://github.com/RaiderIO/raiderio-addon/tree/v202609120600) (2026-09-12)
[Full Changelog](https://github.com/RaiderIO/raiderio-addon/compare/v202609100600...v202609120600) [Previous Releases](https://github.com/RaiderIO/raiderio-addon/releases)

- [Raider.IO] Database Refresh  
- [Raider.IO] Classic Database Refresh  
- [Raider.IO] Classic Database Refresh  
- Minor adjustment and doc update.  
- Merge pull request #394 from KogasaPls/bugfix/tooltip-secret-unit-token  
    Match the tooltip guid to a group unit token when UnitTokenFromGUID returns nil  
- Match the tooltip guid to a group unit token when UnitTokenFromGUID returns nil  
    Unit tooltips for a party or raid member resolve to no unit token while the tooltip is being built, so the unit tooltip hook bailed and drew no score.  
