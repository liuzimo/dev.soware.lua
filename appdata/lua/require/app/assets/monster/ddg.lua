--大大怪

return function ()
    local characterData = apiXmlGet("", "monster", "yyg")
    local data = characterData == "" and
    {
        blood = 100, --生命值
        defense = 10, --防御
        aggressivity = 10, --攻击
        level = 1, --等级
    } or jsonDecode(characterData)
    
    return  "大大怪\n"..
            "生命值:"..data["blood"].."\n"..
            "防御  :"..data["defense"].."\n"..
            "攻击  :"..data["aggressivity"].."\n"..
            "等级  :"..data["level"]
end
