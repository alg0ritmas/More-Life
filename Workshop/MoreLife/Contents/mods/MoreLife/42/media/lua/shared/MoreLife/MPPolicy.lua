-- More Life MP foundation: read-only policy; no action or inventory mutation.
MoreLifeMPPolicy = {}
local P=MoreLifeMPPolicy
P.version="0.2.4"
function P.reading(vars)
    local v=vars and tonumber(vars.MinutesPerPage)
    if not v or v~=v or v<=0 or v==math.huge then return nil end
    return v
end
function P.summary(vars)
    local v=P.reading(vars)
    if not v then return "MinutesPerPage unavailable; check server sandbox." end
    return string.format("Server reading: %.4g game min/page (%.3gx vs 2.0 baseline)",v,2/v)
end
return P
