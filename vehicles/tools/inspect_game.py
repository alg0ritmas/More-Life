"""Read-only local PZ vehicle-script inventory. No save or account data."""
import re,json,sys
from pathlib import Path
root=Path(sys.argv[1]) if len(sys.argv)>1 else Path('C:/Program Files (x86)/Steam/steamapps/common/ProjectZomboid')
source=root/'media/scripts'
if not source.is_dir(): raise SystemExit('Missing media/scripts; pass your game install directory')
entries=[]
for path in source.rglob('*.txt'):
    if 'vehicle' not in str(path).lower(): continue
    data=path.read_text(encoding='utf-8',errors='replace')
    for m in re.finditer(r'(?<![\w])vehicle\s+([\w]+)\s*\{',data):
        entries.append({'id':m.group(1),'relative_file':str(path.relative_to(root)).replace('\\','/')})
entries.sort(key=lambda e:e['id'])
report={'vehicle_count':len(entries),'examples':entries[:100],'game_path_omitted_for_privacy':True}
out=Path.cwd()/'mlv_game_script_report.json'
out.write_text(json.dumps(report,indent=2))
print('Found',len(entries),'vehicle definitions. Report:',out)
