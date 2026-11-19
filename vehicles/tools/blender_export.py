"""Development export only: blender -b --python vehicles/tools/blender_export.py -- INPUT.obj OUTPUT.fbx"""
import bpy
import sys
from pathlib import Path

args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
if len(args)!=2:
    raise SystemExit("Pass OBJ input and FBX output paths after --")
src,out=(Path(a).resolve() for a in args)
if not src.is_file(): raise SystemExit("Missing OBJ source")
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
if hasattr(bpy.ops.wm,'obj_import'): bpy.ops.wm.obj_import(filepath=str(src))
else: bpy.ops.import_scene.obj(filepath=str(src))
for o in bpy.context.selected_objects:
    if o.type=='MESH': o.name='MLV_ArmoredScout'
out.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.export_scene.fbx(filepath=str(out), use_selection=True, apply_unit_scale=True, axis_forward='-Z', axis_up='Y', add_leaf_bones=False)
print("Exploratory export:",out)
