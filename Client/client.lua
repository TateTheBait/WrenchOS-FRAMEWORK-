TriggerServerEvent("WrenchOS_Script:PlayerJoined", GetPlayerServerId(PlayerId()))


RegisterCommand("ostest1", function(src, args)
    print(exports.WrenchOS:addMoney(GetPlayerServerId(PlayerId()), "cash", 10))
end, false)




-- Command suggestions

TriggerEvent('chat:addSuggestion', '/changejob', 'changes WrenchOS Job', {
    { name="playerid", help="Players server id" },
    { name="jobname", help="EX: STAFF, LEO etc." }
})
