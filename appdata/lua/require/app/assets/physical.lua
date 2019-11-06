--体力

return function (group,qq)
    local physical = apiXmlGet(tostring(group),"physical",tostring(qq))
    
    if apiXmlGet(tostring(group),"physicaltody",tostring(qq)) ~= os.date("%x", os.time())  then
        apiXmlSet(tostring(group),"physical",tostring(qq),"5")
        apiXmlSet(tostring(group),"physicaltody",tostring(qq),os.date("%x", os.time()))
        physical = 5
    end

    if physical ~= "0" then
        apiXmlSet(tostring(group),"physical",tostring(qq),tostring(tonumber(physical)-1))
        return 0
    end
    return -1
end
