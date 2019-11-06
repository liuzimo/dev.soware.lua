--查快递
return function (shipper,logisticode)
    local shippercode = apiXmlGet("","shippercode",shipper)
    local data = apiNowSearch(shippercode,logisticode)
    if data == "" then 
        return "网络繁忙,请稍后再试"
    end
    local kd =jsonDecode(data)
    --判断是否成功 失败返回官方原因
    if not kd["Success"] then
        return kd["Reason"]
    end
    local status = "";
    if kd["State"]=="0" then
        status="无轨迹"
    elseif kd["State"]=="1" then
        status="已揽收"
    elseif kd["State"]=="2" then
        status="早途中"
    elseif kd["State"]=="3" then
        status="已签收"
    elseif kd["State"]=="4" then
        status="问题件"
    end
    local ms = shipper.."\n"

    if kd["Traces"]==nil then
        return ms.."无轨迹"
    end
    for i=1,#kd["Traces"] do
        ms = ms..kd["Traces"][i]["AcceptStation"]..kd["Traces"][i]["AcceptTime"].."\n"
    end
    return ms.."当前状态："..status
end
