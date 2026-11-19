-- Optional rare spawn in *unexplored* zones; no forced vehicle creation.
require "VehicleZoneDefinition"
local ID="MoreLifeVehicles.ArmoredScout"
local function register(zoneName)
 local z=VehicleZoneDistribution and VehicleZoneDistribution[zoneName]
 if z and z.vehicles and not z.vehicles[ID] then
  z.vehicles[ID]={index=-1,spawnChance=1}
  print("[MLV] Registered "..ID.." in "..zoneName)
 end
end
register("military")
register("army")
