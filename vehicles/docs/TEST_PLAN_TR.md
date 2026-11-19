# More Life Vehicles — test plan
At this point only the asset source, metadata and development scripts are available. `tests/validate.py` verifies model face indices, metadata and project paths, **not** Project Zomboid gameplay.

Required next tasks:
1. Blender UV atlas, separate rolling wheel meshes and correct game axis/scale.
2. Make game-compatible FBX/model script, vehicle script, custom parts and seat/door definitions using the user's installed B42.22.2 vanilla scripts as reference.
3. Check offline debug-spawn, physics, capacity, damage, engine, doors and 4 seats.
4. Test two players in a disposable dedicated server, including disconnect and restart.
5. Only then allow Workshop test release. Do not install to a live server.
