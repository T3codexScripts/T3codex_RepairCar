fx_version 'cerulean'
game 'gta5'

lua54 'yes' -- Enable Lua 5.4

author 'T3Dev'
description 'Repair Car Script with Animations and Localization for QBCore with ox_inventory'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/*.lua', -- Include the locales file as a shared script
    'config.lua',     -- Include the config file
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Include oxmysql if using it
    'server.lua',
}

escrow_ignore {
    'config.lua',
    'locales/*'
}

dependencies {
    'qb-core',
--    'ox_inventory',
    'oxmysql',
}
