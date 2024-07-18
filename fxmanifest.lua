author "The Wrench"
description "Wrench Prod."
version "1.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"
server_script '@oxmysql/lib/MySQL.lua'

shared_scripts {
    "config.lua",
    '@ox_lib/init.lua'
}
server_scripts {"Server/*"}
client_scripts {"Client/*",}
