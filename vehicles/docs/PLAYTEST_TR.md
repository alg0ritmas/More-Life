# Build 42 Armored Scout v0.4 — game playtest
**Status: vehicle candidate, no in-game or multiplayer validation yet.**

1. Extract the ZIP and install Python 3 if needed.
2. Run BUILD_AND_INSTALL_TEST.cmd. It reads a four-seat vehicle definition from the local PZ installation, never changes base game files, and copies only this isolated mod to %USERPROFILE%\Zomboid\mods\MoreLifeVehicles.
3. Start PZ Build 42 with -debug. Activate More Life Vehicles Test Candidate in Mods and create a NEW single-player save.
4. Use the debug vehicle spawn menu to search for MoreLifeVehicles.ArmoredScout. If absent, inspect %USERPROFILE%\Zomboid\console.txt.
5. Test vehicle visibility (the first smoke test intentionally uses the original *vanilla* donor model), drive, brakes, fuel, seats, doors, trunk, save/load, durability.
6. Rare spawns at military/army zones are intended only in unvisited chunks and remain unverified.
7. Report errors with private path/IP information removed from console.txt and the locally generated .json report.
8. Do not install on your existing multiplayer server. If SP works, use a disposable 2-client dedicated server to test sync.

Do not redistribute the generated vanilla-derived vehicle script to Steam Workshop without resolving rights.
