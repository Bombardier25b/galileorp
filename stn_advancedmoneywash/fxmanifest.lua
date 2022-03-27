fx_version 'adamant'

games { 'gta5' }

ui_page 'html/ui.html'

client_scripts {

	'@es_extended/locale.lua',
	'config.lua',
	'cl_advancedmoneywash.lua',
	'notif.lua'
}

server_scripts {

	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'sv_advancedmoneywash.lua'
}

files {
	'html/style.css',
	'html/app.js',
	'html/ui.html',
}