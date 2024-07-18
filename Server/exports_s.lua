-- Callbacks
lib.callback.register("wrenchos:clientRequestPlayer", function(src, cb, plrid)
    if players[plrid] then
        return players[plrid]
    else
        return "Could not find player in players list."
    end
end)

lib.callback.register("wrenchos:clientAddMoney", function(src, cb, plrid, mtype, amount)
    if players[plrid] then
        
        return exports.WrenchOS:addMoney(plrid, mtype, amount)
    else
        return "Invalid PlayerID"
    end
end)

lib.callback.register("wrenchos:clientWithdrawMoney", function(src, cb, plrid, mtype, amount)
    if players[plrid] then
        
        return exports.WrenchOS:withdrawMoney(plrid, mtype, amount)
    else
        return "Invalid PlayerID"
    end
end)

lib.callback.register("wrenchos:clientSpawnVehicle", function (src, cb, coords, model)
    return exports.WrenchOS:spawnVehicle(coords, model)
end)

lib.callback.register("wrenchos:clientChangeJob", function (src, cb, plrid, jobname)
    return exports.WrenchOS:changeJob(plrid, jobname)
end)

lib.callback.register("wrenchos:clientGetPlayers", function ()
    return exports.WrenchOS:getPlayers()
end)


-- Exports 
exports("addMoney", function(plrid, mtype, amount) -- plrid: a valid player ID | mtype: "bank"/"cash" | amount: amount of money.
    local value, errorv = pcall(function()
        if type(plrid) == "number" and type(mtype) == "string" and type(amount) == "number" then
            if not players[plrid] then
                error("Player id was not found.")
                return false
            end
            if string.lower(mtype) == "cash" or mtype == "bank" then
                local newamt = players[plrid][mtype] + amount
                updplayer(plrid, mtype, newamt)
                if Config.ox_inventory == true and mtype == "cash"  then
                    exports.ox_inventory:AddItem(plrid, "cash", amount)
                end
                return true
            else
                error("Didn't specify cash or bank")
                return false
            end
        else
            error("Invalid Input")
            return false
        end
    end)

    if not value then
        error(errorv)
    end
    return value
end)

exports("withdrawMoney", function(plrid, mtype, amount) -- plrid: a valid player ID | mtype: "bank"/"cash" | amount: amount of money.
    local value, errorv = pcall(function ()
        if type(plrid) == "number" and type(mtype) == "string" and type(amount) == "number" then
            if not players[plrid] then
                error("Player id was not found.")
                return false
            end
            if mtype == "cash" or mtype == "bank" then
                local newamt = players[plrid][mtype] - amount
                if newamt >= 0 then
                    updplayer(plrid, mtype, newamt)
                    if Config.ox_inventory == true and mtype == "cash" then
                        exports.ox_inventory:RemoveItem(plrid, "cash", amount)
                    end
                    return true
                else
                    error("Player doesn't have enough money")
                    return false
                end
            else
                error("Didn't specify cash or bank")
                return false
            end
        else
            error("Invalid Input")
            return false
        end
    end)

    if not value then
        error(errorv)
    end
    return value
end)

exports("getPlayer", function(plrid)
    plrid = tonumber(plrid)
    local plr = nil
    local value, errorv = pcall(function ()
        if players[plrid] then
            plr = players[plrid]
            return true
        else
            error("Player not found")
            return false
        end
    end)
    if not value then
        error(errorv)
    end
    if plr then return plr else return false end
end)


exports("spawnVehicle", function(coords, model) -- Coords: vec3 / vec4 | model: model string
    local value, errorv = pcall(function()
        if type(coords) == "vector3" then
            local vehicle = CreateVehicle(model, coords, 0, true, false)
            return true
        elseif type(coords) == "vector4" then
            local vehicle = CreateVehicle(model, coords, true, false)
            return true
        else
            error("Coords must be vector3 or vector4")
        end
    end)

    if not value then
        error(errorv)
    end
    return value
end)

exports("changeJob", function(plrid, job) -- plrid: Server Identifier | job: STRING
    local value, errorv = pcall(function()
        if type(job) == "string" then
            if players[plrid] then
                updplayer(plrid, "job", job)
                return true
            else
                error("Player Not Found.")
            end
        else
            error("Job was not a string.")
        end
    end)

    if not value then
        error(errorv)
    end
    return value
end)

exports("getPlayers", function()
    return players
end)