--人物属性

return function (group,qq)

    local characterData = apiXmlGet(tostring(group), "characterData", tostring(qq))


    local physical = apiXmlGet(tostring(group),"physical",tostring(qq)) == "" and "0" or apiXmlGet(tostring(group),"physical",tostring(qq))


    local assets = apiXmlGet(tostring(group), "assets",tostring(qq)) == "" and "500" or apiXmlGet(tostring(group), "assets",tostring(qq))
    local getassets = require("app.assets.conversion")
    assets = getassets(tonumber(assets))

    local data = characterData == "" and
    {
        blood = 1000, --生命值
        defense = 100, --防御
        aggressivity = 100, --攻击
        level = 1, --等级
        empirical  = 0, --经验值
    } or jsonDecode(characterData)



    return  "体力  :"..physical.."\n"..
            "生命值:"..data["blood"].."\n"..
            "防御  :"..data["defense"].."\n"..
            "攻击  :"..data["aggressivity"].."\n"..
            "等级  :"..data["level"].."\n"..
            "经验值:"..data["empirical"].."\n"..
            "资产  :"..assets
end
