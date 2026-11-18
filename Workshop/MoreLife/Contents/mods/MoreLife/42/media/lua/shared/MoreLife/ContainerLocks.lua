-- Pure server-side lease design; not wired into game transfers.
MoreLifeContainerLocks={}
local L=MoreLifeContainerLocks
function L.new(clock,ttl)
    assert(type(clock)=="function")
    assert(type(ttl)=="number" and ttl>0 and ttl<math.huge)
    local locks,serial={},0
    local api={}
    function api.acquire(key,owner)
        if type(key)~="string" or key=="" or type(owner)~="string" or owner=="" then return nil,"invalid" end
        local now=clock(); local old=locks[key]
        if old and old.expires>now then return nil,"busy",old.owner end
        serial=serial+1
        locks[key]={owner=owner,token=serial,expires=now+ttl}
        return serial
    end
    function api.renew(key,owner,token)
        local old=locks[key]; local now=clock()
        if not old or old.owner~=owner or old.token~=token or old.expires<=now then return false end
        old.expires=now+ttl; return true
    end
    function api.release(key,owner,token)
        local old=locks[key]
        if not old or old.owner~=owner or old.token~=token then return false end
        locks[key]=nil; return true
    end
    function api.disconnect(owner)
        for key,old in pairs(locks) do if old.owner==owner then locks[key]=nil end end
    end
    function api.sweep()
        local now=clock()
        for key,old in pairs(locks) do if old.expires<=now then locks[key]=nil end end
    end
    return api
end
return L
