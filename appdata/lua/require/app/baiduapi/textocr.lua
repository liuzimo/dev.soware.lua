--文字识别

return function (qq,msg)
    
    if appkey=="" and secretkey=="" then
        return "请设置百度AI开放平台appkey和secretkey"
    end
    
    local imagePath = apiGetImagePath(msg)--获取图片路径
    if imagePath == "" then 
        apiXmlSet("","textocr",tostring(qq),"0")
        return "等待图片输入" 
    end
    --imagePath = apiGetAsciiHex(imagePath):fromHex()--转码路径，以免乱码找不到文件

    local filename = msg:gsub("文字识别",""):gsub("%[CQ:image,file=",""):gsub("%]",""):gsub("\r\n","")
 
    local text = apiGeneralBasic(filename,appkey,secretkey)
    if text=="" then return "识别失败" end

    local t = jsonDecode(text)
    local m=""
    for i=1,t["words_result_num"] do
        m = m..t["words_result"][i]["words"].."\n"
    end
    apiXmlSet("","textocr",tostring(qq),"1")
    return m
end

