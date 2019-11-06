--统一的消息处理函数
local msg, qq, group, id = nil, nil, nil, nil
local handled = false

--发送消息
function sendMessage(s)
    cqSendPrivateMessage(qq, s)
end


--对外提供的函数接口
return function(inmsg, inqq, ingroup, inid)
    msg, qq, group, id = inmsg, inqq, ingroup, inid
    local getapp = require("app.menu.privatefeatures")
    local apps = getapp(qq,msg)
    local getadminapp = require("app.menu.privatemanage")
    local adminapps = getadminapp(qq,msg)

    --匹配是否需要获取帮助
    if msg:lower():find("help") == 1 or msg:lower():find("菜单") == 1 or msg:lower():find("帮助") == 1 then
        local allApp = {}
        for i = 1, #apps do
            local appExplain = apps[i].explain and apps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("功能列表\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end
    --匹配是否需要获取管理
    if msg:lower():find("manage") == 1 or msg:lower():find("管理") == 1 then
        local allApp = {}
        for i = 1, #adminapps do
            local appExplain = adminapps[i].explain and adminapps[i].explain()
            if appExplain then
                table.insert(allApp, appExplain)
            end
        end
        sendMessage("管理功能(以下操作为全局设置)\n" ..
        table.concat(allApp, "\n") .. "\n")
        return true
    end
    --遍历所有功能
    for i = 1, #adminapps do
        if adminapps[i].check and adminapps[i].check() then
            if qq == admin then
                if adminapps[i].run() then
                    return true
                end
            else
                sendMessage("权限不足！你不是主人！")
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

   --通用回复
   if not msg:find("%[CQ:") then
        -- local replyCommon = apiXmlReplayGet("", "common", msg)
        -- sendMessage(replyCommon)
        local replyCommon = apiXmlReplayGet("","common",msg)
        local replyrecord = apiXmlReplayGet("record\\"..apiGetVar("mettle"),"replayrecord",msg)
        if replyrecord == "" and replyCommon ~= "" then
            sendMessage(replyCommon)
            return true
        elseif replyrecord ~= "" and replyCommon == "" then
            sendMessage(cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
            return true
        elseif replyrecord ~= "" and replyCommon ~= "" then
            sendMessage(math.random(1,10)>=5 and replyCommon or cqCqCode_Record(apiGetVar("mettle").."\\"..replyrecord))
            return true
        end
        if string.len(msg) < 45 then
            apiHttpImageDownload("https://www.doutula.com/search?keyword="..msg:gsub("\r\n",""),"image".."\\"..msg:gsub("\r\n",""))
            if cqSendPrivateMessage(qq,cqCqCode_Image(msg:gsub("\r\n","").."\\"..math.random(1,10)..".jpg")) == -11 then
                sendMessage(cqCqCode_Image(msg:gsub("\r\n","").."\\1.jpg") )
            end
            return true
        end
        return true
    end
    return handled
end