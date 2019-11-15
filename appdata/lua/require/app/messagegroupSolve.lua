--统一的消息处理函数
local msg, qq, group, id = nil, nil, nil, nil
local handled = false

--发送消息
function sendMessage(s)
    if cqSendGroupMessage(group, s) == -34 then
        --在群内被禁言了，打上标记
        apiXmlSet("", "ban", tostring(group), tostring(os.time()))
    end
end

--对外提供的函数接口
return function(inmsg, inqq, ingroup, inid)
    msg, qq, group, id = inmsg, inqq, ingroup, inid

    --开启群内聊天
    if msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("说话") and admin==qq then
        apiXmlSet("","Shutup",tostring(group),"t")
    end
    --默认设置群内不说话
    if apiXmlGet("","Shutup",tostring(group))~="t" then
        return true
    end

    --加载菜单
    local getapp = require("app.menu.groupfeatures")
    local apps = getapp(group,qq,msg,id)
    local getadminapp = require("app.menu.groupmanage")
    local adminapps = getadminapp(group,qq,msg)
    local getgame = require("app.menu.game")
    local gameapps = getgame(group,qq,msg)

    --匹配是否需要获取帮助
    if msg:lower():find("help") == 1 or msg:lower():find("菜单") == 1 or msg:lower():find("帮助") == 1 then
        local allApp = {}
        for i = 1, #apps do
            local appExplain = apps[i].explain and apps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("命令帮助\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end

    --匹配是否需要获取管理
    if msg:lower():find("manage") == 1 or msg:lower():find("管理") == 1 then
        if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
            local allApp = {}
            for i = 1, #adminapps do
                local appExplain = adminapps[i].explain and adminapps[i].explain()
                if appExplain then
                    table.insert(allApp, appExplain)
                end
            end
            sendMessage("管理功能\n" ..
            table.concat(allApp, "\n") .. "\n")
            return true
        end
        sendMessage("权限不足！")
        return true
    end
    
    --匹配是否需要游戏菜单
    if msg:lower():find("game") == 1 then
        local allApp = {}
        for i = 1, #gameapps do
            local appExplain = gameapps[i].explain and gameapps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("蜀山捉妖记\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end


    --遍历所有功能
    for i = 1, #adminapps do
        if adminapps[i].check and adminapps[i].check() then
            if (apiXmlGet(tostring(group), "adminList", tostring(qq)) == "admin" or apiXmlGet("", "adminList", tostring(qq)) == "admin") or qq == admin then
                if adminapps[i].run() then
                    return true
                end
            else
                sendMessage("你不是主人呀,我不能听你的噢！")
            end
            return true
        end
    end
    for i = 1, #apps do
        if apps[i].check and apps[i].check() then
            if apps[i].run() then
                return true
            end
        end
    end
    for i = 1, #gameapps do
        if gameapps[i].check and gameapps[i].check() then
            if gameapps[i].run() then
                return true
            end
        end
    end

    --广告监听
    local advert = apiXmlReplayGet("","advert",msg)
    if advert ~= "" then
        if cqRepealMessage(id) == -42 then
            sendMessage("发现疑似广告，权限不足,请管理员手动撤回")
            return true
        end
        sendMessage("发现疑似广告已撤回,违规账号："..qq)
        return true
    end

    if admin == 1730224175 then
        if not msg:find("%[CQ:") and msg:find("崽崽") then
            
            msg = msg:gsub("崽崽", "")
            keyWord = kickSpace(keyWord)

            local replyGroup = apiXmlReplayGet(tostring(group),"common",msg)
            local replyCommon = apiXmlReplayGet("","common",msg)
            local replyrecord = apiXmlReplayGet("record\\"..apiGetVar("mettle"),"replayrecord",msg)
            if apiXmlGet("","norecord",tostring(group))=="f" then
                replyrecord = ""
            end
    
            if replyGroup == "" and replyCommon ~= "" then
                sendMessage(replyCommon)
                return true
            elseif replyGroup ~= "" and replyCommon == "" then
                sendMessage(replyGroup)
                return true
            elseif replyGroup ~= "" and replyCommon ~= "" then
                sendMessage(math.random(1,10)>=5 and replyCommon or replyGroup)
                return true
            elseif replyrecord ~= "" then
                sendMessage(cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
                return true
            end
            
            if apiXmlGet("","noimage",tostring(group))~="f" and string.len(msg) < 31 then
                apiHttpImageDownload("https://www.doutula.com/search?keyword="..msg:gsub("\r\n",""),"image".."\\"..msg:gsub("\r\n",""))
                if cqSendGroupMessage(group,cqCqCode_Image(msg:gsub("\r\n","").."\\"..math.random(1,10)..".jpg")) == -11 then
                    sendMessage(cqCqCode_Image(msg:gsub("\r\n","").."\\1.jpg") )
                end
                return true
            end
            return true
        end
        local chance = math.random(1,10)
        if chance>2 then
            return true
        end
        if not msg:find("%[CQ:") then
            local replyGroup = apiXmlReplayGet(tostring(group),"common",msg)
            local replyCommon = apiXmlReplayGet("","common",msg)
            local replyrecord = apiXmlReplayGet("record\\"..apiGetVar("mettle"),"replayrecord",msg)
            if apiXmlGet("","norecord",tostring(group))=="f" then
                replyrecord = ""
            end
    
            if replyGroup == "" and replyCommon ~= "" then
                sendMessage(replyCommon)
                return true
            elseif replyGroup ~= "" and replyCommon == "" then
                sendMessage(replyGroup)
                return true
            elseif replyGroup ~= "" and replyCommon ~= "" then
                sendMessage(math.random(1,10)>=5 and replyCommon or replyGroup)
                return true
            elseif replyrecord ~= "" then
                sendMessage(cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
                return true
            end
            
            if apiXmlGet("","noimage",tostring(group))~="f" and string.len(msg) < 31 then
                apiHttpImageDownload("https://www.doutula.com/search?keyword="..msg:gsub("\r\n",""),"image".."\\"..msg:gsub("\r\n",""))
                if cqSendGroupMessage(group,cqCqCode_Image(msg:gsub("\r\n","").."\\"..math.random(1,10)..".jpg")) == -11 then
                    sendMessage(cqCqCode_Image(msg:gsub("\r\n","").."\\1.jpg") )
                end
                return true
            end
            return true
        end
        return true
    end
    --通用回复
    if not msg:find("%[CQ:") then
        local replyGroup = apiXmlReplayGet(tostring(group),"common",msg)
        local replyCommon = apiXmlReplayGet("","common",msg)
        local replyrecord = apiXmlReplayGet("record\\"..apiGetVar("mettle"),"replayrecord",msg)
        if apiXmlGet("","norecord",tostring(group))=="f" then
            replyrecord = ""
        end

        if replyGroup == "" and replyCommon ~= "" then
            sendMessage(replyCommon)
            return true
        elseif replyGroup ~= "" and replyCommon == "" then
            sendMessage(replyGroup)
            return true
        elseif replyGroup ~= "" and replyCommon ~= "" then
            sendMessage(math.random(1,10)>=5 and replyCommon or replyGroup)
            return true
        elseif replyrecord ~= "" then
            sendMessage(cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
            return true
        end
        
        if apiXmlGet("","noimage",tostring(group))~="f" and string.len(msg) < 31 then
            apiHttpImageDownload("https://www.doutula.com/search?keyword="..msg:gsub("\r\n",""),"image".."\\"..msg:gsub("\r\n",""))
            if cqSendGroupMessage(group,cqCqCode_Image(msg:gsub("\r\n","").."\\"..math.random(1,10)..".jpg")) == -11 then
                sendMessage(cqCqCode_Image(msg:gsub("\r\n","").."\\1.jpg") )
            end
            return true
        end
        return true
    end
    

    return handled
end