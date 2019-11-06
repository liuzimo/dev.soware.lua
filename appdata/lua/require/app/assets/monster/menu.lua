--怪物图鉴
return function (group,qq,msg)
    return {
        {--嘤嘤怪
            check = function()
                return msg == "嘤嘤怪"
            end,
            run = function()
                local yyg = require("app.assets.monster.yyg")
                sendMessage(yyg())
                return true
            end,
            explain = function()
                return "嘤嘤怪"
            end
        }, 
        {--大大怪
            check = function()
                return msg == "大大怪"
            end,
            run = function()
                local ddg = require("app.assets.monster.ddg")
                sendMessage(ddg())
                return true
            end,
            explain = function()
                return "大大怪"
            end
        }, 
    }
end