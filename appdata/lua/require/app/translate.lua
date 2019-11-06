--解析短故事
return function (msg)
    local key = message:gsub("翻译","")
    local l=string.len(key)
    for i=1,l do
        local asc2=string.byte(string.sub(key,i,i))
        if asc2>127 then
            local html = apiHttpPost("http://api.tianapi.com/txapi/fanyi/","key=573aa0cf0df39768739d1357b4c367c5&text="..key.."&to=en")
            if not html then return "网络错误" end
            local j= jsonDecode(html)
            if j["msg"] ~="success" then return "检查api调用次数是否足够" end
            return j["newslist"][1]["dst"]
        end
    end
    local html = apiHttpPost("http://api.tianapi.com/txapi/fanyi/","key=573aa0cf0df39768739d1357b4c367c5&text="..key.."&to=zh")
    if not html then return "网络错误" end
    local j= jsonDecode(html)
    if j["msg"] ~="success" then return "检查api调用次数是否足够" end
    return j["newslist"][1]["dst"]
end

