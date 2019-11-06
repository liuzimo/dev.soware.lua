--图像识别

return function (qq,msg)
    if baidutoken=="" then
        return "请设置百度AI开放平台token"
    end
    local imagePath = apiGetImagePath(msg)--获取图片路径
    if imagePath == "" then 
        apiXmlSet("","imageocr",tostring(qq),"0")
        return "等待图片输入" 
    end
    --imagePath = apiGetAsciiHex(imagePath):fromHex()--转码路径，以免乱码找不到文件

    local filename = msg:gsub("图像识别",""):gsub("%[CQ:image,file=",""):gsub("%]",""):gsub("\r\n","")
 
    local image = apiAdvancedGeneral(filename,baidutoken)
    if image=="" then return "识别失败" end

    local t = jsonDecode(image)
    if t["error_code"] then
        return "请检查key是否正确，现阶段我们支持的图片格式为：PNG、JPG、JPEG、BMP，大小为4M"
    end
    local m=""
    for i=1,t["result_num"] do
        m = m.."相似度："..t["result"][i]["score"].."     描述："..t["result"][i]["root"].."     名称："..t["result"][i]["keyword"].."\n"
    end
    apiXmlSet("","imageocr",tostring(qq),"1")
    return m
end

