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
            os.remove(rootPath .. "data/app/com.robot.soware/xml/grouplist.xml")
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
            return msg:find("#lua") == 1
        end,
        run = function()
            if qq == admin then
                local result, info = pcall(function ()
                    print = function (s)
                        sendMessage(tostring(s))
                    end
                    load(cqCqCode_UnTrope(msg:sub(5)))()
                end)
                if result then
                    sendMessage(cqCode_At(qq).."成功运行")
                else
                    sendMessage(cqCode_At(qq).."运行失败\r\n"..tostring(info))
                end
            else
                sendMessage(cqCode_At(qq).."\r\n"..apiSandBox(cqCqCode_UnTrope(msg:sub(5))))
            end
            return true
        end,
    },
    {--语音性格设置
        check = function()
            return msg:find("语音性格设置") == 1
        end,
        run = function()
            local mettle = msg:gsub("语音性格设置","")
            apiSetVar("mettle", mettle)
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
                apiXmlSet("","Monitor",key[i],"1")
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
                apiXmlRemove("","Monitor",key[i],"1")
            end
            sendMessage("删除成功")
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "删除监听 1,2,3,4"
        end
    },
    {--!监听列表
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
            apiXmlSet("","Monitor","qq",key)
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
            apiXmlSet("","Monitor","Monitor","t")
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
            apiXmlSet("","Monitor","Monitor","f")
            sendMessage("关闭成功")
            return true
        end,
        explain = function()
            return "关闭监听"
        end
    },
    {--开启定时任务
        check = function()
            return msg:find("开启定时任务") == 1
        end,
        run = function()
            apiTimerStart()
            sendMessage("开启成功")
            return true
        end,
        explain = function()
            return "开启定时任务"
        end
    },
}
end