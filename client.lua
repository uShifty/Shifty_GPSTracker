ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do

        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

local vehicle = nil
local gps = nil
local tracking = false

RegisterNetEvent('Shifty_GPSTracker:attachgps')
AddEventHandler('Shifty_GPSTracker:attachgps', function()
    local playerPed = PlayerPedId()
    vehicle = ESX.Game.GetVehicleInDirection()

	if IsPedSittingInAnyVehicle(playerPed) then
		TriggerEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You cannot plant a GPS Tracker into the vehicle!', length = 2500,  })
		return
	end

	if DoesEntityExist(vehicle) then
        local oldheading = GetEntityHeading(playerPed)
        local newheading = oldheading-180
        SetEntityHeading(playerPed, newheading)
        exports['mythic_progbar']:Progress({
            name = "install_gps_tracker",
            duration = 4900,
            label = 'Installing GPS tracker',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mini@cpr@char_b@cpr_str",
                anim = "cpr_kol",
                flag = 40,
            },
            animationTwo = {
                animDict = "amb@world_human_vehicle_mechanic@male@base", --anim@amb@clubhouse@tutorial@bkr_tut_ig3
                anim = "base",
                flags = 49,
            }
        }, function(cancelled)
            if not cancelled then
                ClearPedTasks(playerPed)
                exports['mythic_notify']:SendAlert('inform', 'Sucsess')
                TriggerEvent('Shifty_GPSTracker:gpsON', vehicle)
                
            else
                exports['mythic_notify']:SendAlert('inform', 'Failed')
            end
        end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
    end
end)

RegisterNetEvent('Shifty_GPSTracker:gpsON')
AddEventHandler('Shifty_GPSTracker:gpsON', function(veh)
    gps = AddBlipForEntity(veh)
    SetBlipSprite(gps, 1)
    SetBlipRoute(gps, true)
    SetEntityAsMissionEntity(veh, true, true)

    if not tracking then
        tracking = true
        exports['mythic_notify']:SendAlert('inform', 'GPS Tracker Attached To Vehicle!')
        while trackingr do
            Citizen.Wait(0)
            if veh ~= nil then
                if not IsEntityAVehicle(veh) then
                    exports['mythic_notify']:SendAlert('inform', 'GPS Tracker Transmittion Lost!')
                    tracking = false
              end
            else
                tracking = false
            end
        end
    end
end)
