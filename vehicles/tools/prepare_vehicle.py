"""Extract a native vehicle script from installed Build 42 without modifying vanilla files.
Usage: python tools/prepare_vehicle.py GAME_ROOT MOD_ROOT
"""
import argparse,json,re
from pathlib import Path
VEHICLE_RE=re.compile(r'(?<![\w])vehicle\s+([A-Za-z0-9_]+)\s*\{',re.I)
MODULE_RE=re.compile(r'(?<![\w])module\s+([A-Za-z0-9_]+)\s*\{',re.I)
def strip_comments(s): return re.sub(r'//[^\n]*',lambda m:' '*len(m.group()),s)
def block_end(text,start):
    depth=0
    for i in range(start,len(text)):
        if text[i]=='{': depth+=1
        elif text[i]=='}':
            depth-=1
            if depth==0:return i+1
    raise ValueError('Unbalanced braces')
def sections(text):
    clean=strip_comments(text);modules=[]
    for m in MODULE_RE.finditer(clean):
        modules.append((m.start(),block_end(clean,m.end()-1),m.group(1)))
    for m in VEHICLE_RE.finditer(clean):
        end=block_end(clean,m.end()-1)
        parents=[(a,b,name) for a,b,name in modules if a<m.start()<end<=b]
        if parents:yield parents[-1][2],m.group(1),text[m.start():end]
def find_donor(root,preferred):
    folder=root/'media/scripts/vehicles'
    if not folder.is_dir():raise FileNotFoundError(str(folder))
    found={}
    for path in sorted(folder.rglob('*.txt')):
        for module,name,script in sections(path.read_text(encoding='utf-8',errors='replace')):
            found[(module.lower(),name.lower())]=(path,module,name,script)
    for name in preferred:
        if ('base',name.lower()) in found:
            candidate=found['base',name.lower()]
            if re.search(r'\bseats\s*=\s*4\s*,',strip_comments(candidate[3])):return candidate
    raise ValueError('No preferred donor in installed vanilla script list')
def transform(source):
    source,n=re.subn(r'\bvehicle\s+[A-Za-z0-9_]+\s*\{','vehicle MLVArmoredScout\n{',source,count=1)
    if n!=1:raise ValueError('Missing vehicle declaration')
    model=re.search(r'(?<![\w])model\s*\{',strip_comments(source))
    if not model:raise ValueError('Missing model block')
    end=block_end(strip_comments(source),model.end()-1)
    part=source[model.start():end]
    part,n=re.subn(r'\bfile\s*=\s*[^,\n]+','file = MoreLifeVehicles.MLV_ArmoredScout',part,count=1)
    if n!=1:raise ValueError('Missing model file')
    source=source[:model.start()]+part+source[end:]
    return 'module MoreLifeVehicles\n{\n'+source+'\n}\n'
def build(root,dest,preferred=None):
    preferred=preferred or ['CarStationWagon','CarStationWagon2','SUV','OffRoad','PickUpVan','PickUpTruck']
    path,module,name,source=find_donor(root,preferred)
    target=dest/'media/scripts/vehicles/MLV_ArmoredScout.txt'
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text('// DEVELOPMENT / untested. Donor %s.%s\n'%(module,name)+transform(source),encoding='utf-8')
    info={'donor':f'{module}.{name}','donor_relative':str(path.relative_to(root)).replace('\\','/'),'generated_relative':str(target.relative_to(dest)).replace('\\','/'),'warnings':['In-game and multiplayer behavior unverified','Seat count, wheel positions, model and collision need inspection','Do not deploy on live server']}
    (dest/'mlv_generation_report.json').write_text(json.dumps(info,indent=2),encoding='utf-8')
    return info
if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('game_root',type=Path);p.add_argument('mod_root',type=Path)
    args=p.parse_args();print(json.dumps(build(args.game_root,args.mod_root),indent=2))
