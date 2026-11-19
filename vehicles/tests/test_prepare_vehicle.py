import tempfile,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from prepare_vehicle import sections,transform,build
DONOR="""module Base
{
 vehicle CarStationWagon
 {
 seats = 4,
 model { file = Base.CarStationWagon, scale = 1.0, }
 wheel FrontLeft { radius = 0.15, }
 part DoorFrontLeft { category = door, }
 }
}
"""
assert list(sections(DONOR))[0][:2]==('Base','CarStationWagon')
s=transform(list(sections(DONOR))[0][2])
assert 'vehicle MLVArmoredScout' in s and 'file = MoreLifeVehicles.MLV_ArmoredScout' in s
assert 'seats = 4' in s and 'DoorFrontLeft' in s
with tempfile.TemporaryDirectory() as td:
 root=Path(td)/'game'; d=root/'media/scripts/vehicles';d.mkdir(parents=True)
 (d/'test.txt').write_text(DONOR)
 out=Path(td)/'mod'
 report=build(root,out)
 assert report['donor']=='Base.CarStationWagon'
 assert (out/'media/scripts/vehicles/MLV_ArmoredScout.txt').exists()
print('Vehicle donor generator fixture tests passed')
