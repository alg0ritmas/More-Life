-- Pure deterministic planner: does not move items.
MoreLifeBatchPlanner={}
local P=MoreLifeBatchPlanner
function P.plan(items,targets,limit)
    local result,seen={},{}
    limit=math.min(50,math.max(0,math.floor(tonumber(limit) or 50)))
    for _,item in ipairs(items) do
        if #result>=limit then break end
        if item.id and not seen[item.id] and item.protected==false and type(item.weight)=="number" and item.weight>=0 and item.weight<math.huge then
            seen[item.id]=true
            for _,target in ipairs(targets) do
                if target.key~=item.source and target.available==true and target.profile==item.profile and type(target.free)=="number" and target.free>=item.weight then
                    result[#result+1]={id=item.id,source=item.source,target=target.key}
                    target.free=target.free-item.weight
                    break
                end
            end
        end
    end
    return result
end
return P
