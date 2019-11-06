--快递推送
return function(msg)
    local jdata = jsonDecode(msg)
    local count = jdata["Count"]
    local data = jdata["Data"]
    
    for i = 1, count do
        local getshipper = require("app.express.shipper")
        local shipper = getshipper(data[i]["ShipperCode"])
        local logisticode = data[i]["LogisticCode"]
        local ms =  shipper.."\n"
        for t=1,#data[i]["Traces"] do
            
        ms = ms .. data[i]["Traces"][t]["AcceptStation"] .. data[i]["Traces"][t]["AcceptTime"] .. "\n"
        end
        
        local group = apiXmlGet("", "expressubgroup", logisticode)
        local qq = apiXmlGet(group, "expressub", logisticode)
        if group =="" then
            cqSendPrivateMessage(tonumber(qq), ms)
            return true
        end
        cqSendPrivateMessage(tonumber(group), cqCode_At(qq).."\n"..ms)
        return true
    end
end