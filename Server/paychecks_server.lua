lib.callback.register("WrenchOS:Paycheck", function(plrid)
    local plr = exports.WrenchOS:getPlayer(plrid)
    if Config.paycheckJobs[plr.job] then
        exports.WrenchOS:addMoney(plrid, "cash", Config.paycheckJobs[plr.job])
        exports.ox_inventory:AddItem(plrid, "cash", Config.paycheckJobs[plr.job])
    end
end)
