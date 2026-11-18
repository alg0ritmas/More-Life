-- Internal server service. No client command can create or renew a lock.
require "MoreLife/ContainerLocks"
MoreLifeLockService={}
local S=MoreLifeLockService
function S.new(clock,resolve,authorize)
    local leases=MoreLifeContainerLocks.new(clock,30)
    local api={}
    local function identity(player)
        if not player then return nil end
        local ok,id=pcall(function() return player:getOnlineID() end)
        if not ok or type(id)~="number" or id<0 or id%1~=0 then return nil end
        return tostring(id)
    end
    -- resolve must produce a canonical server-derived container key; authorize must
    -- validate reach, access rights, and current state. Missing adapters deny access.
    local function target(player,ref)
        local owner=identity(player)
        if not owner or type(resolve)~="function" or type(authorize)~="function" then return nil end
        local ok,key,container=pcall(resolve,ref)
        if not ok or type(key)~="string" or key=="" or not container then return nil end
        local checked,allowed=pcall(authorize,player,container)
        if not checked or allowed~=true then return nil end
        return key,owner
    end
    function api.begin(player,ref)
        local key,owner=target(player,ref)
        if not key then return nil,"denied" end
        local token,reason,busyOwner=leases.acquire(key,owner)
        if not token then return nil,reason,busyOwner end
        return {key=key,owner=owner,token=token}
    end
    function api.renew(player,ref,handle)
        if type(handle)~="table" then return false end
        local key,owner=target(player,ref)
        if not key or key~=handle.key or owner~=handle.owner then return false end
        return leases.renew(key,owner,handle.token)
    end
    function api.finish(player,handle)
        if type(handle)~="table" then return false end
        local owner=identity(player)
        if not owner or owner~=handle.owner then return false end
        return leases.release(handle.key,owner,handle.token)
    end
    -- Call only after authoritative work has stopped, not merely after a disconnect notification.
    function api.disconnected(player)
        local owner=identity(player)
        if owner then leases.disconnect(owner) end
    end
    function api.sweep() leases.sweep() end
    return api
end
return S
