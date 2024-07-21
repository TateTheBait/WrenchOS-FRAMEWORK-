readme.md
<br>
<br>
<br>
DEPENDENCIES:
You will need Ox_lib and OxMySql for this framework.

<br>
Just FYI, this isn't a full framework yet, and can be added to any server.
<br>
<br>
By default, WrenchOS will come with some commands.
<br>
To enable users to use these commands, add this to your server.cfg:
<br>
    <t>add_ace group.[GROUPNAME] WrenchOS.admincmds allow
<br>
    <t>Example: add_ace group.WrenchAdmin WrenchOS.admincmds allow
<br>
<br>
Exports: ( For devs :) )
    exports.WrenchOS:changeJob(plrid, job)
    <br>
    exports.WrenchOS:addMoney(plrid, "bank" | "cash", amount)
    <br>
    exports.WrenchOS:withdrawMoney(plrid, "bank" | "cash", amount)
    <br>
    exports.WrenchOS:getPlayer(plrid)
    <br>
    exports.WrenchOS:spawnVehicle(coords, model)
    <br>
    exports.WrenchOS:getPlayers()
<br>
THE MAIN FUNCTION OF WRENCHOS, IS THAT ALL OF THE EXPORTS WORK ON CLIENT AND SERVER
<br><br>

MORE INFO AT <a>https://tatethebait.github.io/WrenchOSdocs/</a>
