local root="Workshop/MoreLife/Contents/mods/MoreLife/42/media/lua/"
local P=dofile(root.."shared/MoreLife/BatchPlanner.lua")
local E=dofile(root.."server/MoreLife/BatchExecutor.lua")
local items={{id=1,source="bag",profile="food",weight=2,protected=false},{id=2,source="bag",profile="food",weight=2,protected=true},{id=1,source="bag",profile="food",weight=2,protected=false},{id=3,source="bag",profile="food",weight=5,protected=false}}
local plan=P.plan(items,{{key="crate",profile="food",free=3,available=true}},50)
assert(#plan==1 and plan[1].id==1)
local held={}; local service={}
function service.begin(p,k) if held[k] then return nil,"busy","other" end; held[k]=true; return k end
function service.renew(p,k,h) return held[k]==true end
function service.finish(p,h) held[h]=nil end
local adapter={validate=function() return true end,move=function() return true end}
local n,s=E.run({},plan,service,adapter); assert(n==1 and s=="complete" and next(held)==nil)
held.crate=true; n,s=E.run({},plan,service,adapter); assert(n==0 and s=="busy" and not held.bag); held.crate=nil
adapter.move=function() error("test") end; n,s=E.run({},plan,service,adapter); assert(n==0 and s=="stopped" and next(held)==nil)
n,s=E.run({},plan,service,nil); assert(n==0 and s=="disabled")
print("Batch tests passed")
