ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--[[This is only for if youre using Disc-InventoryHUD

TriggerEvent('disc-inventoryhud:registerItemUse', "gpstracker", function(source, item)
    TriggerEvent('disc-inventoryhud:removeItem', source, item.Id, 1, item.Slot, item.Inventory)
    TriggerClientEvent('Shifty_GPSTracker:attachgps', source)
end)
]]

ESX.RegisterUsableItem('gpstracker', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gpstracker', 1)
    TriggerClientEvent('Shifty_GPSTracker:attachgps', source)
end)

RegisterServerEvent('Shifty_GPSTracker:removeGPSItem')
AddEventHandler('Shifty_GPSTracker:removeGPSItem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gpstracker', 1)
end)

