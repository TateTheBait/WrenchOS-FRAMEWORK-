DEPENDENCIES:
You will need Ox_lib and OxMySql for this framework.

This is a framework primarily meant to be added to standalone servers to support jobs, and half-economy.

It is good if you want Ox_Inventory in a VMenu server, without adding a large scale change to your server systems.

MORE INFO AT <a>https://tatethebait.github.io/WrenchOSdocs/</a>


(IT SHOULD AUTO-INSTALL THE SQL. IF IT DOESN'T IT COMES WITH THE FILE.)
<br><br>

Exports: ( For devs :) )<br>
    exports.WrenchOS:changeJob(plrid, job)<br>
    exports.WrenchOS:addMoney(plrid, "bank" | "cash", amount)<br>
    exports.WrenchOS:withdrawMoney(plrid, "bank" | "cash", amount)<br>
    exports.WrenchOS:getPlayer(plrid)<br>
    exports.WrenchOS:spawnVehicle(coords, model)<br>
    exports.WrenchOS:getPlayers()
