
local function getsid(plrid)
    local plrid = tonumber(plrid)
    local falseplrid = nil
    
    
    if plrid and GetPlayerName(plrid) ~= "**Invalid**" then
        plrid = GetPlayerServerId(plrid)
    end

    if GetPlayerFromServerId(plrid) == -1 then
        falseplrid = plrid
        plrid = 0 
    end


    if not falseplrid and plrid and plrid > 0 then
        return plrid
    else
        return nil
    end
end


exports("getPlayer", function(plrid)
    local plrid = getsid(plrid)
    if plrid then
        local plr = lib.callback.await("wrenchos:clientRequestPlayer", false, function(data) end, plrid)
        return plr or false
    end
end)

exports("addMoney", function(plrid, mtype, amount)
    local plrid = getsid(plrid)
    if plrid then
        local added = lib.callback.await("wrenchos:clientAddMoney", false, function(data) end, tonumber(plrid), mtype, tonumber(amount))
        return added or false
    end
end)


exports("withdrawMoney", function(plrid, mtype, amount)
    local plrid = getsid(plrid)
    if plrid then
        local removed = lib.callback.await("wrenchos:clientWithdrawMoney", false, function(data) end, tonumber(plrid), mtype, tonumber(amount))
        return removed or false
    end
end)

exports("spawnVehicle", function(coords, model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local val = lib.callback.await("wrenchos:clientSpawnVehicle", false, function(data) end, coords, model)
    return val or false
end)

exports("changeJob", function(plrid, job)
    local val = lib.callback.await("wrenchos:clientChangeJob", false, function(data) end, plrid, job)
    return val or false
end)

exports("getPlayers", function()
    local val = lib.callback.await("wrenchos:clientGetPlayers", false, function(data) end)
    return val or false
end)