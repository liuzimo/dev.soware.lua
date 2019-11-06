--主动查快递
return function(msg, group,qq)
    local shipper = msg:gsub("订阅",""):gsub("(%d+)","")
    local getshippercode = require("app.express.shippercode")
    local shippercode = getshippercode(shipper)
    if shippercode =="" then
        return "错误的快递公司或不支持该快递公司"
    end
    local logisticode = msg:match("(%d+)")
    local data =  apiOrderSub( shippercode,tostring(logisticode),
                        "哈哈","12345678901","上海","上海","浦江区","11111",
                        "嘿嘿","12345678901","四川省","成都市","浦江区","11111")
    local kd = jsonDecode(data)
    if not kd["Success"] then
        return kd["Reason"]
    end
    apiXmlSet("", "expressubgroup", logisticode,tostring(group))
    apiXmlSet(tostring(group), "expressub", logisticode,tostring(qq))
    return cqCode_At(qq).."订阅成功，如快递信息发生变动将实时推送给您"
end