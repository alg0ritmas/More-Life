import json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
spec=json.loads((root/'vehicle_spec.json').read_text())
assert spec['mod_id']=='MoreLifeVehicles'
assert spec['seats']==4 and spec['wheels']==4
assert spec['status']=='asset-compiled-not-playable'
mesh=(root/'assets/source/MLV_ArmoredScout.obj').read_text().splitlines()
v=[line for line in mesh if line.startswith('v ')]
f=[line for line in mesh if line.startswith('f ')]
assert len(v)==200 and len(f)==134
for face in f:
    for index in face.split()[1:]: assert 1<=int(index)<=len(v)
info=(root/'Workshop/MoreLifeVehicles/Contents/mods/MoreLifeVehicles/42/mod.info').read_text()
assert 'id=MoreLifeVehicles' in info
print('PASS: geometry, script config and metadata. NOT GAMEPLAY.')
