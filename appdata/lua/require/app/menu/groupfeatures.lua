--群功能菜单
return function (group,qq,msg,id)
    
--所有需要运行的app
return {

    {--撤回
        check = function()
            return msg:find("支持所有") or msg:find("来不及解释") or msg:find("急急急") or msg:find("帮我点一下") or msg:find("点击链接")
        end,
        run = function()
            if cqRepealMessage(id) == -42 then
                sendMessage("发现疑似广告，权限不足,请管理员手动撤回")
                return true
            end
            sendMessage("发现疑似广告已撤回,违规账号："..qq)
            return true
        end,
    },
    {--今日运势
        check = function()
            return msg == "今日运势" or msg == "明日运势" or msg == "昨日运势"
        end,
        run = function()
            local getAlmanac = require("app.almanac")
            sendMessage(cqCode_At(qq) .. getAlmanac(qq))
            return true
        end,
        explain = function()
            return "昨日/今日/明日运势"
        end
    },
    {--查快递
        check = function()
            return msg:find("查快递") == 1
        end,
        run = function()
            local express = require("app.express.express")
            local m = express(msg,qq)
            sendMessage(m)
            return true
        end,
        explain = function()
            return "查快递"
        end
    },
    {--快递选择
        check = function()
            return msg:find("快递选择") == 1
        end,
        run = function()
   
            local expresschoose = require("app.express.expresschoose")
            local m = expresschoose(msg,qq)
            sendMessage(m)
            return true
        end,
    },
    {--快递推送订阅
    check = function()
        return msg:find("订阅") == 1
    end,
    run = function()
        local expressub = require("app.express.expressub")
        local m = expressub(msg, group,qq)
        sendMessage(m)
        return true
    end,
    explain = function()
        return "订阅快递"
    end
    },
    {--空气质量
        check = function()
            return msg:find("空气质量") == 1
        end,
        run = function()
            local air = require("app.air")
            sendMessage(cqCode_At(qq) .. "\r\n" .. air(msg))
            return true
        end,
        explain = function()
            return "空气质量"
        end
    },
    {--点歌
        check = function()
            return msg:find("点歌") == 1
        end,
        run = function()
            local qqmusic = require("app.qqmusic")
            sendMessage(qqmusic(msg))
            return true
        end,
        explain = function()
            return "点歌 加 qq音乐id或歌名"
        end
    },
    {--查动画
        check = function()
            return msg:find("查动画") or msg:find("搜动画") or msg:find("查番") or msg:find("搜番")
        end,
        run = function()
            local animeSearch = require("app.animeSearch")
            sendMessage(cqCode_At(qq) .. "\r\n" .. animeSearch(msg))
            return true
        end,
        explain = function()
            return "查动画 加 没裁剪过的视频截图"
        end
    },
    {--抽奖
        check = function()
            return msg == "抽奖" or msg:find("禁言") == 1
        end,
        run = function()
            local banplay = require("app.bancard")
            sendMessage(banplay(msg, qq, group))
            return true
        end,
        explain = function()
            return "抽奖/禁言卡"
        end
    },
    {--签到
        check = function()
            return msg == "签到" or msg:find("%[CQ:rich,") == 1
        end,
        run = function()
            local sign = require("app.sign")
            sendMessage(cqCode_At(qq) .. sign(qq, group))
            return true
        end,
        explain = function()
            return "签到"
        end
    },
    {--b站av号解析
        check = function()
            return msg:find("av%d+")
        end,
        run = function()
            local av = require("app.av")
            sendMessage(av(msg))
            return true
        end,
        explain = function()
            return "b站av号解析"
        end
    },
    {--一言
        check = function()
            return msg == "一言"
        end,
        run = function()
            local hitokoto = require("app.hitokoto")
            sendMessage(hitokoto())
            return true
        end,
        explain = function()
            return "一言"
        end
    },
    {--必应美图
        check = function()
            return msg:find("必应") == 1 and (message:find("美图") or message:find("壁纸"))
        end,
        run = function()
            local bing = require("app.bing")
            sendMessage(bing())
            return true
        end,
        explain = function()
            return "必应壁纸"
        end
    },
    {--短故事
        check = function()
            return msg:find("小故事")==1
        end,
        run = function()
            local story = require("app.tianxinapi.story")
            sendMessage(story())
            return true
        end,
        explain = function()
            return "小故事"
        end
    },
    {--翻译
        check = function()
            return msg:find("翻译")==1
        end,
        run = function()
            local translate = require("app.tianxinapi.translate")
            sendMessage(translate(msg))
            return true
        end,
        explain = function()
            return "翻译"
        end
    },
    {--文字识别
        check = function()
            return msg:find("文字识别")==1
        end,
        run = function()
            local textocr = require("app.baiduapi.textocr")
            sendMessage(textocr(qq,msg))
            return true
        end,
        explain = function()
            return "文字识别"
        end
    },
    {--图像识别
        check = function()
            return msg:find("图像识别")==1
        end,
        run = function()
            local imageocr = require("app.baiduapi.imageocr")
            sendMessage(imageocr(qq,msg))
            return true
        end,
        explain = function()
            return "图像识别"
        end
    },
    {--手机端图片延迟输入
        check = function()
            return msg:find("%[CQ:image,file=")==1
        end,
        run = function()
            if tonumber(apiXmlGet("","imageocr",tostring(qq))) == 0 then 
                local imageocr = require("app.baiduapi.imageocr")
                sendMessage(imageocr(qq,msg))
            elseif tonumber(apiXmlGet("","textocr",tostring(qq))) == 0 then 
                local textocr = require("app.baiduapi.textocr")
                sendMessage(textocr(qq,msg))
            elseif tonumber(apiXmlGet("","qrocr",tostring(qq))) == 0 then 
                local QRocr = require("app.QRocr")
                sendMessage(QRocr(qq,msg))
            end
            return true
        end,
    },
    {--二维码生成
        check = function()
            return msg:find("二维码生成")==1
        end,
        run = function()
            local key = msg:gsub("二维码生成","")
            if apiQREncode(key) < 0 then
                sendMessage("数据过长")
                return true
            end
            sendMessage(cqCqCode_Image("qr.jpg"))
            return true
        end,
        explain = function()
            return "二维码生成"
        end
    },
    {--二维码logo生成
        check = function()
            return msg:find("二维码logo生成")==1
        end,
        run = function()
            local key = msg:gsub("二维码logo生成","")
            apiCombinImage("qr.jpg","logo.png")
            sendMessage(cqCqCode_Image("add.jpg"))
            return true
        end,
        explain = function()
            return "二维码logo生成"
        end
    },
    {--二维码解码
        check = function()
            return msg:find("二维码解码")==1
        end,
        run = function()
            local QRocr = require("app.QRocr")
            sendMessage(QRocr(qq,msg))
            return true
        end,
        explain = function()
            return "二维码解码"
        end
    },
    {--@触发
        check = function()
            return msg:find("%[CQ:at,qq=" .. cqGetLoginQQ() .. "%]") and msg:gsub("%[CQ:.-%]", ""):len() > 2
        end,
        run = function()
            sendMessage("我被猪@了")
            return true
        end,
    },
    {--表情彩蛋
        check = function()
            return msg:find("%[CQ:face") and msg:find("21") 
        end,
        run = function()
            -- local same= math.random(1, 39)
            local same= 66
            local m=""
            m = m.."              [CQ:face,id="..same.."]  ".."[CQ:face,id="..same.."]          ".."[CQ:face,id="..same.."]  ".."[CQ:face,id="..same.."]".."\n"
            m = m.."          [CQ:face,id="..same.."]              ".."[CQ:face,id="..same.."]              ".."[CQ:face,id="..same.."]    ".."\n"
            m = m.."            [CQ:face,id="..same.."]             ".."                 [CQ:face,id="..same.."]   ".."\n"
            m = m.."                [CQ:face,id="..same.."]                       ".."[CQ:face,id="..same.."]                         ".."\n"
            m = m.."                     [CQ:face,id="..same.."]       ".."      ".."[CQ:face,id="..same.."]             ".."\n"
            m = m.."                              [CQ:face,id="..same.."]                                 "
            sendMessage(m)
            return true
        end,
    }
    }
end
