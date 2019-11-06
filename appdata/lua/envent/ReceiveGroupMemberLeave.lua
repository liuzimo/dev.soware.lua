--[[
处理收到的群成员减少事件

提前收到的声明数据为：
fromqq      被操作qq号码    number类型
fromgroup   消息的群号码    number类型
operateqq   操作者qq号码    number类型  如果为自己退群，此值为nil

注意：拦截消息后请将变量handled置true，表示消息已被拦截，如：
handled = true

下面的代码为我当前接待喵逻辑使用的代码，可以重写也可以按自己需求进行更改
详细请参考readme
]]

--是否开启退群通知
local is= apiXmlGet(tostring(fromgroup),"groupout","is")
if is == "1" then   
    if operateqq+0~=fromqq then

        local active = apiXmlGet(tostring(fromgroup),"groupoutrel","active")
        local passive = apiXmlGet(tostring(fromgroup),"groupoutrel","passive")

        cqSendGroupMessage(fromgroup,cqCode_At(operateqq).."将" ..fromqq.."踢出本群\n"..active)
        return true
    end
    if not passive then
        passive = ""
    end
    cqSendGroupMessage(fromgroup,tostring(fromqq).."主动离开了本群\n"..passive)
end
--[[
if fromgroup == 241464054 then
    local player = apiXmlGet("bindQq",tostring(fromqq))
    if player ~= "" then
        apiTcpSend("lp user "..player.." permission set group.default",true)
        apiTcpSend("lp user "..player.." permission unset group.whitelist",true)
    end
    apiXmlDelete("bindStep",tostring(fromqq))
    apiXmlDelete("bindQq",tostring(fromqq))
end
]]
