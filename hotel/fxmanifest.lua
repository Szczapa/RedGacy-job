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
	'client/chambre/chambre1.lua',
	'client/chambre/chambre2.lua',
	'client/chambre/chambre3.lua',
	'client/chambre/chambre4.lua',
	'client/chambre/chambre5.lua',
	'client/chambre/locksysteme.lua'

}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

dependency 'qbr-core'
dependency 'rsg_alerts'
