-- More Life 0.2.1 Full Alpha. No direct inventory mutations.
require "ISUI/ISInventoryPaneContextMenu"
require "ISUI/ISInventoryPane"
require "TimedActions/ISBaseTimedAction"
local ML = { limit = 50 }
local function log(s) print("[MoreLife] "..tostring(s)) end
local function call(o,k,...)
    if not o then return nil end
    local args={...}; local ok,v=pcall(function() return o[k](o,unpack(args)) end)
    if ok then return v end
end
local function tr(p,t,e,d)
    local lang=tostring(call(getCore(),"getOptionLanguage"))
    if lang=="TR" then return t elseif lang=="DE" then return d else return e end
end
local defaults={inventory=true,loot=true,learning=true,construction=true,living=true,vehicles=true,speed=2,xp=1,profile="food",requested=0,storage={}}
local function data(p)
    local md=p:getModData(); md.MoreLife=md.MoreLife or {}; local d=md.MoreLife
    for k,v in pairs(defaults) do if d[k]==nil then d[k]=type(v)=="table" and {} or v end end
    return d
end
local function say(p,s) if p then p:Say(tostring(s)) end; log(s) end
local function online() return (isClient and isClient()) or (isServer and isServer()) end
local function protected(p,i)
    return call(i,"isFavorite") or call(p,"isEquipped",i) or call(i,"isForceDropHeavyItem") or call(i,"isHumanCorpse") or instanceof(i,"InventoryContainer") or call(p,"getPrimaryHandItem")==i or call(p,"getSecondaryHandItem")==i or call(i,"getAttachedSlot") and call(i,"getAttachedSlot")>=0
end
local function cat(i) return tostring(call(i,"getCategory") or ""):lower() end
local function typ(i) return tostring(call(i,"getFullType") or ""):lower() end
local profiles={food={"food","water","drink"},medical={"medical","bandage","pill","disinfect"},combat={"weapon","ammo","bullet","magazine"},building={"plank","nails","hammer","saw","screw","wood","metal"},books={"literature","book","magazine","skill"}}
local function matches(i,profile)
    local s=cat(i).." "..typ(i); for _,v in ipairs(profiles[profile] or {}) do if string.find(s,v,1,true) then return true end end; return false
end
local function loot(n) local page=getPlayerLoot(n); return page and page.inventoryPane and page.inventoryPane.inventory end
local function safeContainer(c)
    return c and call(c,"getType")~="floor" and call(c,"getParent")~=nil
end
local function key(c)
    local o=call(c,"getParent"); local q=call(o,"getSquare"); local idx=call(o,"getObjectIndex")
    if not q or idx==nil or idx<0 then return nil end
    return table.concat({q:getX(),q:getY(),q:getZ(),idx,tostring(call(c,"getType"))},":")
end
local function items(c)
    local out={}; local l=call(c,"getItems"); if not l then return out end
    for i=0,l:size()-1 do out[#out+1]=l:get(i) end; return out
end
local function eligible(p,c,s,mode,profile)
    local out={}; for _,i in ipairs(items(c)) do
        if not protected(p,i) and (mode=="all" or (mode=="type" and s and typ(i)==typ(s)) or (mode=="category" and s and cat(i)==cat(s)) or (mode=="profile" and matches(i,profile))) then
            out[#out+1]=i; if #out>=ML.limit then break end
        end
    end; return out
end
local function transfer(p,n,src,dst,s,mode,profile)
    if online() then say(p,"More Life: multiplayer transfer disabled in alpha"); return end
    local own=p:getInventory(); local active=loot(n)
    if p:getVehicle() or not safeContainer(active) or not ((src==own and dst==active) or (src==active and dst==own)) then return end
    if s and s:getContainer()~=src then return end
    local batch=eligible(p,src,s,mode,profile); if #batch==0 then return end
    local f=ISInventoryPaneContextMenu.onMoveItemsTo
    if type(f)~="function" then say(p,"Native transfer unavailable"); return end
    local ok,err=pcall(f,batch,dst,n)
    if ok then data(p).requested=data(p).requested+#batch; say(p,"More Life: "..#batch.." requested (not confirmed)") else log(err) end
end
local function choose(p,k,v) data(p)[k]=v; say(p,k..": "..tostring(v)) end
local function mark(p,c,profile) local k=key(c); if k then data(p).storage[k]=profile; say(p,"Storage: "..profile) end end
local function sub(ctx,name) local opt=ctx:addOption(name,nil,nil); local s=ctx:getNew(ctx); ctx:addSubMenu(opt,s); return s end
local function menu(n,ctx,selection)
    local p=getSpecificPlayer(n); if not p or online() then return end
    local d=data(p); local own=p:getInventory(); local c=loot(n)
    local a=selection and ISInventoryPane.getActualItems(selection); local sample=a and a[1]
    if not sample or not instanceof(sample,"InventoryItem") then return end
    local root=sub(ctx,"More Life | Full Alpha")
    if safeContainer(c) and not p:getVehicle() then
        local src=sample:getContainer(); local dst=src==own and c or (src==c and own or nil)
        if d.inventory and dst then
            for _,mode in ipairs({"type","category","all"}) do
                local names={type="Move same type",category="Move same category",all="Move unprotected"}
                root:addOption(names[mode].." ("..#eligible(p,src,sample,mode)..")",p,transfer,n,src,dst,sample,mode)
            end
        end
        if d.loot then root:addOption("Loot profile: "..d.profile,p,transfer,n,c,own,nil,"profile",d.profile) end
        local k=key(c)
        if d.inventory and k then
            local sm=sub(root,"Storage category")
            for _,pr in ipairs({"food","medical","combat","building","books"}) do sm:addOption(pr,p,mark,c,pr) end
            if d.storage[k] then root:addOption("Deposit matching: "..d.storage[k],p,transfer,n,own,c,nil,"profile",d.storage[k]) end
        end
    end
    local pm=sub(root,"Choose loot profile")
    for _,pr in ipairs({"food","medical","combat","building","books"}) do pm:addOption(pr,p,choose,"profile",pr) end
    root:addOption("Requested transfers: "..d.requested,p,say,"Requested transfers: "..d.requested)
end
local function report(p)
    local v=p:getVehicle(); if not v then say(p,"Enter a vehicle first"); return end
    local result={}; local count=call(v,"getPartCount") or 0
    for i=0,count-1 do local part=call(v,"getPartByIndex",i); local cond=call(part,"getCondition"); if cond and cond<60 then result[#result+1]=tostring(call(part,"getId")).." "..cond.."%" end end
    log("Vehicle weak parts: "..table.concat(result,", ")); say(p,#result==0 and "No parts below 60%" or ("Weak parts: "..#result.." (console)"))
end
local function checklist(p)
    local counts={}; for _,i in ipairs(items(p:getInventory())) do local k=typ(i); counts[k]=(counts[k] or 0)+1 end
    local wanted={"base.plank","base.nails","base.hammer","base.saw"}; local out={}
    for _,k in ipairs(wanted) do out[#out+1]=k..": "..(counts[k] or 0) end
    say(p,table.concat(out," | "))
end
local function world(n,ctx,objects,test)
    if test or online() then return end
    local p=getSpecificPlayer(n); if not p then return end; local d=data(p)
    local root=sub(ctx,"More Life | Settings")
    for _,k in ipairs({"inventory","loot","learning","construction","living","vehicles"}) do root:addOption(k..": "..(d[k] and "ON" or "OFF"),p,choose,k,not d[k]) end
    local speeds=sub(root,"Routine speed: "..d.speed.."x")
    for _,v in ipairs({1,1.5,2,3,5,10,15,20}) do speeds:addOption(v.."x",p,choose,"speed",v) end
    local xp=sub(root,"Practice bonus: "..d.xp.."x")
    for _,v in ipairs({1,1.5,2}) do xp:addOption(v.."x",p,choose,"xp",v) end
    if d.construction then root:addOption("Building supplies checklist",p,checklist) end
    if d.vehicles then root:addOption("Vehicle condition summary",p,report) end
end
-- Allowlist only; unknown actions retain native timing. No MP overrides.
local actionGroups={ISInventoryTransferAction="inventory",ISTransferAction="inventory",ISReadABook="learning",ISBuildAction="construction",ISHandcraftAction="construction",ISWashClothing="living",ISWashYourself="living",ISFillWaterAction="living",ISCraftAction="construction",ISInstallVehiclePart="vehicles",ISUninstallVehiclePart="vehicles",ISRepairEngine="vehicles",ISSiphonFuel="vehicles",ISAddGasolineToVehicle="vehicles"}
local function danger(p)
    -- Conservative: if visibility API unavailable, don't accelerate.
    local z=call(p,"getStats"); local nearby=call(p,"getSpottedList")
    if not nearby or not z then return true end
    for i=0,nearby:size()-1 do if instanceof(nearby:get(i),"IsoZombie") then return true end end
    return false
end
local old=ISBaseTimedAction.adjustMaxTime
if type(old)=="function" then
    ISBaseTimedAction.adjustMaxTime=function(self,t,...)
        local native=old(self,t,...); local p=self.character; local group=actionGroups[self.Type]
        if online() or not group or not p or type(native)~="number" or native<=1 or danger(p) then return native end
        local d=data(p); if not d[group] then return native end
        return math.max(1,math.ceil(native/math.max(1,math.min(20,tonumber(d.speed) or 1))))
    end
else log("Timing hook absent; native timings retained") end
-- Extra XP is optional, single-player, guarded against recursive AddXP events.
local adding=false
local function xp(p,perk,amount)
    if adding or online() or not p or type(amount)~="number" or amount<=0 then return end
    local d=data(p); if not d.learning or d.xp<=1 then return end
    -- Only handcraft/life skills; no combat or fitness.
    local s=tostring(perk); local allowed={Woodwork=true,Carpentry=true,Electricity=true,Mechanics=true,Cooking=true,Tailoring=true,Farming=true,MetalWelding=true,Blacksmith=true,Maintenance=true}
    if not allowed[s] then return end
    adding=true; local ok,e=pcall(function() p:getXp():AddXP(perk,amount*(math.min(2,d.xp)-1),false,false,false) end); adding=false; if not ok then log(e) end
end
Events.OnFillInventoryObjectContextMenu.Add(menu)
Events.OnFillWorldObjectContextMenu.Add(world)
if Events.AddXP then Events.AddXP.Add(xp) end
log("Full Alpha 0.2.1 loaded; single-player only")
