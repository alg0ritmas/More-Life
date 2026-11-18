local base='Workshop/MoreLife/Contents/mods/MoreLife/42/media/lua/'
local R=dofile(base..'shared/MoreLife/Rules.lua')
local n=0
local function eq(a,b) n=n+1; assert(a==b,tostring(a)..' ~= '..tostring(b)) end
for _,v in ipairs(R.speeds) do eq(R.speed(v,2),v); eq(R.duration(1500,v),math.ceil(1500/v)) end
eq(R.reading(100),0); eq(R.xp(20),1); eq(R.count(-1),0); eq(R.duration(-1,20),-1); eq(R.duration(2.5,1),2.5)
unpack=unpack or table.unpack
local handlers={}; Events={}; for _,k in ipairs({'OnFillInventoryObjectContextMenu','OnFillWorldObjectContextMenu','AddXP'}) do Events[k]={Add=function(f) handlers[k]=f end} end
local mp=false; function isClient() return mp end; function isServer() return false end
function instanceof(o,t) return o and o.kind==t end
local function list(t) return {size=function() return #t end,get=function(_,i) return t[i+1] end} end
local spotted={}; local md={}; local own={}; local dst={getType=function() return 'crate' end,getParent=function() return {} end}; local gear={}
local p={getModData=function() return md end,getInventory=function() return own end,getSpottedList=function() return list(spotted) end,Say=function() end,getVehicle=function() return nil end,isEquipped=function(_,i) return i==gear end}
local items={}; for i=1,65 do items[i]={kind='InventoryItem',getFullType=function() return 'Base.Bandage' end,getCategory=function() return 'Medical' end,getContainer=function() return own end,isFavorite=function() return i==1 end} end
gear=items[2]; own.getItems=function() return list(items) end; dst.getItems=function() return list({}) end
function getSpecificPlayer() return p end
function getPlayerLoot() return {inventoryPane={inventory=dst}} end
local room=true; local moved=0
ISInventoryPaneContextMenu={hasRoomForAny=function(_,d,b) eq(d,dst); return room end,onMoveItemsTo=function(b,d,i) moved=#b; for _,x in ipairs(b) do assert(x~=items[1] and x~=gear) end end}
ISInventoryPane={getActualItems=function(a) return a end}; ISBaseTimedAction={adjustMaxTime=function(_,t) return t end}
local oldrequire=require; require=function() end
dofile(base..'client/MoreLifeFull.lua'); require=oldrequire
local read={Type='ISReadABook',character=p}; local craft={Type='ISCraftAction',character=p}; local combat={Type='Attack',character=p}
local function duration(x) return ISBaseTimedAction.adjustMaxTime(x,1500) end
eq(duration(read),750); md.MoreLife.readingSpeed=20; eq(duration(read),75); eq(duration(craft),750); eq(duration(combat),1500)
spotted[1]={kind='IsoZombie'}; eq(duration(read),1500); spotted={}; mp=true; eq(duration(read),1500); mp=false
md.MoreLife.learning=false; eq(duration(read),1500); md.MoreLife.learning=true
local function ctx() local c={options={}}; function c:addOption(name,target,fn,...) local o={name=name,target=target,fn=fn,args={...}}; self.options[#self.options+1]=o; return o end; function c:getNew() return ctx() end; function c:addSubMenu(o,s) o.sub=s end; return c end
local c=ctx(); handlers.OnFillInventoryObjectContextMenu(0,c,{items[3]}); local o=c.options[1].sub.options[1]; o.fn(o.target,unpack(o.args)); eq(moved,50); eq(md.MoreLife.requested,50)
room=false; moved=0; o.fn(o.target,unpack(o.args)); eq(moved,0); eq(md.MoreLife.requested,50)
room=true; mp=true; o.fn(o.target,unpack(o.args)); eq(moved,0); mp=false
md.MoreLife='corrupt'; eq(duration(read),750); print('PASS: '..n..' assertions (Lua mock; not game runtime)')
