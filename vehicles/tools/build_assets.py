"""Compile the original OBJ into experimental GLB and solid-color UV atlas.
Run: python vehicles/tools/build_assets.py ; requires trimesh, numpy, pillow.
This does not make a drivable Project Zomboid vehicle.
"""
from pathlib import Path
import json
import numpy as np
import trimesh
from PIL import Image, ImageDraw
ROOT=Path(__file__).resolve().parents[1]
MOD=ROOT/'Workshop/MoreLifeVehicles/Contents/mods/MoreLifeVehicles/42'
model=MOD/'media/models_X/vehicles'
texdir=MOD/'media/textures/Vehicles'
scripts=MOD/'media/scripts'
for p in (model,texdir,scripts): p.mkdir(parents=True,exist_ok=True)
colors={'chassis':(76,84,67),'cabin':(90,101,76),'hood':(79,89,71),'roof':(65,73,59),'bumper':(42,45,39),'hatch':(51,55,45),'windshield':(45,66,73),'rear_glass':(46,61,69),'side_glass':(51,70,75),'side_step':(51,52,46),'wheel':(37,39,37),'default':(112,118,98)}
idx={k:i for i,k in enumerate(colors)}
texture=Image.new('RGB',(512,512),(110,112,104)); draw=ImageDraw.Draw(texture)
for key,i in idx.items():
    col=i%4;row=i//4; color=colors[key]
    x=col*128;y=row*128
    draw.rectangle((x+2,y+2,x+125,y+125),fill=color)
    draw.rectangle((x+3,y+3,x+124,y+9),fill=tuple(min(255,int(v*1.17)) for v in color))
texture.save(texdir/'vehicle_mlv_armoredscout.png')
verts=[];triangles=[];group='default'
for ln in (ROOT/'assets/source/MLV_ArmoredScout.obj').read_text().splitlines():
    if ln.startswith('v '): verts.append([float(x) for x in ln.split()[1:4]])
    elif ln.startswith('g '): group=ln[2:].strip()
    elif ln.startswith('f '):
        face=[int(t.split('/')[0])-1 for t in ln.split()[1:]]
        for j in range(1,len(face)-1): triangles.append((face[0],face[j],face[j+1],group))
assert len(verts)==200
points=[];uv=[];faces=[]
for a,b,c,group in triangles:
    key=group.split('_')[0] if group.startswith(('wheel_','bumper_','side_glass_','side_step_')) else group
    i=idx.get(key,idx['default']);cx=(i%4+.5)/4;cy=(i//4+.5)/4
    start=len(points);points.extend([verts[a],verts[b],verts[c]])
    uv.extend([(cx-.02,1-cy-.02),(cx+.02,1-cy-.02),(cx,1-cy+.02)])
    faces.append((start,start+1,start+2))
mesh=trimesh.Trimesh(vertices=np.asarray(points),faces=np.asarray(faces),process=False)
mesh.visual=trimesh.visual.TextureVisuals(uv=np.asarray(uv),image=texture)
scene=trimesh.Scene();scene.add_geometry(mesh,geom_name='MLV_ArmoredScout')
out=model/'MLV_ArmoredScout.glb';out.write_bytes(scene.export(file_type='glb'))
(scripts/'MLV_ArmoredScout_Model.txt').write_text("""// Asset-only: not a vehicle.
module MoreLifeVehicles
{
    model MLV_ArmoredScout
    {
        mesh = vehicles/MLV_ArmoredScout,
        texture = Vehicles/vehicle_mlv_armoredscout,
        shader = vehicle,
        scale = 1.0,
    }
}
""",encoding='utf-8')
print(json.dumps({'vertices':len(verts),'triangles':len(triangles),'glb_bytes':out.stat().st_size}))
