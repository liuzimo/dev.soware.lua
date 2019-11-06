--解析短故事
return function ()
    local html = apiHttpPost("http://api.tianapi.com/txapi/mnpara/","key=573aa0cf0df39768739d1357b4c367c5")
    if not html then return "网络错误" end
    local j= jsonDecode(html)
    if j["msg"] ~="success" then return "检查api调用次数是否足够" end
    return j["newslist"][1]["content"]
end

