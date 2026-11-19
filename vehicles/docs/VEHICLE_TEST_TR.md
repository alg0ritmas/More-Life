# More Life Vehicles v0.3 — native vehicle candidate
An experimental four-seat vehicle definition is generated **on the player's own Windows machine** from an installed Build 42 vanilla SUV/OffRoad script.
Run BUILD_CANDIDATE_WINDOWS.cmd in the downloadable development ZIP (requires Python 3), or:
`python vehicles/tools/prepare_drivable_candidate.py --game "C:\\Program Files (x86)\\Steam\\steamapps\\common\\ProjectZomboid"`
Output: `vehicles/Workshop/MoreLifeVehicles/Contents/mods/MoreLifeVehicles/42/media/scripts/vehicles/mlv_armoredscout_vehicle.txt` and JSON report. The tool reads original game scripts but does not modify them.
It copies native mechanical, door, passenger, wheel and engine definitions and substitutes the body model/texture references. **This does not validate the gameplay.** In particular vehicle scripts may require adjustments for Build 42's current schema and collision/offset/scale.
The model itself remains stylized, static and early-stage. Do not install in a live multiplayer server. Do not redistribute the script produced from an installed game's copyrighted data on GitHub or Workshop until a license-safe replacement definition is written.
Acceptance: offline debug spawn with four seats, wheels, body/scale, trunk/engine/doors/damage, then two-client dedicated MP validation. Spawn distributions disabled.
