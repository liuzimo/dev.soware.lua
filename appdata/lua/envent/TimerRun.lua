--[[
每分钟会被触发一次的脚本

提前收到的声明数据为：
time  定时器时间 string类型 格式 hour：min

下面的代码为我当前接待喵逻辑使用的代码，可以重写也可以按自己需求进行更改
详细请参考readme
]]

local result, info = pcall(function ()
    print = function (s)
        cqSendPrivateMessage(tostring(s))
    end
    load(cqCqCode_UnTrope(apiXmlGet("timer","timertask",time)))()
end)
if result then
    cqSendPrivateMessage(cqCode_At(qq).."定时任务成功运行")
else
    cqSendPrivateMessage(cqCode_At(qq).."定时任务运行失败\r\n"..tostring(info))
end