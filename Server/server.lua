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

        MySQL.update.await('UPDATE wrenchaccounts SET ' .. value .. ' = ? WHERE identifier = ?', {
            data, identifier
        })

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
    
    if plrid > 0 then
        local identifier = GetPlayerIdentifier(plrid, 1)

        MySQL.update.await('UPDATE wrenchaccounts SET plrid = ? WHERE identifier = ?', {
            nil, identifier
        })

        players[plrid] = nil
    end
end

function createcharacter(plrid)
    local identifier = GetPlayerIdentifier(plrid, 1)
    local name = GetPlayerName(plrid)

    local accounts = MySQL.query.await('SELECT `charid` FROM `wrenchaccounts`', {})
    local accountssum = 0
    for _, addsum in pairs(accounts) do
        accountssum += 1
    end

    local idtoken = math.random(1, 100000) -- Make a random idtoken
    for _, tacc in pairs(accounts) do -- check if already exists
        if tacc.idtoken == idtoken then
            idtoken = math.random(1, 100000)
        end
    end
    local charid = accountssum + 1 -- make charid 1 greater than the total amount of characters

    
    local created = MySQL.insert.await("INSERT INTO `wrenchaccounts` (identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CIV')", {
        identifier, idtoken, charid, name, name, Config.startingCash, Config.startingBank, plrid
    })

    if created then
        print("Account created for " .. name)
    else
        print("Failed to create account for " .. name)
    end
end


function getplayer(plrid)
    local identifier = GetPlayerIdentifier(plrid, 1)

    local account = MySQL.query.await('SELECT * FROM `wrenchaccounts` WHERE `identifier` = ?', {
        identifier
    })[1]

    if account then
        players[plrid] = account
        updplayer(plrid, "plrid", plrid)
    elseif not account then
        createcharacter(plrid)
        
        updplayer(plrid, "plrid", plrid)
    end
end

RegisterNetEvent("WrenchOS:PlayerJoined", function(plrid)
    getplayer(plrid)
end)

AddEventHandler('playerDropped', function()
    dropplayer(source)
end)

RegisterCommand("getbank", function(id)
    print(players[id].bank)
end, false)
