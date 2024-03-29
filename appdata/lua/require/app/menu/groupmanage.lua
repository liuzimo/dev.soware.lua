--群管理菜单
return function (group,qq,msg)
    
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
            apiXmlInsert(tostring(group), "common", keyWord, answer)
            sendMessage("添加完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()--功能解释，返回为字符串，若无需显示解释，返回nil即可
            return "add    关键词:回答"
        end
    },
    {--!delall
        check = function()
            return msg:find("delall ") == 1
        end,
        run = function()
            keyWord = msg:gsub("delall ", "")
            keyWord = kickSpace(keyWord)
            apiXmlDelete(tostring(group), "common", keyWord)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord)
            return true
        end,
        explain = function()
            return "delall 关键词"
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
            apiXmlRemove(tostring(group), "common", keyWord, answer)
            sendMessage("删除完成！\n" ..
            "词条：" .. keyWord .. "\n" ..
            "回答：" .. answer)
            return true
        end,
        explain = function()
            return "del     关键词:回答"
        end
    },
    {--!list
        check = function()
            return msg:find("list ") == 1
        end,
        run = function()
            keyWord = msg:gsub("list ", "")
            keyWord = kickSpace(keyWord)
            sendMessage("本群词库内容：\n" .. apiXmlListGet(tostring(group), "common", keyWord) .. "\n\n" ..
            "全局词库内容：\n" .. apiXmlListGet("", "common", keyWord))
            return true
        end,
        explain = function()
            return "list     关键词"
        end
    },
    {--获取成员信息
        check = function()
            return msg:find("查看资料 ") == 1
        end,
        run = function()
            local dqq = msg:match("(%d+)")
            local t = cqGetMemberInfo(tonumber(group), tonumber(dqq), true)
            local info = require("app.groupmemberinfo")
            sendMessage(info(t))
            return true
        end,
        explain = function()
            return "查看资料 qq  --某个群员的信息"
        end
    },
    {--获取全部成员信息
        check = function()
            return msg:find("查看全部资料") == 1
        end,
        run = function()
            local dqq = msg:match("(%d+)")
            local tlist = cqGetMemberList(tonumber(group))
            local num = tlist[0]
            local list = tlist[1]

            for i = 0, num do
                local info = require("app.groupmemberinfo")
                sendMessage(info(list[i]))
            end
            return true
        end,
        explain = function()
            return "查看全部资料  --所有群员的信息(超管功能)"
        end
    },
    {--禁言
        check = function()
            return msg:find("禁言%[CQ:at,qq=") == 1
        end,
        run = function()
            local v = tonumber(msg:match("(%d+)%]"))
            local dmsg = msg:gsub("禁言%[CQ:at,qq="..v.."%]","")
            local t = tonumber(dmsg:match("(%d+)"))
            if t then
                cqSetGroupBanSpeak(group, v, t * 60)
                sendMessage( cqCode_At(qq) .. "已将" .. tostring(v) .. "禁言" .. tostring(t) .. "分钟")
                return true
            end
        end,
        explain = function()
            return "禁言 (超管功能)"
        end
    },
    {--解除禁言
        check = function()
            return msg:find("解除禁言") == 1
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            if q == nil then
                return "命令： 解除禁言@某个人"
            end
            cqSetGroupBanSpeak(group, q, -1)
            return true
        end,
        explain = function()
            return "解除禁言 (超管功能)"
        end
    },
    {--全员禁言
        check = function()
            return msg:find("全员禁言") == 1
        end,
        run = function()
            cqSetGroupWholeBanSpeak(group, true)
            return true
        end,
        explain = function()
            return "全员禁言 (超管功能)"
        end
    },
    {--解除全员禁言
        check = function()
            return msg:find("解除全员禁言") == 1
        end,
        run = function()
            cqSetGroupWholeBanSpeak(group, false)
            return true
        end,
        explain = function()
            return "解除全员禁言 (超管功能)"
        end
    },
    {--踢人
        check = function()
            return msg:find("踢人") == 1
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            cqSetGroupMemberRemove(group, q, false)
            sendMessage("被操作帐号: "..q.." 不再接收加群申请:否")
            return true
        end,
        explain = function()
            return "踢人 (超管功能)"
        end
    },
    {--分享链接
        check = function()
            return msg:find("创建链接") == 1
        end,
        run = function()
            local img,link,title,content = msg:match("\r\n(.+)\r\n(.+)\r\n(.+)\r\n(.+)")
            if img == nil then
                sendMessage("图片路径为空")
            elseif link == nil then
                sendMessage("链接路径为空")
            elseif title == nil then
                sendMessage("标题为空")
            elseif content == nil then
                sendMessage("内容为空")
            else
                local link = cqCqCode_ShareLink(link, title, content, img)
                sendMessage(link)
            end
            return true
        end,
        explain = function()
            return "创建链接 "
        end
    },
    {--分享群名片
        check = function()
            return msg:find("分享群名片") == 1
        end,
        run = function()
            local g = tonumber(msg:match("(%d+)"))
            if g == nil then g = 418106020 end
            local card = cqCqCode_ShareCard("group", g)
            sendMessage(card)
            return true
        end,
        explain = function()
            return "分享群名片 "
        end
    },
    {--分享QQ名片
        check = function()
            return msg:find("分享QQ名片") == 1
        end,
        run = function()
            local q = tonumber(msg:match("(%d+)"))
            if q == nil then q = 919825501 end
            local card = cqCqCode_ShareCard("qq", q)
            sendMessage(card)
            return true
        end,
        explain = function()
            return "分享QQ名片 "
        end
    },
    {--分享位置
        check = function()
            return msg:find("创建位置") == 1
        end,
        run = function()
            local localtion,description,E,W,S = msg:match("\r\n(.+)\r\n(.+)\r\n(.+)\r\n(.+)\r\n(.+)")
            if localtion == nil then
                sendMessage("地点为空")
            elseif description == nil then
                sendMessage("说明为空")
            elseif E == nil then
                E=0
            elseif W == nil then
                W=0
            elseif S == nil then
                S=0
            else
                local gps = cqCqCode_ShareGPS(localtion,description,E,W,S)
                sendMessage(gps)
            end
            return true
        end,
        explain = function()
            return "创建位置 "
        end
    },
    {--发送图片
        check = function()
            return msg:find("发送图片") == 1
        end,
        run = function()
            local path = msg:gsub("发送图片","")
            local gps = cqCqCode_Image(path)
            sendMessage(gps)
            return true
        end,
        explain = function()
            return "发送图片 "
        end
    },
    {--发送语音
        check = function()
            return msg:find("发送语音") == 1
        end,
        run = function()
            local path = msg:gsub("发送语音","")
            local record = cqCqCode_Record(path)
            sendMessage(record)
            return true
        end,
        explain = function()
            return "发送语音 "
        end
    },
    {--该群不说话
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("闭嘴")or msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("别说话")
        end,
        run = function()
            apiXmlSet("","Shutup",tostring(group),"f")
            sendMessage("我先走了,有事再叫我噢！")
            return true
        end,
        explain = function()
            return "闭嘴  或者 别说话"
        end
    },
    {--不发语音
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("不可以发语音")
        end,
        run = function()
            apiXmlSet("","norecord",tostring(group),"f")
            sendMessage("好的我不发语音了")
            return true
        end,
        explain = function()
            return "不可以发语音"
        end
    },
    {--不发图片
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("不可以发图")
        end,
        run = function()
            apiXmlSet("","noimage",tostring(group),"f")
            sendMessage("好的我不发图了")
            return true
        end,
        explain = function()
            return "不可以发图片"
        end
    },
    {--发语音
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("可以发语音")
        end,
        run = function()
            apiXmlSet("","norecord",tostring(group),"t")
            sendMessage("可以发语音咯")
            return true
        end,
        explain = function()
            return "可以发语音"
        end
    },
    {--发图片
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:find("可以发图")
        end,
        run = function()
            apiXmlSet("","noimage",tostring(group),"t")
            sendMessage("可以发图咯")
            return true
        end,
        explain = function()
            return "可以发图片"
        end
    },
    {--进群欢迎语
        check = function()
            return msg:find("进群欢迎语")==1
        end,
        run = function()
            local key = msg:gsub("进群欢迎语","")
            key = kickSpace(key)
            apiXmlSet(tostring(group),"welcome","welcome",key)
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "进群欢迎语  --只发送命令表示不欢迎"
        end
    },
    {--邀请统计回复设置
        check = function()
            return msg:find("邀请统计回复")==1
        end,
        run = function()
            local key = msg:gsub("邀请统计回复","")
            key = kickSpace(key)
            apiXmlSet(tostring(group),"invitcountrel","countrel",key)
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "邀请统计回复  --只发送命令表示默认"
        end
    },
    {--控制邀请统计
        check = function()
            return msg:find("邀请统计")==1
        end,
        run = function()
            local key = msg:gsub("邀请统计","")
            key = kickSpace(key)
            if key == "开启" then
                apiXmlSet(tostring(group),"invitcount","is","1")
            elseif key == "关闭" then
                apiXmlSet(tostring(group),"invitcount","is","0")
            end
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "邀请统计开启/关闭"
        end
    },
    {--邀请成功回复设置
        check = function()
            return msg:find("邀请成功回复")==1
        end,
        run = function()
            local key = msg:gsub("邀请成功回复","")
            key = kickSpace(key)
            apiXmlSet(tostring(group),"invitsuccess","success",key)
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "邀请成功回复  --只发送命令表示默认"
        end
    },
    {--退群通知消息设置
        check = function()
            return msg:find("退群通知消息")==1
        end,
        run = function()

            if msg:find("退群通知消息主动")==1 then
                local key = msg:gsub("退群通知消息主动","")
                key = kickSpace(key)
                apiXmlSet(tostring(group),"groupoutrel","passive",key)
            elseif msg:find("退群通知消息被动")==1 then
                local key = msg:gsub("退群通知消息被动","")
                key = kickSpace(key)
                apiXmlSet(tostring(group),"groupoutrel","active",key)
            end
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "退群通知消息主动/被动  --只发送命令表示默认"
        end
    },
    {--退群通知控制
        check = function()
            return msg:find("退群通知")==1
        end,
        run = function()
            local key = msg:gsub("退群通知","")
            key = kickSpace(key)
            if key == "开启" then
                apiXmlSet(tostring(group),"groupout","is","1")
            elseif key == "关闭" then
                apiXmlSet(tostring(group),"groupout","is","0")
            end
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "退群通知开启/关闭"
        end
    },
    {--图片检测
        check = function()
            return msg:find("图片检测")==1
        end,
        run = function()
            local key = msg:gsub("图片检测","")
            key = kickSpace(key)
            if key == "开启" then
                apiXmlSet("","imgraise",tostring(group),"t")
            elseif key == "关闭" then
                apiXmlSet("","imgraise",tostring(group),"f")
            end
            sendMessage("设置成功")
            return true
        end,
        explain = function()
            return "图片检测开启/关闭"
        end
    },
}
end