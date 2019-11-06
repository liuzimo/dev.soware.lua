--主动查快递
return function(msg,qq)
    local logisticode = msg:match("(%d+)")
    --判断是否选择快递公司
    local shipper = apiXmlGet("logisticode", logisticode, "t")
    if shipper ~= "" then
        local expressearch = require("app.express.expressearch")
        return expressearch(shipper, logisticode)
    end
    --查单号
    local jsondata = apiOrderSearch(logisticode)
    --判断接口是否正常
    if jsondata == "" then
        return "网络错误，请稍后再试"
    end
    --解码 判断单号是否正确
    local d = jsonDecode(jsondata)
    if not d["Success"] then
        return "查询失败，请检查单号是否正确"
    end
    if d["Shippers"] == nil or #d["Shippers"] == 0 then
        return "单号不存在,请输入正确的单号"
    end

    --保存 单号查询记录
    apiXmlSet("searchtemp", "logistic", tostring(qq), logisticode)
    apiXmlInsert("", "logistic", tostring(qq), logisticode)

    --
    if #d["Shippers"] == 1 then

        if d["Shippers"][1]["ShipperName"] == "京东快递" then
            return "请重新输入单号不支持京东快递"
        end
        apiXmlSet("", "shippercode", d["Shippers"][1]["ShipperName"], d["Shippers"][1]["ShipperCode"])
        local expressearch = require("app.express.expressearch")
        return expressearch(d["Shippers"][1]["ShipperName"], logisticode)
    end

    local m = "当前单号查询出" .. #d["Shippers"] .. "家快递公司\n"
    for i = 1, #d["Shippers"] do

        apiXmlSet("logisticode", logisticode, "f", d["Shippers"][i]["ShipperName"])
        apiXmlSet("searchtemp", logisticode, d["Shippers"][i]["ShipperName"], d["Shippers"][i]["ShipperCode"])
        apiXmlSet("", "shippercode", d["Shippers"][i]["ShipperName"], d["Shippers"][i]["ShipperCode"])
        m = m .. d["Shippers"][i]["ShipperName"] .. "\n"
    end
    return m .. "请您手动选择哪家快递，列如：快递选择中通速递(输入完整名称)"
end