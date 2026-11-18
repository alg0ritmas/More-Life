local root="Workshop/MoreLife/Contents/mods/MoreLife/42/media/lua/"
dofile(root.."shared/MoreLife/ContainerLocks.lua")
local native=require; require=function() end
local S=dofile(root.."server/MoreLife/LockService.lua"); require=native
local now=0
local function player(id) return {getOnlineID=function() return id end} end
local a,b=player(1),player(2)
local allowed=true
local containers={one={},two={}}
local function resolve(ref) if ref=="alias" then ref="one" end; return ref,containers[ref] end
local function auth(p,c) return allowed end
local s=S.new(function() return now end,resolve,auth)
assert(not s.begin(nil,"one"))
assert(not s.begin(player(-1),"one"))
assert(not s.begin(a,"missing"))
allowed=false; assert(not s.begin(a,"one")); allowed=true
local h=assert(s.begin(a,"one"))
local h2,reason,owner=s.begin(b,"alias")
assert(not h2 and reason=="busy" and owner=="1")
assert(s.begin(b,"two"))
assert(not s.finish(b,h))
assert(not s.renew(b,"one",h))
allowed=false; assert(not s.renew(a,"one",h)); allowed=true
now=20; assert(s.renew(a,"one",h))
now=31; assert(not s.begin(b,"one"))
now=51; local next=assert(s.begin(b,"one"))
assert(not s.finish(a,h))
assert(s.finish(b,next))
local h3=assert(s.begin(a,"one"))
s.disconnected(a); assert(s.begin(b,"one"))
assert(not s.finish(a,h3))
local denied=S.new(function() return now end,nil,nil)
assert(not denied.begin(a,"one"))
print("Lock service assertions passed")
