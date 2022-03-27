ESX = nil

local NPCspawned                = false
local cooldown = 0
local activity = 0
local activitySource = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('stn_advancedmoneywash:washMoney')
AddEventHandler('stn_advancedmoneywash:washMoney', function(amount, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local taxrate
	
	taxrate = Config.Taxation	
	amount = ESX.Math.Round(tonumber(amount))
	washedCash = amount * taxrate
	finalpay = ESX.Math.Round(tonumber(washedCash))

	
	
	if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
  		xPlayer.removeAccountMoney('black_money', amount)
		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(finalpay) .. _U('clean_money'))
		TriggerClientEvent('notifications', xPlayer.source, "#33FF7D", "Success", _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(finalpay) .. _U('clean_money'))
		xPlayer.addMoney(finalpay)
		cooldown = Config.CooldownMinutes * 60000
		TriggerClientEvent('stn_advancedmoneywash:checkpayandnotify', xPlayer.source, amount)
				
	else
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('invalid_amount'))
		
	end
	
	
end)

ESX.RegisterServerCallback('stn_advancedmoneywash:isActive',function(source, cb)
	cb(activity, cooldown)
  end)

ESX.RegisterServerCallback('stn_advancedmoneywash:anycops',function(source, cb)
	local anycops = 0
	local playerList = ESX.GetPlayers()
	for i=1, #playerList, 1 do
	  local _source = playerList[i]
	  local xPlayer = ESX.GetPlayerFromId(_source)
	  local playerjob = xPlayer.job.name
	  if playerjob == 'police' then
		anycops = anycops + 1
	  end
	end
	cb(anycops)
end)

RegisterServerEvent('stn_advancedmoneywash:cooldown')
AddEventHandler('stn_advancedmoneywash:cooldown', function()
	cooldown = Config.CooldownMinutes * 60000
end)	

RegisterServerEvent('stn_advancedmoneywash:registerActivity')
AddEventHandler('stn_advancedmoneywash:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		--Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('stn_advancedmoneywash:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

ESX.RegisterServerCallback('stn_advancedmoneywash:getmoney',function(source, cb)
	local money = 0
	local xPlayer = ESX.GetPlayerFromID(source)
	money = xPlayer.getAccount('black_money').money
	num = xPlayer.getInventoryItem(Config.ItemName).count
	cb(money)
	
end)

RegisterServerEvent('stn_advancedmoneywash:alertcops')
AddEventHandler('stn_advancedmoneywash:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('stn_advancedmoneywash:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)
RegisterServerEvent('stn_advancedmoneywash:giveItem')
AddEventHandler('stn_advancedmoneywash:giveItem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	num = xPlayer.getInventoryItem(Config.ItemName).count
	if num <= 0 then
		xPlayer.addInventoryItem(Config.ItemName, 1)
	else
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('already_item'))
	end		
end)

RegisterServerEvent('stn_advancedmoneywash:removeItem')
AddEventHandler('stn_advancedmoneywash:removeItem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	num = xPlayer.getInventoryItem(Config.ItemName).count
	if num >= 1 then
		xPlayer.removeInventoryItem(Config.ItemName, 1)
	else
		TriggerClientEvent("stn_advancedmoneywash:abortmission")
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('no_item'))	
	end		
end)



RegisterServerEvent('stn_advancedmoneywash:stopalertcops')
AddEventHandler('stn_advancedmoneywash:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('stn_advancedmoneywash:removecopblip', xPlayers[i])
		end
	end
end)

RegisterServerEvent('stn_advancedmoneywash:sendToDiscord')
AddEventHandler('stn_advancedmoneywash:sendToDiscord', function(amount)
	
  local xPlayer = ESX.GetPlayerFromId(source)
  local id = xPlayer.getIdentifier()
  local logs = Config.Webhook
  local communtiylogo = Config.WebhookLogo --Must end with .png or .jpg
  local name = xPlayer.getName()
  local DATE = os.date(" %H:%M %d.%m.%y")
  local connect = {
	{
		["color"] = "8663711",
		["title"] = "Black Money Wash",
		["title"] = "Amount : $"..amount.."",
		["description"] = "".. name .. " [" .. id .. "] " .. "has washed black money at" .. DATE .. "" ,
		["footer"] = {
		["text"] = "ADVANCED MONEY WASH",
		},
	}
}

PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = Config.WebhookName, embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		--Remove blip for all cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('stn_advancedmoneywash:removecopblip', xPlayers[i])
			end
		end
		--Set activity to 0
		activity = 0
		activitySource = 0
	end
end)

AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)

