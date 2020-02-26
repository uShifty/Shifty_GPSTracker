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
    local vehicle = ESX.Game.GetVehicleInDirection()

	if IsPedSittingInAnyVehicle(playerPed) then
		TriggerEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You cannot plant a GPS Tracker into the vehicle!', length = 2500,  })
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
                exports['mythic_notify']:SendAlert('inform', 'GPS tracker was attached to the vehicle!')
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('Shifty_GPSTracker:removeGPSItem')
                SetEntityAsMissionEntity(vehicle)
                local gpsTracker = AddBlipForEntity(vehicle)
                SetBlipSprite(gpsTracker, 458)
                SetBlipColour(gpsTracker, 1)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('GPS Tracker')
                EndTextCommandSetBlipName(gpsTracker)
                exports['mythic_notify']:SendAlert('inform', 'GPS tracker was attached to the vehicle!')
                Citizen.Wait(300000)
                RemoveBlip(gpsTracker)
            else
                exports['mythic_notify']:SendAlert('error', 'You have stopped putting the GPS tracker on!')
            end
        end)
	else
        exports['mythic_notify']:SendAlert('error', 'No vehicles nearby!')
    end
end)
