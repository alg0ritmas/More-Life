# More Life Vehicles — independent vehicle series
First project: **MLV Armored Scout 4x4**, an original four-seat low-poly concept for Project Zomboid Build 42.22.2. Separate mod ID: `MoreLifeVehicles` (the More Life quality-of-life mod remains independent).

**STATUS: non-playable development source.** There is no PZ-compatible exported/validated model, vehicle script, spawn distribution, UV map or wheel animation. Do not advertise this as a drivable vehicle or install it on the production multiplayer server. The complete source model and Blender export helper are included in the separately generated Development Kit ZIP shared in ChatGPT.

Targets: four seats; moderate destructible armor; gasoline; rare military-zone spawn; four wheels; standard native vehicle replication; no client spawn commands and no mounted weapons in v0.1. Assets are original and avoid importing other mod authors' models.

Workflow: finish Blender export and UVs -> match native B42 vehicle script and model definition -> register on test map -> offline spawn tests -> two-client dedicated MP tests -> Workshop release.

Useful references:
- https://wenopal.work/en/guides/vehicles.html
- https://github.com/PZ-Wiki-Modding/PZ-API-Docs/blob/main/docs/source/scripts/model.rst

The development ZIP contains `assets/source/MLV_ArmoredScout.obj`, `tools/blender_export.py`, `vehicle_spec.json`, `tests/validate.py` and the B42 Mod ID scaffold.
