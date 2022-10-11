fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

shared_scripts {
	'@qbr-core/shared/locale.lua',
	'locale/fr.lua',
	'config.lua'
}

client_scripts {
	'client/client.lua',
	'client/craft.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

dependency 'qbr-core'
dependency 'qbr-menu'
