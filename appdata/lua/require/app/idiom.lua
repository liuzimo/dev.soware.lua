--成语接龙

return function (group,msg)
    if msg:find("成语接龙帮助") then
        local help = apiXmlGet(tostring(group),"idiom","idiomdata")
        if help == "" then
            return "？加上成语就可以开始了噢 比如 ？云开见日"
        end
        return  help
    end

    local key = msg:gsub("？","")
    
    if key ~= "" then
        local f = true
        local s = {}
        local idiom =  apiXmlGet(tostring(group),"idiom","idiom") --判断是否第一次
        if idiom ~= "" then
            if idiom ~= string.sub(key,0,3) then
                return "请以\""..idiom.."\"开头进行接龙"
            end
            s = strtotable(apiXmlGet(tostring(group),"idiom","idiomdata"))
            for k,v in pairs(s) do
                if key == v then
                    f = false
                    break
                end
            end
            if f then
                return "没有这个成语噢"
            end
        end

        idiom = string.sub(key,key:len()-2,key:len())
        local a = apiHttpGet("https://chengyujielong.51240.com/"..idiom.."__chengyujielong/"):match("<li>(.+)</li></ul>\r\n<br />")
        local b=""
        local c=""
        local d=0
        local e = ""
        if a==nil then
            return "没有以"..idiom.."结尾的成语"
        end
        while a:find(idiom) do
            d = d + 1
            b=string.find(a,"k\">",1,false)
            e = string.sub(a,b,b+18)
            c=string.find(e,"</a>",1,false)
            if c ~=nil then
                s[d] = string.sub(a,b+3,b+c-2)
            else
                c = 0
            end
            a = string.sub(a,b+c+5,string.len( a ))
        end
        apiXmlSet(tostring(group),"idiom","idiomdata",tabletostr(s))
        apiXmlSet(tostring(group),"idiom","idiom",idiom)
        return "请以\""..idiom.."\"开头进行成语接龙"
    end
end

