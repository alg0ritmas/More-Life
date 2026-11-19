"""Check compiled asset structure, without claiming game compatibility."""
from pathlib import Path
from PIL import Image
import trimesh
root=Path(__file__).resolve().parents[1]
base=root/'Workshop/MoreLifeVehicles/Contents/mods/MoreLifeVehicles/42/media'
glb=base/'models_X/vehicles/MLV_ArmoredScout.glb'
png=base/'textures/Vehicles/vehicle_mlv_armoredscout.png'
definition=base/'scripts/MLV_ArmoredScout_Model.txt'
assert glb.is_file() and png.is_file() and definition.is_file()
with Image.open(png) as im: assert im.size==(512,512)
scene=trimesh.load(glb,force='scene',process=False)
assert len(scene.geometry)==1
mesh=next(iter(scene.geometry.values()))
assert len(mesh.faces)==332 and len(mesh.vertices)==996
assert mesh.visual.uv.shape==(996,2)
assert 'mesh = vehicles/MLV_ArmoredScout' in definition.read_text()
print('PASS: GLB load, 332 triangles, UV coordinates, texture, model declaration. NOT PZ runtime.')
