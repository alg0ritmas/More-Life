require "MoreLife/MPPolicy"
local P=MoreLifeMPPolicy
if P and Events and Events.OnServerStarted then
    Events.OnServerStarted.Add(function()
        print("[MoreLife MP "..P.version.."] "..P.summary(SandboxVars))
        print("[MoreLife MP] Read-only foundation; no custom transfers or XP overrides.")
    end)
end
