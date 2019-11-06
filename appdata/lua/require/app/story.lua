--解析短故事
return function ()
    local type = math.random( 1,4 )
    local page = math.random( 1,250)
    local html = apiHttpPost("http://api.tianapi.com/txapi/story/","key=573aa0cf0df39768739d1357b4c367c5&type="..type.."&page="..page)
    if not html then return "网络错误" end
    local j= jsonDecode(html)
    if j["msg"] ~="success" then return "检查api调用次数是否足够" end
    local content = j["newslist"][1]["content"]
    if string.len(content) > 11178 then
        content = content:sub(1,11178)
    end
    return content
end

