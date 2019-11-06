--主动查快递
return function(shippercode)
    local shipper = ""
    if shippercode:find("SF") then
        shipper = "顺丰"
    elseif shippercode:find("HTKY") then
        shipper = "百世"
    elseif shippercode:find("ZTO") then
        shipper = "中通"
    elseif shippercode:find("STO") then
        shipper = "申通"
    elseif shippercode:find("YTO") then
        shipper = "圆通"
    elseif shippercode:find("YD") then
        shipper = "韵达"
    elseif shippercode:find("YZPY") then
        shipper = "邮政"
    elseif shippercode:find("HHTT") then
        shipper = "天天"
    end
    return shipper
end