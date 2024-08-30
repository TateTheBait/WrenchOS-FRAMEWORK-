if Config.paychecks == true then
    while true do
        Wait(Config.paycheckintervals*60000)
        lib.callback.await("WrenchOS:Paycheck", false, GetPlayerServerId(PlayerId()))
        lib.notify({
            title = "Jobs",
            description = "You have recieved your paycheck"
        })
    end
end
