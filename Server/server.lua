print(" __      __                              .__     ________    _________")
print("/  \\    /  \\_______   ____   ____   ____ |  |__  \\_____  \\  /   _____/")
print("\\   \\/\\/   /\\_  __ \\_/ __ \\ /    \\_/ ___\\|  |  \\  /   |   \\ \\_____  \\ ")
print(" \\        /  |  | \\/\\  ___/|   |  \\  \\___|   Y  \\/    |    \\/       \\")
print("  \\__/\\  /   |__|    \\___  >___|  /\\___  >___|  /\\_______  /_______  /")
print("       \\/                \\/     \\/     \\/     \\/         \\/        \\/")





players = {

} -- Basically every single players database.
-- Player Data: identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job


function updplayer(plrid, value, data, charid)
    plrid = tonumber(plrid)

    if plrid > 0 then
        if players[plrid] and not charid then
            if players[plrid].charid then
                MySQL.update.await('UPDATE wrenchaccounts SET ' .. value .. ' = ? WHERE charid = ?', {
                    data, players[plrid].charid
                })
                TriggerEvent("WrenchOS:playerChanged", plrid)
                TriggerClientEvent("WrenchOS:playerChanged", plrid)
            else
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
            end
    
            players[plrid][value] = data
        else
            if charid then
                MySQL.update.await('UPDATE wrenchaccounts SET ' .. value .. ' = ? WHERE charid = ?', {
                    data, charid
                })
                local account = MySQL.query.await('SELECT * FROM `wrenchaccounts` WHERE `charid` = ?', {
                    charid
                })[1]
                players[plrid] = account
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
end

function selectCharacter(charid, plrid, id)
    local account = MySQL.query.await('SELECT * FROM `wrenchaccounts` WHERE `charid` = ?', {
        charid
    })[1]
    players[plrid] = account
    if Config.useCharacters == true  then
        CreateThread(function ()
            Wait(100)
            TriggerEvent("WrenchOS:playerJoined", plrid)
            TriggerClientEvent("WrenchOS:playerJoined", plrid)
        end)
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

function createcharacter(plrid, data)
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
    local created
    if data then
        created = MySQL.insert.await("INSERT INTO `wrenchaccounts` (identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job, inventory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CIV', ?)",  {
            identifier, idtoken, charid, data.firstname, data.lastname, Config.startingCash, Config.startingBank, plrid, json.encode({{['name']='money',['slot']=1,['count']=2000}})
        })
    else
        created = MySQL.insert.await("INSERT INTO `wrenchaccounts` (identifier, idtoken, charid, firstname, lastname, cash, bank, plrid, job, inventory) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CIV', ?)", {
            identifier, idtoken, charid, name, name, Config.startingCash, Config.startingBank, plrid, json.encode({{['name']='money',['slot']=1,['count']=2000}})
        })
    end
    if created then
        print("Account created for " .. name)
        players[plrid] = nil
        getplayer(plrid)
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
    if account and Config.useCharacters == true then
        players[plrid] = account
        updplayer(plrid, "plrid", plrid)
        TriggerClientEvent("WrenchOS:PlayerChanged", plrid, players[plrid].firstname, 0)
    elseif account and Config.useCharacters == false then
        players[plrid] = account
        updplayer(plrid, "plrid", plrid)
        TriggerClientEvent("WrenchOS:PlayerChanged", plrid, account.firstname, 0)
    elseif not account then
        createcharacter(plrid)
        
        updplayer(plrid, "plrid", plrid)
    end
end

local function plrjoined(plrid)
    getplayer(plrid)
    if Config.useCharacters == false  then
        CreateThread(function ()
            while not players[plrid] do
                Wait(0)
            end
            TriggerEvent("WrenchOS:playerJoined", plrid, plrid)
            TriggerClientEvent("WrenchOS:playerJoined", plrid, plrid)
        end)
    end
end

RegisterNetEvent("WrenchOS_Script:PlayerJoined", function ()
    plrjoined(source)
end)

AddEventHandler('playerDropped', function()
    dropplayer(source)
end)

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wrenchaccounts` ( 
            `identifier` varchar(50) DEFAULT '',
            `idtoken` varchar(50) DEFAULT '',
            `charid` int(11) DEFAULT NULL,
            `firstname` varchar(50) DEFAULT '',
            `lastname` varchar(50) DEFAULT NULL,
            `cash` int(10) DEFAULT NULL,
            `bank` int(10) DEFAULT NULL,
            `plrid` int(11) DEFAULT NULL,
            `job` varchar(20) DEFAULT 'CIV',
            `inventory` longtext DEFAULT NULL,
            `rank` mediumtext DEFAULT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]], {})

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `vehicles` (
            `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
            `plate` char(8) NOT NULL DEFAULT '',
            `vin` char(17) NOT NULL,
            `owner` int(10) unsigned DEFAULT NULL,
            `group` varchar(50) DEFAULT NULL,
            `model` varchar(20) NOT NULL,
            `class` tinyint(3) unsigned DEFAULT NULL,
            `data` longtext NOT NULL,
            `trunk` longtext DEFAULT NULL,
            `glovebox` longtext DEFAULT NULL,
            `stored` varchar(50) DEFAULT NULL,
            PRIMARY KEY (`id`) USING BTREE,
            UNIQUE KEY `plate` (`plate`) USING BTREE,
            UNIQUE KEY `vin` (`vin`) USING BTREE,
            KEY `FK_vehicles_characters` (`owner`) USING BTREE,
            KEY `FK_vehicles_groups` (`group`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]], {})
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


