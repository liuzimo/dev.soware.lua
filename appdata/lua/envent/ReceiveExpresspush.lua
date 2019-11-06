--[[处理收到的快递推送消息

提前收到的声明数据为：
data json数据     string类型

下面的代码为我当前接待喵逻辑使用的代码，可以重写也可以按自己需求进行更改
详细请参考readme
]]

local solve = require("app.express.expresspush")
solve(data)
