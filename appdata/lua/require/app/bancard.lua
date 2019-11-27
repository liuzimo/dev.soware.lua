--抽奖
return function(msg, qq, group)


    local cards = apiXmlGet(tostring(group), "banCard", tostring(qq))
    cards = cards == "" and 0 or tonumber(cards) or 0
    local kcards = apiXmlGet(tostring(group), "keepCard", tostring(qq))
    kcards = kcards == "" and 0 or tonumber(kcards) or 0

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
            local banTime = math.random(1, 10)
            cqSetGroupBanSpeak(group, qq, banTime * 60)
            return cqCode_At(qq) .. "恭喜你抽中了禁言" .. tostring(banTime) .. "分钟"

        elseif math.random() > 0.5 then
            local banCard = math.random(1, 3)
                kcards = kcards + banCard
                apiXmlSet(tostring(group), "keepCard", tostring(qq), tostring(kcards))
                return cqCode_At(qq) .. "恭喜你抽中了" .. tostring(banCard) .. "张免禁卡\r\n" ..
                "当前免禁卡数量：" .. tostring(kcards)
        else
            local banCard = math.random(1, 6)
            cards = cards + banCard
            apiXmlSet(tostring(group), "banCard", tostring(qq), tostring(cards))
            return cqCode_At(qq) .. "恭喜你抽中了" .. tostring(banCard) .. "张禁言卡\r\n" ..
            "当前禁言卡数量：" .. tostring(cards)
        end

        --禁言卡查询
    elseif msg == "禁言卡" then

        return cqCode_At(qq) .. "当前禁言卡数量：" .. tostring(cards).."\n".. "当前免禁卡数量：" .. tostring(kcards)

        --禁言
    elseif msg:find("禁言卡%[CQ:at,qq=") then
        if cards <= 0 then
            return cqCode_At(qq) .. "你只有" .. tostring(cards) .. "张禁言卡，无法操作"
        end
        apiXmlSet(tostring(group), "banCard", tostring(qq), tostring(cards - 1))
        local v = tonumber(msg:match("(%d+)"))
        kcards = apiXmlGet(tostring(group), "keepCard", tostring(v))
        kcards = kcards == "" and 0 or tonumber(kcards) or 0
        local banTime = math.random(1, 10)
        cqSetGroupBanSpeak(group, v, banTime * 60)
        if kcards <= 0 then
            return cqCode_At(qq) .. "已将" .. tostring(v) .. "禁言" .. tostring(banTime) .. "分钟"
        end
        apiXmlSet(tostring(group), "keepCard", tostring(v), tostring(kcards-1))
        return cqCode_At(qq).."对方消耗一张免禁卡，禁言不起作用"
        
        --禁言解除
    elseif msg:find("禁言解除%[CQ:at,qq=") then
        local v = tonumber(msg:match("(%d+)"))
        if cards <= 0 then
            return cqCode_At(qq) .. "你只有" .. tostring(cards) .. "张禁言卡，无法操作"
        end
        apiXmlSet(tostring(group), "banCard", tostring(qq), tostring(cards - 1))
        cqSetGroupBanSpeak(group, v, -1)
        local v = tonumber(msg:match("(%d+)"))
        return cqCode_At(qq) .. "已将" .. tostring(v) .. "解除禁言" 
    else
        return "命令：禁言@QQ "
    end
end
