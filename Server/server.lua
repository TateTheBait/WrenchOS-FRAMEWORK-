print(" __      __                              .__     ________    _________")
print("/  \\    /  \\_______   ____   ____   ____ |  |__  \\_____  \\  /   _____/")
print("\\   \\/\\/   /\\_  __ \\_/ __ \\ /    \\_/ ___\\|  |  \\  /   |   \\ \\_____  \\ ")
print(" \\        /  |  | \\/\\  ___/|   |  \\  \\___|   Y  \\/    |    \\/       \\")
print("  \\__/\\  /   |__|    \\___  >___|  /\\___  >___|  /\\_______  /_______  /")
print("       \\/                \\/     \\/     \\/     \\/         \\/        \\/")





players = {

} -- Basically every single players database.
-- Player Data: identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job


function updplayer(plrid, value, data)
    plrid = tonumber(plrid)

    if plrid > 0 then
        local identifier = GetPlayerIdentifier(plrid, 1)
        for k,v in pairs(GetPlayerIdentifiers(plrid))do
            if  string.sub(v, 1, string.len("discord:")) == "discord:"  then
                identifier = v
            end
        end
        MySQL.update.await('UPDATE wrenchaccounts SET ' .. value .. ' = ? WHERE identifier = ?', {
            data, identifier
        })
        TriggerEvent("WrenchOS:playerChanged", plrid)
        TriggerClientEvent("WrenchOS:playerChanged", plrid)
        if players[plrid] then
            players[plrid][value] = data
        else
            local account = MySQL.query.await('SELECT * FROM `wrenchaccounts` WHERE `identifier` = ?', {
                identifier
            })[1]
            players[plrid] = account
            players[plrid][value] = data
        end
    end
end

function dropplayer(plrid)
    plrid = tonumber(plrid)
    local identifier = GetPlayerIdentifier(plrid, 1)
    if plrid > 0 then
        for k,v in pairs(GetPlayerIdentifiers(plrid))do
            if  string.sub(v, 1, string.len("discord:")) == "discord:"  then
                identifier = v
            end
        end
        

        MySQL.update.await('UPDATE wrenchaccounts SET plrid = ? WHERE identifier = ?', {
            nil, identifier
        })
        TriggerEvent("WrenchOS:PlayerExiting", plrid, players[plrid].idtoken, players[plrid].charid)
        TriggerClientEvent("WrenchOS:PlayerExiting", plrid, players[plrid].idtoken, players[plrid].charid)
        players[plrid] = nil
        
    end
end

function createcharacter(plrid)
    local identifier = GetPlayerIdentifier(plrid, 1)
    for k,v in pairs(GetPlayerIdentifiers(plrid))do
        if  string.sub(v, 1, string.len("discord:")) == "discord:"  then
            identifier = v
        end
    end
    local name = GetPlayerName(plrid)

    local accounts = MySQL.query.await('SELECT `charid` FROM `wrenchaccounts`', {})
    local accountssum = 0
    for _, asdf in pairs(accounts) do
        accountssum += 1
    end

    local idtoken = math.random(1, 100000) -- Make a random idtoken
    for _, tacc in pairs(accounts) do -- check if already exists
        if tacc.idtoken == idtoken then
            idtoken = math.random(1, 100000)
        end
    end
    local charid = accountssum + 1 -- make charid 1 greater than the total amount of characters

    
    local created = MySQL.insert.await("INSERT INTO `wrenchaccounts` (identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job, inventory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CIV', ?)", {
        identifier, idtoken, charid, name, name, Config.startingCash, Config.startingBank, plrid, json.encode({{['name']='money',['slot']=1,['count']=2000}})
    })

    if created then
        print("Account created for " .. name)
    else
        print("Failed to create account for " .. name)
    end
end

function getplayer(plrid)
    local identifier = GetPlayerIdentifier(plrid, 1)
    for k,v in pairs(GetPlayerIdentifiers(plrid))do
        if  string.sub(v, 1, string.len("discord:")) == "discord:"  then
            identifier = v
        end
    end
    local account = MySQL.query.await('SELECT * FROM `wrenchaccounts` WHERE `identifier` = ?', {
        identifier
    })[1]
    if account then
        players[plrid] = account
        updplayer(plrid, "plrid", plrid)
        TriggerClientEvent("WrenchOS:PlayerChanged", plrid, players[plrid].firstname, 0)
    elseif not account then
        createcharacter(plrid)
        
        updplayer(plrid, "plrid", plrid)
    end
end

RegisterNetEvent("WrenchOS:PlayerJoined", function(plrid)
    getplayer(plrid)
    CreateThread(function ()
        Wait(100)
        TriggerEvent("WrenchOS:playerJoined", plrid)
        TriggerClientEvent("WrenchOS:playerJoined", plrid)
    end)
end)

AddEventHandler('playerDropped', function()
    dropplayer(source)
end)
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    for _, player in pairs(players) do
        dropplayer(player.plrid)
    end
end)
  


RegisterCommand("getbank", function(id)
    print(players[id].bank)
end, false)