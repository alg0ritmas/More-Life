-- Internal synchronous adapter contract; no native adapter registered yet.
MoreLifeBatchExecutor={}
local E=MoreLifeBatchExecutor
function E.run(player,plan,service,adapter)
    if type(adapter)~="table" or type(adapter.validate)~="function" or type(adapter.move)~="function" then return 0,"disabled" end
    local done=0
    for i,step in ipairs(plan) do
        if i>50 then break end
        if type(step)~="table" or type(step.source)~="string" or type(step.target)~="string" or step.source==step.target then return done,"invalid" end
        local a,why,owner=service.begin(player,step.source)
        if not a then return done,why,owner end
        local b,reason,busy=service.begin(player,step.target)
        if not b then service.finish(player,a); return done,reason,busy end
        local ok,moved=pcall(function()
            if not service.renew(player,step.source,a) or not service.renew(player,step.target,b) then return false end
            if adapter.validate(player,step)~=true then return false end
            -- Must be synchronous, atomic, native-authoritative, with no deferred work.
            return adapter.move(player,step)==true
        end)
        service.finish(player,b); service.finish(player,a)
        if not ok or not moved then return done,"stopped" end
        done=done+1
    end
    return done,"complete"
end
return E
