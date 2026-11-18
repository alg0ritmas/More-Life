require "MoreLife/MPPolicy"
local P=MoreLifeMPPolicy
if P and Events and Events.OnFillWorldObjectContextMenu then
    Events.OnFillWorldObjectContextMenu.Add(function(n,context,objects,test)
        if test or not isClient or not isClient() then return end
        local player=getSpecificPlayer(n)
        if not player then return end
        context:addOption("More Life MP | Reading settings",player,function(p)
            p:Say(P.summary(SandboxVars))
        end)
    end)
end
