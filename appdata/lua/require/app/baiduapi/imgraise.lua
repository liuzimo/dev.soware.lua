--文字识别

return function (qq,msg,id)
    
    if appkey=="" and secretkey=="" then
        return "请设置百度AI开放平台appkey和secretkey"
    end
    --imagePath = apiGetAsciiHex(imagePath):fromHex()--转码路径，以免乱码找不到文件
    apiGetImagePath(msg) -- 下载图片
    local filename = msg:gsub("%[CQ:image,file=",""):gsub("%]","")
    local text = apiImgRaise(filename)

    if text=="" then return "识别失败" end
    local t = jsonDecode(text)
    local status  = t["conclusion"]
    return status
end

