# More Life Vehicles — independent vehicle series
First project: **MLV Armored Scout 4x4**, an original four-seat low-poly concept for Project Zomboid Build 42.22.2. Separate mod ID: `MoreLifeVehicles` (the More Life quality-of-life mod remains independent).

**STATUS: non-playable development source; native script candidate generator available.** An experimental GLB + diffuse texture + model declaration can be built from source, but has not been verified by the game. There is no vehicle script, spawn distribution or wheel animation. Do not advertise this as a drivable vehicle or install it on the production multiplayer server. The complete source model and Blender export helper are included in the separately generated Development Kit ZIP shared in ChatGPT.

Targets: four seats; moderate destructible armor; gasoline; rare military-zone spawn; four wheels; standard native vehicle replication; no client spawn commands and no mounted weapons in v0.1. Assets are original and avoid importing other mod authors' models.

Workflow: test GLB and texture in game -> match native B42 vehicle script and model definition -> register on test map -> offline spawn tests -> two-client dedicated MP tests -> Workshop release.

Useful references:
- https://wenopal.work/en/guides/vehicles.html
- https://github.com/PZ-Wiki-Modding/PZ-API-Docs/blob/main/docs/source/scripts/model.rst

The development ZIP contains `assets/source/MLV_ArmoredScout.obj`, `tools/blender_export.py`, `vehicle_spec.json`, `tests/validate.py` and the B42 Mod ID scaffold.

## Asset milestone v0.2
Reproducible GLB and diffuse atlas builder: `python vehicles/tools/build_assets.py`; static model has 332 triangles and a 512x512 atlas. Validator: `python vehicles/tests/validate_assets.py`. The downloadable ZIP shared in ChatGPT includes generated binary assets; GitHub stores the reproducible generator and source OBJ. Not yet a drivable car.

## v0.3 vehicle candidate generator
A Windows script (`BUILD_VEHICLE_TEST.cmd`) now extracts a stock vehicle definition from the user's own B42 installation, preserving physics, wheel and seat definitions while changing the vehicle ID and body mesh reference. The GitHub version includes the converter and fixture tests, not proprietary game data. It does not auto-spawn and has not passed any in-game test. See `docs/DRIVABLE_CANDIDATE_TR.md`.

## v0.3 candidate generator
`tools/prepare_drivable_candidate.py` reads an SUV/OffRoad/Pickup vehicle definition from the user's local Build 42 game installation, requires four passengers, and produces a new namespaced experimental vehicle script pointing to the MLV model. It preserves the native base parts as a testing scaffold. It does not modify game files or prove the vehicle works. **Do not redistribute generated vanilla-derived scripts**; use only locally for game development tests. Windows helper: `BUILD_CANDIDATE_WINDOWS.cmd`. See [test guide](docs/VEHICLE_TEST_TR.md).

## v0.4 — first playable-candidate test gate
The ZIP `MoreLifeVehicles-ArmoredScout-v0.4-Playtest-Candidate.zip` includes a generated-from-local-vanilla, four-seat vehicle candidate (generator + installer) and optional very-rare military/army world-zone registration. First test intentionally retains native donor model and skins, isolating driving/seat verification from untested GLB rendering. Offline tests passed; gameplay and MP unverified. Run `BUILD_AND_INSTALL_TEST.cmd` and follow `docs/PLAYTEST_TR.md`. Do not deploy to a production server or redistribute generated native game scripts.
