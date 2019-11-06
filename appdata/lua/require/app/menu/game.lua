--游戏功能菜单
return function (group,qq,msg)
    
--所有需要运行的app
return {
    {--创建人物
        check = function()
            return msg == "创建人物"
        end,
        run = function()
            local initial = require("app.assets.attribute.initial")
            sendMessage(initial(group,qq))
            return true
        end,
        explain = function()
            return "创建人物"
        end
    },
    {--每日任务
        check = function()
            return msg == "每日任务"
        end,
        run = function()
            local dailytask = require("app.assets.dailytasks.menu")
            sendMessage(dailytask())
            return true
        end,
        explain = function()
            return "每日任务"
        end
    },
    {--地图
        check = function()
            return msg == "地图"
        end,
        run = function()
            local battlemap = require("app.assets.battlemap.menu")
            sendMessage(battlemap())
            return true
        end,
        explain = function()
            return "地图"
        end
    },
    {--怪物
        check = function()
            return msg:find ("怪")
        end,
        run = function()
            local getmonster = require("app.assets.monster.menu")
            local monster = getmonster(group,qq,msg)


            if msg:lower():find("列表")then
                local allApp = {}
                for i = 1, #monster do
                    local appExplain = monster[i].explain and monster[i].explain()
                    if appExplain then
                        table.insert(allApp, appExplain)
                    end
                end
                sendMessage("怪物列表\n" ..
                table.concat(allApp, "\n") .. "\n")
                return true
            end

            for i = 1, #monster do
                if monster[i].check and monster[i].check() then
                    if monster[i].run() then
                        return true
                    end
                end
            end

            return true
        end,
        explain = function()
            return "怪物"
        end
    },
    {--人物属性
        check = function()
            return msg == "人物属性"
        end,
        run = function()
            local attribute = require("app.assets.attribute.menu")
            sendMessage(attribute(group,qq))
            return true
        end,
        explain = function()
            return "人物属性"
        end
    },
    {--打劫
        check = function()
            return msg:find("打劫%[CQ:at,qq=")==1
        end,
        run = function()
            local rob = require("app.assets.robbery")
            sendMessage(rob(group,qq,msg))
            return true
        end,
        explain = function()
            return "打劫"
        end
    },
    {--汇率查询
        check = function()
            return msg:find("汇率查询")==1
        end,
        run = function()
            sendMessage("1枚金币=520枚银币    1枚银币=520枚铜币")
            return true
        end,
        explain = function()
            return "汇率查询"
        end
    },
    {--资产查询
        check = function()
            return msg == "资产查询"
        end,
        run = function()
            local assets = apiXmlGet(tostring(group), "assets",tostring(qq))
            if assets == "" then
                assets = "500"
                apiXmlSet(tostring(group),"assets",tostring(qq),tostring(assets))
            end
            
            local getassets = require("app.assets.conversion")
            assets = getassets(tonumber(assets))
            sendMessage(cqCode_At(qq) .."你当前资产为"..assets)
            return true
        end,
        explain = function()
            return "资产查询"
        end
    },
    
}
end