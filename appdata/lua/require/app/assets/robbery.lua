--打劫金币

return function (fromgroup,fromqq,msg)


    local physical = require("app.assets.physical")
    if physical(fromgroup,fromqq) == -1 then
        return "体力不足,明天再来吧"
    end

    local beingoperateqq = tonumber(msg:match("(%d+)"))
    if fromqq == beingoperateqq then
        return "某人自残了"
    end
    if beingoperateqq == cqGetLoginQQ() then
        return "敢对NPC动手,不要命了"
    end
    local intin = apiXmlGet(tostring(fromgroup), "assets",tostring(beingoperateqq))
    if intin == "" then
        intin = 500
    elseif tonumber(intin) < 1 then
        return "对方已经没有钱了，手下留情"
    end
    
    local intbe = apiXmlGet(tostring(fromgroup), "assets",tostring(fromqq))
    if intbe == "" then
        intbe = 500
    end
    local rob = math.random(100,519)
    if tonumber(intin) < rob then
        rob = tonumber(intin)
    end
    apiXmlSet(tostring(fromgroup),"assets",tostring(beingoperateqq),tostring(tonumber(intin)-rob))
    apiXmlSet(tostring(fromgroup),"assets",tostring(fromqq),tostring(tonumber(intbe)+rob))

    return "打劫到"..rob.."铜币     体力减1"
end
