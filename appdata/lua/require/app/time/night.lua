--晚上

return function (time)
    if time ==23 then

        --初始群列表
        local t = apiXmlIdListGet("", "grouplist")
        local nums = t[0]
        local lists = t[1]
        for s = 0, nums do
            local ls = lists[s]
            apiXmlSet(key, "memberlist", tostring(ls["QQ"]), "")
        end

        --每个群都发
        local t = apiXmlIdListGet("", "grouplist")
        local nums = t[0]
        local lists = t[1]
        local time = "现在是晚上"..tostring(time-12).."点！\n这么晚了不要熬夜了噢，快睡觉吧"
        for i = 0, nums do
            cqSendGroupMessage(tonumber(lists[i]), time)
        end
        return true
    end
    return true
end
