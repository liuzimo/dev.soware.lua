--早上
return function (time)

    --早上9点
    if time== 9 then
        --初始群列表
        local t = apiXmlIdListGet("", "grouplist")
        local nums = t[0]
        local lists = t[1]
        for s = 0, nums do
            local ls = lists[s]
            apiXmlSet(key, "memberlist", tostring(ls["QQ"]), "")
        end

        --每个群都发
        local num = apiXmlGet("","SoulSoother","currect")
        local notice = apiXmlGet("","SoulSoother",num)
        apiXmlSet("","SoulSoother","currect",tostring(tonumber(num)+1))
        local t = apiXmlIdListGet("", "grouplist")
        local nums = t[0]
        local lists = t[1]
        local time = "现在是早晨"..time.."点！\n"
        for i = 0, nums do
            cqSendGroupMessage(tonumber(lists[i]), time..notice)
        end
        return true
    end
end
