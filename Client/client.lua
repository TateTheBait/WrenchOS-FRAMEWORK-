TriggerServerEvent("WrenchOS:PlayerJoined", GetPlayerServerId(PlayerId()))


RegisterCommand("ostest1", function(src, args)
    print(exports.WrenchOS:addMoney(GetPlayerServerId(PlayerId()), "cash", 10))
end, false)