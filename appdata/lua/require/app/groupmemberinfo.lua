--获取群成员信息
local age,area,card,join,last,permit,sex,specialtitle = nil,nil,nil,nil,nil,nil,nil,nil

return function (t)

    if t["Age"]=="" then
        age = "未知"
    else
        age=t["Age"]
    end


    if t["Card"]=="" then
        card = "未设置"
    else
        card=t["Card"] 
    end

    join=os.date("%Y-%m-%d %H:%M:%S",t["JoiningTime"])

    if t["LastDateTime"]==t["JoiningTime"] then
        last = "未发言"
    else
        last=os.date("%Y-%m-%d %H:%M:%S",t["LastDateTime"])
    end

    if t["PermitType"]==1 then
        permit = "群员"
    elseif t["PermitType"]==2 then
            permit = "管理"
    elseif t["PermitType"]==3 then
            permit = "群主"
    end

    if  t["Sex"] == 0 then
        sex = "男"
    elseif t["Sex"] == 1 then
        sex = "女"
    elseif t["Sex"] == 255 then
        sex = "未知"
    end

    if t["SpecialTitle"]=="" then
        specialtitle = "无"
    else
        specialtitle=t["SpecialTitle"]
    end

    if t["QQ"] ~=nil then
        return
        "QQ                    "..t["QQ"].."\n"..
        "年龄                 "..age.."\n"..
        "群名片             "..card.."\n"..
        "加群时间         "..join.."\n"..
        "最后发言时间 "..last.."\n"..
        "昵称                 "..t["Nick"] .."\n"..
        "权限等级         "..permit.."\n"..
        "性别                 "..sex.."\n"..
        "专属头衔         "..specialtitle
    end

    if t["Area"]=="" then
        area = "未知"
    else
        area= t["Area"] 
    end

    return
    "年龄                 "..age.."\n"..
    "地区                 "..area.."\n"..
    "群名片             "..card.."\n"..
    "加群时间         "..join.."\n"..
    "最后发言时间 "..last.."\n"..
    "群等级             "..t["Level"].."\n"..
    "昵称                 "..t["Nick"] .."\n"..
    "权限等级         "..permit.."\n"..
    "性别                 "..sex.."\n"..
    "专属头衔         "..specialtitle

end
