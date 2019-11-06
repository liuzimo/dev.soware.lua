return function (msg,qq)
    local shipper = msg:gsub("快递选择", "")
    if shipper == "京东快递" then
        return "请重新选择不支持京东"
    end
    local logisticode = apiXmlGet("searchtemp", "logistic", tostring(qq))
    local shippercode = apiXmlGet("searchtemp", logisticode, shipper)
    if shippercode ~= "" then
        apiXmlSet("logisticode", logisticode, "t", shipper)
        local expressearch = require("app.express.expressearch")
        return expressearch(shipper, logisticode)
    end
    return "请输入快递选择加正确的快递名称"
end
