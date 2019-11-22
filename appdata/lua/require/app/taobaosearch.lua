--淘宝商品搜索

local function sendMessage(num,s,bool)
    if bool then
        cqSendPrivateMessage(num, s)
        return true
    end
    cqSendGroupMessage(num, s)
end
return function (num,msg,bool)
    local keys = msg:gsub("淘宝搜索","")
    keys = encodeURI(kickSpace(keys))
    if keys=="" then
        sendMessage(num,"淘宝搜索 + 商品关键字  --展示销量前三的商品店铺",bool)
    end
    local surl = apiHttpGet("https://ai.taobao.com/search/index.htm?key="..keys.."&sort=biz30day"):match("auction\":(.-)},\"success")
    if surl == nil then
        sendMessage(num,"搜索错误，请尝试其他关键字",bool)
    end
    local goods = jsonDecode(surl)
    for i=1,3 do
        local lurl = goods[i]["clickUrl"]:gsub("//","")
        local gurl = apiHttpGet("https://sa.sogou.com/gettiny?url="..lurl)
        local iurl = goods[i]["picUrl"]:gsub("//","")
        local nick = goods[i]["nick"].."\n当月销量第"..i.."："..goods[i]["saleCount"]
        local description = goods[i]["description"]
        while description:find("&gt;") do
            local s = description:find("&lt;")
            local e = description:find("&gt;")
            description = description:gsub(description:sub(s,e+2),"")
        end
        apiHttpImageDownload("http://"..iurl,"image".."\\".."goodsimg",tostring(i))
        sendMessage(num,cqCqCode_Image("goodsimg\\"..i..".jpg").."\n"..
        gurl.."\n"..
        nick.."\n"..
        description,bool)
        -- sendMessage(num,cqCqCode_ShareLink(gurl, nick, description, iurl),bool)
    end
end

