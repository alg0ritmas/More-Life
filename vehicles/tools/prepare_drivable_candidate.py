#!/usr/bin/env python3
"""Generate an experimental Build 42 vehicle definition from the user's installed vanilla game.
No game data is modified. Generated copyrighted native content is never committed to GitHub.
"""
import argparse, json, re
from pathlib import Path
MODULE="MoreLifeVehicles"
def mask_comments(src):
    out=list(src); i=0; mode="normal"
    while i<len(src):
        c=src[i]; n=src[i+1] if i+1<len(src) else ""
        if mode=="normal":
            if c=='"': mode="string"
            elif c=="/" and n=="/":
                out[i]=out[i+1]=" "; i+=2
                while i<len(src) and src[i]!="\n": out[i]=" "; i+=1
                continue
            elif c=="/" and n=="*": out[i]=out[i+1]=" "; mode="comment"; i+=2; continue
        elif mode=="string":
            if c=="\\": i+=2; continue
            if c=='"': mode="normal"
        elif mode=="comment":
            out[i]=" "
            if c=="*" and n=="/": out[i+1]=" "; i+=2; mode="normal"; continue
        i+=1
    if mode=="comment": raise ValueError("Unterminated comment")
    return "".join(out)
def block(src,pos):
    scan=mask_comments(src)
    if scan[pos]!="{": raise ValueError("Expected brace")
    depth=0; quoted=False
    for i in range(pos,len(scan)):
        if scan[i]=='"' and (i==0 or scan[i-1]!="\\"): quoted=not quoted
        if quoted: continue
        if scan[i]=="{": depth+=1
        elif scan[i]=="}":
            depth-=1
            if depth==0:return src[pos:i+1],i+1
    raise ValueError("Unbalanced vehicle definition")
def vehicles(src):
    clean=mask_comments(src); found={}
    for match in re.finditer(r"\bvehicle\s+([A-Za-z_]\w*)\s*\{",clean):
        if match.group(1) not in found:
            found[match.group(1)]=block(src,clean.find("{",match.start()))[0]
    return found
def seats(body):
    return len(re.findall(r"\bpassenger\s+[A-Za-z_]\w*\s*\{",mask_comments(body)))
def field(data,name,value):
    pattern=r"(?m)^(\s*"+re.escape(name)+r"\s*=\s*)([^,\r\n]+)"
    return re.subn(pattern,lambda m:m.group(1)+value,data,count=1)
def rewrite(body):
    clean=mask_comments(body)
    match=re.search(r"\bmodel\s*(?:[A-Za-z0-9_]+)?\s*\{",clean)
    if not match: raise ValueError("Reference has no model block")
    start=clean.find("{",match.start()); old,end=block(body,start)
    new,count=field(old,"file",MODULE+".MLV_ArmoredScout")
    if count!=1: raise ValueError("Model block lacks file=")
    body=body[:start]+new+body[end:]
    replacements=0
    for match in list(re.finditer(r"\bskin\s*\{",mask_comments(body)))[::-1]:
        start=mask_comments(body).find("{",match.start())
        old,end=block(body,start)
        new,count=field(old,"texture","Vehicles/vehicle_mlv_armoredscout")
        if count:
            replacements+=1;body=body[:start]+new+body[end:]
    script="module MoreLifeVehicles\n{\n    imports\n    {\n        Base\n    }\n    vehicle ArmoredScout\n    "+body+"\n}\n"
    return script,replacements
def build(source,vehicle,out):
    definitions=vehicles(source.read_text(encoding="utf-8-sig",errors="replace"))
    if vehicle not in definitions:raise ValueError("Vehicle not found: "+vehicle)
    body=definitions[vehicle]
    if seats(body)!=4:raise ValueError("%d passenger definitions; expected four"%seats(body))
    script,skins=rewrite(body)
    out.parent.mkdir(parents=True,exist_ok=True)
    out.write_text(script,encoding="utf-8")
    result={"native_reference":source.name,"native_vehicle":vehicle,"seats":4,"skins_patched":skins,"mod_id":"MoreLifeVehicles","vehicle_id":"MoreLifeVehicles.ArmoredScout","status":"NOT_GAME_TESTED"}
    out.with_suffix(".json").write_text(json.dumps(result,indent=2),encoding="utf-8")
    return result
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--game",type=Path,required=True)
    p.add_argument("--source",type=Path)
    p.add_argument("--vehicle")
    p.add_argument("--out",type=Path,default=Path(__file__).resolve().parents[1]/"Workshop/MoreLifeVehicles/Contents/mods/MoreLifeVehicles/42/media/scripts/vehicles/mlv_armoredscout_vehicle.txt")
    a=p.parse_args(); game=(a.game/"media/scripts").resolve()
    if not game.is_dir():p.error("Game media/scripts not found")
    if a.source:
        source=a.source.resolve()
        if not source.is_relative_to(game):p.error("Reference must be inside game scripts")
        found=vehicles(source.read_text(encoding="utf-8-sig",errors="replace"))
        name=a.vehicle or next((x for x in found if "suv" in x.lower()),None)
        if not name:p.error("Specify --vehicle")
    else:
        candidates=[]
        for directory in (game/"generated/vehicles",game/"vehicles"):
            if not directory.is_dir():continue
            for source in sorted(directory.rglob("*.txt")):
                found=vehicles(source.read_text(encoding="utf-8-sig",errors="replace"))
                for name,body in found.items():
                    if seats(body)==4 and any(x in name.lower() for x in ("suv","offroad","pickup","jeep")):
                        candidates.append((source,name))
        if not candidates:p.error("No compatible four-seat vanilla reference")
        candidates.sort(key=lambda x:(not "suv" in x[1].lower(),x[1]))
        source,name=next(((src,n) for src,n in candidates if n==a.vehicle),candidates[0]) if a.vehicle else candidates[0]
    print(json.dumps(build(source,name,a.out),indent=2))
    print("Generated locally, not tested in Project Zomboid. Do not use on live multiplayer server.")
if __name__=="__main__":main()
