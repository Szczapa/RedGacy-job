fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'


client_scripts {
	'client/client.lua',
}
shared_scripts {
    'config.lua',
    'menu/menu.lua'
}

server_scripts {
	'server/server.lua'
}

dependency 'qbr-core'

