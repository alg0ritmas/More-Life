-- Pure rules; runnable without Project Zomboid.
local R={}
R.speeds={1,1.5,2,3,5,10,15,20}
local function allowed(v,choices,fallback)
    v=tonumber(v)
    for _,x in ipairs(choices) do if v==x then return x end end
    return fallback
end
function R.speed(v,fallback) return allowed(v,R.speeds,fallback or 1) end
function R.reading(v) return allowed(v,R.speeds,0) end
function R.xp(v) return allowed(v,{1,1.5,2},1) end
function R.count(v)
    v=tonumber(v)
    if not v or v~=v or v<0 or v>1000000000 then return 0 end
    return math.floor(v)
end
function R.duration(native,speed)
    if type(native)~="number" or native<=1 or native~=native then return native end
    speed=R.speed(speed,1)
    if speed==1 then return native end
    return math.max(1,math.ceil(native/speed))
end
function R.matches(text,words)
    for _,v in ipairs(words or {}) do if string.find(text,v,1,true) then return true end end
    return false
end
function R.size(t) local n=0; for _ in pairs(t) do n=n+1 end; return n end
return R
