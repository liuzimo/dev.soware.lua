--汇率转换 

return function (assets)
    if assets < 1 then
        return "资产不足"
    end
    local gold = 0
    local silver = 0
    local copper = 0
    local ms = ""

    copper = math.fmod( assets, 520 )   -- 取余数
    silver = math.modf( assets / 520 )  -- 取整数
    gold= math.modf( silver / 520 )  -- 取整数
    silver = math.fmod( silver, 520 )  -- 取余数
    
    if gold > 0  then
        ms = ms ..tostring(gold).."枚金币"
    end
    if silver > 0  then
        ms = ms ..tostring(silver).."枚银币"
    end
    if copper > 0  then
        ms = ms ..tostring(copper).."枚铜币"
    end
    return ms
end
