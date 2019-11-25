--全局管理菜单
return function (qq,msg)
    
--所有需要运行的app
return {
    {--!add
        check = function()--检查函数，拦截则返回true
            return msg:find("add ") == 1
        end,
        run = function()--匹配后进行运行的函数
            msg = msg:gsub("add ", "")
            local keyWord, answer = msg:match("(.+):(.+)")
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage("格式 add 123:123") return true
            end
            apiXmlInsert("", "common", keyWord, answer)
            sendMessage("添加完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "add 关键词:回答\n--添加某关键字对应的回复"
        end
    },
    {--!del
        check = function()
            return msg:find("del ") == 1
        end,
        run = function()
            msg = msg:gsub("del ", "")
            local keyWord, answer = msg:match("(.+):(.+)")
            keyWord = kickSpace(keyWord)
            answer = kickSpace(answer)
            if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
                sendMessage("格式 del 123:123") return true
            end
            apiXmlRemove("", "common", keyWord, answer)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()
            return "del 关键词:回答\n--删除该关键字对应的一条回复"
        end
    },
    {--!delall
        check = function()
            return msg:find("delall ") == 1
        end,
        run = function()
            keyWord = msg:gsub("delall ", "")
            keyWord = kickSpace(keyWord)
            apiXmlDelete("", "common", keyWord)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord)
            return true
        end,
        explain = function()
            return "delall 关键词\n--删除该关键字对应的所有回复"
        end
    },
    {--!list
        check = function()
            return msg:find("list ") == 1
        end,
        run = function()
            keyWord = msg:gsub("list ", "")
            keyWord = kickSpace(keyWord)
            sendMessage("全局词库内容：\n" .. apiXmlListGet("", "common", keyWord))
            return true
        end,
        explain = function()
            return "list 关键词\n--显示该关键字对应的回复"
        end
    },
    {--!addgroupadmin
        check = function()
            return msg:find("addgroupadmin ") == 1
        end,
        run = function()
            msg = msg:gsub("addgroupadmin ", "")
            local ingroup, inqq = msg:match("(.+):(.+)")
            ingroup = kickSpace(ingroup)
            inqq = kickSpace(inqq)
            if ingroup:len() == 0 and inqq:len() == 0 and tonumber(ingroup) == nil and tonumber(inqq) == nil then
                sendMessage("格式 addgroupadmin 群号:qq") return true
            end
            local dlist = apiXmlIdListGet("", "grouplist")
            local num = dlist[0]
            local list = dlist[1]
            for i = 0, num do
                if ingroup == list[i] then
                    apiXmlSet(ingroup, "adminList", inqq, "admin")
                    sendMessage("群:" .. ingroup .. "\n添加管理员:" .. inqq)
                    cqSendGroupMessage(tonumber(ingroup), "添加本群机器管理员:" .. inqq)
                    return true
                end
            end
            sendMessage("Q群不存在")
            return true
        end,
        explain = function()
            return "addgroupadmin 群号:qq\n--添加某群的群管理"
        end
    },
    {--!delgroupadmin
        check = function()
            return msg:find("delgroupadmin ") == 1
        end,
        run = function()
            msg = msg:gsub("delgroupadmin ", "")
            local ingroup, inqq = msg:match("(.+):(.+)")
            ingroup = kickSpace(ingroup)
            inqq = kickSpace(inqq)
            if ingroup:len() == 0 and inqq:len() == 0 and tonumber(ingroup) == nil and tonumber(inqq) == nil then
                sendMessage("格式 delgroupadmin 群号:qq") return true
            end
            local dlist = apiXmlIdListGet("", "grouplist")
            local num = dlist[0]
            local list = dlist[1]
            for i = 0, num do
                if ingroup == list[i] then
                    apiXmlDelete(ingroup, "adminList", inqq)
                    sendMessage("群:" .. ingroup .. "\n删除管理员:" .. inqq)
                    cqSendGroupMessage(tonumber(ingroup), "删除本群机器管理员:" .. inqq)
                    return true
                end
            end
            sendMessage("Q群不存在")
            return true
        end,
        explain = function()
            return "delgroupadmin 群号:qq\n--删除某群对应的群管理"
        end
    },
    {--!addadmin
        check = function()
            return msg:find("addadmin ") == 1
        end,
        run = function()
            local keyWord = msg:match("(%d+)")
            apiXmlSet("", "adminList", keyWord, "admin")
            sendMessage("已添加狗管理" .. keyWord)
            return true
        end,
        explain = function()
            return "addadmin qq\n--添加超管"
        end
    },
    {--!deladmin
        check = function()
            return msg:find("deladmin ") == 1
        end,
        run = function()
            local keyWord = msg:match("(%d+)")
            apiXmlDelete("", "adminList", keyWord)
            sendMessage("已宰掉狗管理" .. keyWord)
            return true
        end,
        explain = function()
            return "deladmin qq\n--删除超管"
        end
    },
    {--初始化群列表
        check = function()
            return msg:find("初始化群列表") == 1
        end,
        run = function()

            --初始化群列表
            local grouplist = cqGetGroupList()
            local n = grouplist[0]
            local list = grouplist[1]
            local rootPath = apiGetAsciiHex(apiGetPath())
            rootPath = rootPath:gsub("[%s%p]", ""):upper()
            rootPath = rootPath:gsub("%x%x", function(c)
                return string.char(tonumber(c, 16))
            end)
            os.remove(rootPath .. "data/app/"..apiGetAppName().."/xml/grouplist.xml")
            for i = 0, n do
                apiXmlSet("", "grouplist", tostring(list[i]["Id"]), "")
            end
            sendMessage("初始化群列表完成,数量:" .. tostring(n+1))
            return true
        end,
        explain = function()
            return "初始化群列表\n--获取所有群的群号码,保存文本"
        end
    },
    {--获取群列表
        check = function()
            return msg:find("群列表") == 1
        end,
        run = function()
            local dlist = apiXmlIdListGet("", "grouplist")
            local num = dlist[0]
            local list = dlist[1]
            local n = ""
            for i = 0, num do
                if i==num then
                    n = n .. list[i]
                    break
                end
                n = n .. list[i] .. "\n"
            end
            sendMessage(n)
            return true
        end,
        explain = function()
            return "群列表\n--需先初始化群列表,输出所有群的群号码"
        end
    },
    {--初始化群成员
        check = function()
            return msg:find("初始化群 ") == 1
        end,
        run = function()
            local key = msg:match("(%d+)")
            local t = cqGetMemberList(tonumber(key))
            local nums = t[0]
            local lists = t[1]
            for s = 0, nums do
                local ls = lists[s]
                apiXmlSet(key, "memberlist", tostring(ls["QQ"]), "")
            end
            sendMessage("群成员初始化完成,人数:" .. tostring(nums + 1))
            return true
        end,
        explain = function()
            return "初始化群 群号\n--获取该群内所有群员QQ,保存文本"
        end
    },
    {--群发
        check = function()
            return msg:find("群发 ") == 1
        end,
        run = function()
            keyWord = msg:gsub("群发 ", "")
            local t = apiXmlIdListGet("", "grouplist")
            local nums = t[0]
            local lists = t[1]
            for i = 0, nums do
                if cqSendGroupMessage(tonumber(lists[i]), keyWord) == -34 then
                    --在群内被禁言了，直接退群
                    cqSetGroupExit(tonumber(lists[i]))
                end
            end
            sendMessage("群发完成,数量:" .. tostring(nums + 1))
            return true
        end,
        explain = function()
            return "群发 内容\n--需先初始化群列表,群内被禁言将直接退群"
        end
    },
    {--退群
        check = function()
            return msg:find("退群") == 1
        end,
        run = function()
            local key = msg:match("(%d+)")
            if key then
                cqSetGroupExit(tonumber(key))
                return true
            end
            sendMessage("请输入要退出的群号")
            return true
        end,
        explain = function()
            return "退群 群号\n--退出该群"
        end
    },
    {--运行lua脚本
        check = function()
            return msg:find("#") == 1
        end,
        run = function()
            if qq == admin then
                local result, info = pcall(function ()
                    print = function (s)
                        sendMessage(tostring(s))
                    end
                    load(cqCqCode_UnTrope(msg:sub(2)))()
                end)
                if result then
                    sendMessage("成功运行")
                else
                    sendMessage("运行失败\r\n"..tostring(info))
                end
            else
                sendMessage(apiSandBox(cqCqCode_UnTrope(msg:sub(2))))
            end
            return true
        end,
    },
    {--机器人唤醒词设置
        check = function()
            return msg:find("唤醒词") == 1
        end,
        run = function()
            name = msg:gsub("唤醒词",""):trim()
            apiXmlSet("","settings", "name",name)
            sendMessage("在群里叫我"..name..",我就会回复你啦！")
            return true
        end,
        explain = function()
            return "唤醒词"
        end
    },
    {--机器人回复概率设置
        check = function()
            return msg:find("回复概率") == 1
        end,
        run = function()
            probability = msg:gsub("回复概率",""):trim()
            apiXmlSet("","settings", "probability",probability)
            sendMessage("当前群内回复概率调整为"..probability.."0%")
            return true
        end,
        explain = function()
            return "回复概率 + 0~10 (10为百分百)"
        end
    },
    {--语音性格设置
        check = function()
            return msg:find("语音性格设置") == 1
        end,
        run = function()
            mettle = msg:gsub("语音性格设置",""):trim()
            return true
        end,
        explain = function()
            return "语音性格设置"
        end
    },
    {--关键字监听设置
        check = function()
            return msg:find("添加监听")==1
        end,
        run = function()
            local keys = msg:gsub("添加监听","")
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlSet("","Monitor",key[i]:trim(),"1")
            end
            sendMessage("添加成功")
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "添加监听 1,2,3,4"
        end
    },
    {--关键字监听删除
        check = function()
            return msg:find("删除监听")==1
        end,
        run = function()
            local keys = msg:gsub("删除监听","")
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlRemove("","Monitor",key[i]:trim(),"1")
            end
            sendMessage("删除成功")
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "删除监听 1,2,3,4"
        end
    },
    {--监听列表
        check = function()
            return msg:find("监听列表") == 1
        end,
        run = function()
            local dlist = apiXmlIdListGet("", "Monitor")
            local num = dlist[0]
            local list = dlist[1]
            local n = ""
            for i = 0, num do
                if i==num then
                    n = n .. list[i]
                    break
                end
                n = n .. list[i] .. "\n"
            end
            sendMessage("监听关键字：\n" ..n ) 
            return true
        end,
        explain = function()
            return "监听列表"
        end
    },
    {--监听转发QQ
        check = function()
            return msg:find("监听QQ") == 1
        end,
        run = function()
            local key = msg:match("(%d+)")
            apiXmlSet("","Monitorlog","qq",key)
            return true
        end,
        explain = function()
            return "监听QQ"
        end
    },
    {--开启监听
        check = function()
            return msg:find("开启监听") == 1
        end,
        run = function()
            apiXmlSet("","Monitorlog","Monitor","t")
            sendMessage("开启成功")
            return true
        end,
        explain = function()
            return "开启监听"
        end
    },
    {--关闭监听
        check = function()
            return msg:find("关闭监听") == 1
        end,
        run = function()
            apiXmlSet("","Monitorlog","Monitor","f")
            sendMessage("关闭成功")
            return true
        end,
        explain = function()
            return "关闭监听"
        end
    },
    {--广告关键字设置
        check = function()
            return msg:find("添加广告")==1
        end,
        run = function()
            local keys = msg:gsub("添加广告","")
            keys = kickSpace(keys)
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlSet("","advert",key[i]:trim(),"1")
            end
            sendMessage("添加成功")
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "添加广告 1,2,3,4"
        end
    },
    {--广告关键字删除
        check = function()
            return msg:find("删除广告")==1
        end,
        run = function()
            local keys = msg:gsub("删除广告","")
            keys = kickSpace(keys)
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlRemove("","advert",key[i]:trim(),"1")
            end
            sendMessage("删除成功")
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "删除广告 1,2,3,4"
        end
    },
    {--广告列表
        check = function()
            return msg:find("广告列表") == 1
        end,
        run = function()
            local dlist = apiXmlIdListGet("", "advert")
            local num = dlist[0]
            local list = dlist[1]
            local n = ""
            for i = 0, num do
                if i==num then
                    n = n .. list[i]
                    break
                end
                n = n .. list[i] .. "\n"
            end
            sendMessage("广告关键字：\n" ..n ) 
            return true
        end,
        explain = function()
            return "广告列表"
        end
    },
    {--添加定时任务
        check = function()
            return msg:find("添加定时") == 1
        end,
        run = function()
            local keys = msg:gsub("添加定时","")
            local key = keys:split(":")
            apiXmlSet("timer","timertask",key[1]:trim()..":"..key[2]:trim(),key[3])
            apiUpdateTimerTask()
            sendMessage("添加成功")
            return true
        end,
        explain = function()
            return "添加定时任务 时:分：代码"
        end
    },
    {--定时任务删除
        check = function()
            return msg:find("删除定时")==1
        end,
        run = function()
            local keys = msg:gsub("删除定时","")
            keys = kickSpace(keys)
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlDelete("timer","timertask",key[i]:trim())
            end
            sendMessage("删除成功")
            return true
        end,
        explain = function()
            return "删除定时 1,2,3,4"
        end
    },
    {--定时列表
        check = function()
            return msg:find("定时列表") == 1
        end,
        run = function()
            local dlist = apiXmlIdListGet("timer", "timertask")
            local num = dlist[0]
            local list = dlist[1]
            local n = ""
            for i = 0, num do
                if i==num then
                    n = n .. list[i]
                    break
                end
                n = n .. list[i] .. "\n"
            end
            sendMessage("定时列表：\n" ..n ) 
            return true
        end,
        explain = function()
            return "定时列表"
        end
    },
    {--添加自定义脚本
        check = function()
            return msg:find("添加脚本") == 1
        end,
        run = function()
            local keys = msg:gsub("添加脚本","")
            keys = kickSpace(keys)
            local key = keys:split(":")
            apiXmlSet("script","script",key[1],key[2])
            apiUpdateTimerTask()
            sendMessage("添加成功")
            return true
        end,
        explain = function()
            return "添加自定义脚本"
        end
    },
    {--自定义脚本删除
        check = function()
            return msg:find("删除脚本")==1
        end,
        run = function()
            local keys = msg:gsub("删除脚本","")
            keys = kickSpace(keys)
            local key
            if keys:find(",")~=nil then
                key = keys:split(",")
            else
                key = keys:split("，")
            end
            for i=1,#key do
                apiXmlDelete("script","script",key[i])
            end
            sendMessage("删除成功")
            return true
        end,
        explain = function()
            return "删除脚本 1,2,3,4"
        end
    },
    {--脚本列表
        check = function()
            return msg:find("脚本列表") == 1
        end,
        run = function()
            local dlist = apiXmlIdListGet("script", "script")
            local num = dlist[0]
            local list = dlist[1]
            local n = ""
            for i = 0, num do
                if i==num then
                    n = n .. list[i]
                    break
                end
                n = n .. list[i] .. "\n"
            end
            sendMessage("脚本列表：\n" ..n ) 
            return true
        end,
        explain = function()
            return "脚本列表"
        end
    }, 
    {--执行脚本
        check = function()
            return msg:find("执行脚本") == 1
        end,
        run = function()
            local keys = msg:gsub("执行脚本","")
            keys = kickSpace(keys)
            local script = apiXmlGet("script","script",keys)
            if script == "" then
                return true
            end
            local result, info = pcall(function ()
                print = function (s)
                    sendMessage(tostring(s))
                end
                load(cqCqCode_UnTrope(script))()
            end)
            if result then
                sendMessage("脚本成功运行")
            else
                sendMessage("脚本运行失败\r\n"..tostring(info))
            end
        end,
        explain = function()
            return "执行脚本"
        end
    },
    {--更新版本
        check = function()
            return msg:find("版本升级") == 1
        end,
        run = function()
            --sendMessage(apiUpdateScript())
            -- local path = apiGetPath().."data\\app\\"..apiGetAppName().."\\.git"
            
            -- os.execute("start cmd /c rd /s /q \""..path.."\"")
            -- os.remove(path)
            -- sendMessage("rd /s /q \""..path.."\"")
            apiTimerStart()
            apiSetTimerScriptWait(0)
            sendMessage("当前更新方式为实时监测，每12小时自动更新，#apiSetTimerScriptWait(600) 设置更新频率(秒)，重启应用关闭，执行本命令可立刻更新")
            apiSetTimerScriptWait(7200)
        end,
        explain = function()
            return "版本升级"
        end
    },
    {--清理数据
        check = function()
            return msg:find("清理数据") == 1
        end,
        run = function()
            sendMessage(apiDelCache())
        end,
        explain = function()
            return "清理数据 --清理过期图片，语音"
        end
    },
    -- {--站长短链接
    -- check = function()
    --     return msg:find("短链接") == 1
    -- end,
    -- run = function()
    --     local keys = msg:gsub("短链接","")
    --     keys = encodeURI(kickSpace(keys))
    --     local surl = apiHttpPost("http://tool.chinaz.com/tools/dwz.aspx","longurl="..keys.."&aliasurl="):match("shorturl\">(.-)</span>")
    --     if surl == nil then
    --         sendMessage("请输入正确的网址")
    --         return true
    --     end
    --     sendMessage(surl)
    -- end,
    -- explain = function()
    --     return "短链接"
    -- end
    -- },
    {--腾讯短链接
    check = function()
        return msg:find("短链接") == 1
    end,
    run = function()
        local keys = msg:gsub("短链接","")
        keys = encodeURI(kickSpace(keys))
        local surl = apiHttpGet("https://sa.sogou.com/gettiny?url="..keys)
        if surl == nil then
            sendMessage("请输入正确的网址")
            return true
        end
        sendMessage(surl)
    end,
    explain = function()
        return "短链接"
    end
    },
    {--商品查询
    check = function()
        return msg:find("淘宝搜索") == 1
    end,
    run = function()
        local taobaosearch = require("app.taobaosearch")
        taobaosearch(qq,msg,true)
        return true
    end,
    explain = function()
        return "淘宝搜索 + 商品关键字   --销量前三商品店铺"
    end
    },
}
end