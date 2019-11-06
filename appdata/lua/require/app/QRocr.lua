--二维码解码

return function (qq,msg)
    local imagePath = apiGetImagePath(msg)--获取图片路径
    if imagePath == "" then 
        apiXmlSet("","qrocr",tostring(qq),"0")
        return "等待图片输入" 
    end
    --imagePath = apiGetAsciiHex(imagePath):fromHex()--转码路径，以免乱码找不到文件

    local filename = msg:gsub("二维码解码",""):gsub("%[CQ:image,file=",""):gsub("%]",""):gsub("\r\n","")
    local text = apiQRDecode(filename)
    apiXmlSet("","qrocr",tostring(qq),"1")
    if text == "" then
        return "请提供清晰的二维码图片"
    end
    return text
end

