--主动查快递
return function(shipper)
    local shippercode = ""
    if shipper:find("顺丰") then
        shippercode = "SF"
    elseif shipper:find("百世") then
        shippercode = "HTKY"
    elseif shipper:find("中通") then
        shippercode = "ZTO"
    elseif shipper:find("申通") then
        shippercode = "STO"
    elseif shipper:find("圆通") then
        shippercode = "YTO"
    elseif shipper:find("韵达") then
        shippercode = "YD"
    elseif shipper:find("邮政") then
        shippercode = "YZPY"
    elseif shipper:find("天天") then
        shippercode = "HHTT"
    end
    return shippercode
end