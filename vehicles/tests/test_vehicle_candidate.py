import sys,tempfile,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/"tools"))
from prepare_drivable_candidate import vehicles,seats,rewrite,build,block
FIXTURE="""module Base {
 vehicle SUV {
 mass = 1140,
 // vehicle Fake { }
 model { file = Base.Vehicles_SUV, scale = 1.82, }
 skin { texture = Vehicles/vehicle_suv, }
 passenger FrontLeft { area = SeatFrontLeft, }
 passenger FrontRight { area = SeatFrontRight, }
 passenger RearLeft { area = SeatRearLeft, }
 passenger RearRight { area = SeatRearRight, }
 part DoorFrontLeft { category = door, }
 }
 vehicle Another { model { file = Base.Other, } }
}"""
class Tests(unittest.TestCase):
 def test_filter(self): self.assertEqual(set(vehicles(FIXTURE)),{"SUV","Another"})
 def test_count(self): self.assertEqual(seats(vehicles(FIXTURE)["SUV"]),4)
 def test_rewrite(self):
  code,n=rewrite(vehicles(FIXTURE)["SUV"])
  self.assertIn("MoreLifeVehicles.MLV_ArmoredScout",code)
  self.assertIn("vehicle_mlv_armoredscout",code)
  self.assertIn("passenger RearRight",code)
  self.assertEqual(n,1)
 def test_no_model(self):
  with self.assertRaises(ValueError):rewrite("{ mass = 5, }")
 def test_no_file(self):
  with self.assertRaises(ValueError):rewrite("{ model { scale = 1.82, } }")
 def test_build_and_reject_two_seats(self):
  with tempfile.TemporaryDirectory() as d:
   source=Path(d)/"vehicles_suv.txt";source.write_text(FIXTURE)
   dest=Path(d)/"candidate.txt"
   report=build(source,"SUV",dest)
   self.assertEqual(report["status"],"NOT_GAME_TESTED")
   self.assertTrue(dest.exists())
   self.assertTrue(dest.with_suffix(".json").exists())
   source.write_text(FIXTURE.replace("passenger RearLeft { area = SeatRearLeft, }","").replace("passenger RearRight { area = SeatRearRight, }",""))
   with self.assertRaises(ValueError):build(source,"SUV",dest)
if __name__=="__main__":unittest.main()
