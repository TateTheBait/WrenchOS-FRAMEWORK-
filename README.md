readme.md
<br>
<br>
<br>
By default, WrenchOS will come with some commands.
<br>
To enable users to use these commands, add this to your server.cfg:
    add_ace group.[GROUPNAME] WrenchOS.admincmds allow
    Example: add_ace group.WrenchAdmin WrenchOS.admincmds allow
<br>
<br>
Exports: ( For devs :) )
    exports.WrenchOS:changeJob(plrid, job)
    exports.WrenchOS:addMoney(plrid, "bank" | "cash", amount)
    exports.WrenchOS:withdrawMoney(plrid, "bank" | "cash", amount)
    exports.WrenchOS:getPlayer(plrid)
    exports.WrenchOS:spawnVehicle(coords, model)
    exports.WrenchOS:getPlayers()
<br>
THE MAIN FUNCTION OF WRENCHOS, IS THAT ALL OF THE EXPORTS WORK ON CLIENT AND SERVER
<br><br>

MORE INFO AT <a>https://tatethebait.github.io/WrenchOSdocs/</a>
