--创建角色

return function (group,qq)
    local data = 
    {
        blood = 1000, --生命值
        defense = 100, --防御
        aggressivity = 100, --攻击
        level = 1, --等级
        empirical  = 0, --经验值
    }
    data = jsonEncode(data)
    apiXmlSet(tostring(group), "characterData", tostring(qq),data)
    return "又一位侠士踏入武林，江湖纷争不断，谁主沉浮，让我们拭目以待"
end
