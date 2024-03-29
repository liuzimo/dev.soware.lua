--提前运行的脚本
--用于提前声明某些要用到的函数
--管理员账号，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
-- admin = tonumber(apiGetVar("adminqq")) or -1
-- if admin == -1 then
--     admin = apiXmlGet("","settings", "adminqq")
--     apiSetVar("adminqq", admin)
--     admin = tonumber(admin) or -1
-- end


-- 管理员账号，从xml中读取
-- 只会在启动第一次执行的时候读一次，后面都不读
admin = apiXmlGet("","settings", "adminqq")
if admin ~="" then
    admin = tonumber(admin)
end
--百度AI开放平台token，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
aidutoken = apiXmlGet("","settings", "baidutoken")
--百度AI开放平台APPKEY，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
appkey = apiXmlGet("","settings", "appkey")
--百度AI开放平台SECRET_KEY，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
secretkey = apiXmlGet("","settings", "secretkey")
--天行数据平台KEY，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
tianxinkey = apiXmlGet("","settings", "tianxinkey")
--机器人昵称，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
name = apiXmlGet("","settings", "name")
--回复频率，从xml中读取
--只会在启动第一次执行的时候读一次，后面都不读
probability = apiXmlGet("","settings", "probability")
--读取语音性格
mettle = apiXmlGet("","settings", "mettle")

-- if admin == -1 then
--     cqAddLoger(20, "lua插件警告", "请去" .. apiGetPath() .. "data/app/com.robot.soware/xml/settings.xml文件，设置管理员qq！")
-- end

--加强随机数随机性
math.randomseed(tostring(os.time()):reverse():sub(1, 6))

--防止跑死循环，超时设置秒数自动结束，-1表示禁用
local maxSeconds = -1
local start = os.time()
function trace(event, line)
    if os.time() - start >= maxSeconds then
        error("代码运行超时")
    end
end
if maxSeconds > 0 then
    debug.sethook(trace, "l")
end

--加上需要require的路径
local rootPath = apiGetAsciiHex(apiGetPath())
rootPath = rootPath:gsub("[%s%p]", ""):upper()
rootPath = rootPath:gsub("%x%x", function(c)
    return string.char(tonumber(c, 16))
end)
package.path = package.path ..
";" .. rootPath .. "data/app/"..apiGetAppName().."/lua/require/?.lua"

--加载字符串工具包
require("strings")

--重载几个可能影响中文目录的函数
local oldrequire = require
require = function(s)
    local s = apiGetAsciiHex(s):fromHex()
    return oldrequire(s)
end
local oldloadfile = loadfile
loadfile = function(s)
    local s = apiGetAsciiHex(s):fromHex()
    return oldloadfile(s)
end

JSON = require("JSON")
--安全的，带解析结果返回的json解析函数
--返回值：数据,是否成功,错误信息
function jsonDecode(s)
    local result, info = pcall(function(t) return JSON:decode(t) end, s)
    if result then
        return info, true
    else
        return {}, false, info
    end
end
function jsonEncode(t)
    local result, info = pcall(function(t) return JSON:encode(t) end, t)
    if result then
        return info, true
    else
        return "", false, info
    end
end

--修正http接口可选参数
local oldapiHttpGet = apiHttpGet
apiHttpGet = function(url, para, timeout, cookie)
    return oldapiHttpGet(url, para or "", timeout or 5000, cookie or "")
end
local oldapiHttpPost = apiHttpPost
apiHttpPost = function(url, para, timeout, cookie, contentType)
    return oldapiHttpPost(url, para or "", timeout or 5000, cookie or "", contentType or "application/x-www-form-urlencoded")
end

--获取随机字符串
function getRandomString(len)
    local str = "1234567890abcdefhijklmnopqrstuvwxyz"
    local ret = ""
    for i = 1, len do
        local rchr = math.random(1, string.len(str))
        ret = ret .. string.sub(str, rchr, rchr)
    end
    return ret
end

--根据url显示图片
function image(url)
    local file = getRandomString(25) .. ".luatemp"
    apiHttpFileDownload(url, "data/image/" .. file, 5000)
    return "[CQ:image,file=" .. file .. "]"
end



--图片对象
img = { width = 0, height = 0, imageData = nil }
--新建图片对象
function img:new(width, height)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.width = width or 0
    self.height = height or 0
    self.imageData = apiGetBitmap(self.width, self.height)
    return o
end
--摆放文字
function img:setText(x, y, text, type1, size, r, g, b)
    self.imageData = apiPutText(self.imageData, x - 1, y - 1, text,
    type1 or "微软雅黑", size or 9, r or 0, g or 0, b or 0)
end
--摆放矩形
function img:setBlock(x, y, xx, yy, r, g, b)
    self.imageData = apiPutBlock(self.imageData, x - 1, y - 1,
    xx - 1 > self.width - 1 and self.width - 1 or xx - 1, yy - 1 > self.height - 1 and self.height - 1 or yy - 1,
    r, g, b)
end
--摆放其他图片
function img:setImg(x, y, path, xx, yy)
    self.imageData = apiSetImage(self.imageData, x - 1, y - 1, path, xx and xx - 1 or 0, yy and yy - 1 or 0)
end
--获取图片结果
function img:get()
    return "[CQ:image,file=" .. apiGetDir(self.imageData) .. "]"
end

--获取群成员信息
local oldcqGetMemberInfo = cqGetMemberInfo
cqGetMemberInfo = function(g, q, a)
    local r = {}
    if not a then a = false end
    return oldcqGetMemberInfo(r, g, q, a)
end
    

--去除字符串开头的空格
function kickSpace(s)
if type(s) ~= "string" then return end
while s:sub(1, 1) == " " do
    s = s:sub(2)
end
return s
end

--table转字符串
function ToStringEx(value)
    if type(value)=='table' then
       return TableToStr(value)
    elseif type(value)=='string' then
        return "\'"..value.."\'"
    else
       return tostring(value)
    end
end
function tabletostr(t)
if t == nil then return "" end
local retstr= "{"

local i = 1
for key,value in pairs(t) do
    local signal = ","
    if i==1 then
      signal = ""
    end

    if key == i then
        retstr = retstr..signal..ToStringEx(value)
    else
        if type(key)=='number' or type(key) == 'string' then
            retstr = retstr..signal..'['..ToStringEx(key).."]="..ToStringEx(value)
        else
            if type(key)=='userdata' then
                retstr = retstr..signal.."*s"..TableToStr(getmetatable(key)).."*e".."="..ToStringEx(value)
            else
                retstr = retstr..signal..key.."="..ToStringEx(value)
            end
        end
    end

    i = i+1
end

 retstr = retstr.."}"
 return retstr
end


--字符串转table
function strtotable(str)
    if str == nil or type(str) ~= "string" then
        return
    end
    
    return load("return " .. str)()
end
--url解码
function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end
--url编码
function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end
--去除字符串两边空格
function string.trim(s) 
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end