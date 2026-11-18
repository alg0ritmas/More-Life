# More Life — Less Waiting, More Playing

Experimental quality-of-life mod suite for Project Zomboid Build 42. Version **0.2.1 Alpha**. Single-player only. No dependencies intended.

## Features
- ML-001 Smart Inventory: selected-container batch transfers and category labels.
- ML-002 Smart Loot: five keyword profiles for the selected container.
- ML-003 Smart Learning: experimental timing hook and optional practice XP.
- ML-004 Smart Construction: materials checklist and supported action timing.
- ML-005 Smart Living: supported washing and water filling timing.
- ML-006 Smart Vehicles: condition summary and supported maintenance timing.

Routine speed choices: 1x, 1.5x, 2x, 3x, 5x, 10x, 15x, 20x (default 2x). XP: 1x, 1.5x, 2x (default 1x). Combat is not intentionally accelerated.

## Status
Alpha, not verified in the game. The original package passed a Lua 5.4 parser check, not a Kahlua/runtime test. Incompatible actions may retain native timing. Multiplayer disabled. Menus are English. Use a disposable save.
 
## Repository
The canonical Lua source and mod metadata live under Workshop/MoreLife/Contents/mods/MoreLife/42/. All six modules currently share one source file. The original release kit contains poster.png, preview.png and a duplicate local-install copy; use that kit for installation until binary assets and full packaging are uploaded here.

See [roadmap](ROADMAP.md), [changelog](CHANGELOG.md), [installation](docs/INSTALL_TR.md), [Workshop](docs/PUBLISH_TR.md), and [test plan](tests/TEST_PLAN.md).
