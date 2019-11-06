--抽奖
return function(msg, qq, group)


    local cards = apiXmlGet(tostring(group), "banCard", tostring(qq))
    cards = cards == "" and 0 or tonumber(cards) or 0

    --抽奖
    if msg == "抽奖" then
        -- if cqGetMemberInfo(g,cqGetLoginQQ()).PermitType == 1 or
        --     (cqGetMemberInfo(g,qq).PermitType ~= 1) then
        --     return cqCode_At(qq).."权限不足，抽奖功能无效"
        -- end
        local day = os.date("%Y年%m月%d日")--今天
        local signData = apiXmlGet(tostring(group), "lottery", tostring(qq))

        local data = signData == "" and
        {
            last = 0, --上次抽奖时间戳
            count = 0, --连抽计数
        } or jsonDecode(signData)

        if data.last == day then
            return "你今天已经抽过奖啦"
        end

        if data.last == os.date("%Y年%m月%d日", os.time() - 3600 * 24) then
            data.count = data.count + 1
        else
            data.count = 1
        end
        data.last = day
        local j = jsonEncode(data)
        apiXmlSet(tostring(group), "lottery", tostring(qq), j)








        if math.random() > 0.9 then
            local banTime = math.random(1, 60)
            cqSetGroupBanSpeak(group, qq, banTime * 60)
            return cqCode_At(qq) .. "恭喜你抽中了禁言" .. tostring(banTime) .. "分钟"
        else
            local banCard = math.random(1, 6)
            cards = cards + banCard
            apiXmlSet(tostring(group), "banCard", tostring(qq), tostring(cards))
            return cqCode_At(qq) .. "恭喜你抽中了" .. tostring(banCard) .. "张禁言卡\r\n" ..
            "当前禁言卡数量：" .. tostring(cards)
        end

        --禁言卡查询
    elseif msg == "禁言卡" then

        return cqCode_At(qq) .. "当前禁言卡数量：" .. tostring(cards)

        --禁言
    elseif msg:find("禁言%[CQ:at,qq=") then
        if cards <= 0 then
            return cqCode_At(qq) .. "你只有" .. tostring(cards) .. "张禁言卡，无法操作"
        end
        apiXmlSet(tostring(group), "banCard", tostring(qq), tostring(cards - 1))
        local v = tonumber(msg:match("(%d+)"))
        local banTime = math.random(1, 60)
        cqSetGroupBanSpeak(group, v, banTime * 60)
        return cqCode_At(qq) .. "已将" .. tostring(v) .. "禁言" .. tostring(banTime) .. "分钟"
        --禁言解除
    elseif msg:find("禁言解除%[CQ:at,qq=") then
        local v = tonumber(msg:match("(%d+)"))
        cqSetGroupBanSpeak(group, v, -1)
        return cqCode_At(qq) .. "已将" .. tostring(v) .. "解除禁言" 
    else
        return "格式：禁言 QQ号码 "
    end
end
