local QBCore = exports['qb-core']:GetCoreObject()
local Locales = Locales or {}
Config = Config or {}

-- Function to get localized text
local function _U(entry)
    return Locales[Config.Locale][entry] or entry
end

RegisterNetEvent('T3Dev_RepairCar:useRepairKit', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = QBCore.Functions.GetClosestVehicle(coords)

    if vehicle ~= 0 and DoesEntityExist(vehicle) and #(coords - GetEntityCoords(vehicle)) < 3.0 then
        if IsPedInAnyVehicle(playerPed, false) then
            QBCore.Functions.Notify(_U('cannot_repair_in_vehicle'), 'error')
            return
        end

        local animDict = 'mini@repair'
        local animName = 'fixing_a_ped'

        -- Load animation dictionary
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end

        -- Ensure the vehicle is networked
        if not NetworkGetEntityIsNetworked(vehicle) then
            NetworkRegisterEntityAsNetworked(vehicle)
            while not NetworkGetEntityIsNetworked(vehicle) do
                Wait(0)
            end
        end

        -- Get the vehicle's network ID
        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)

        -- Open the vehicle's hood
        SetVehicleDoorOpen(vehicle, 4, false, false)
        -- Synchronize hood opening with other clients
        TriggerServerEvent('T3Dev_RepairCar:syncHoodOpen', vehicleNetId)

        -- Start animation
        TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 49, 0, false, false, false)

        -- Progress Bar with configurable repair time
        QBCore.Functions.Progressbar('repair_vehicle', _U('repairing_vehicle'), Config.RepairTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- On Complete
            -- Stop animation
            ClearPedTasks(playerPed)

            -- Close the vehicle's hood
            SetVehicleDoorShut(vehicle, 4, false)
            -- Synchronize hood closing with other clients
            TriggerServerEvent('T3Dev_RepairCar:syncHoodClose', vehicleNetId)

            -- Ensure the player has control over the vehicle
            NetworkRequestControlOfEntity(vehicle)
            local timeout = 2000
            local startTime = GetGameTimer()
            while not NetworkHasControlOfEntity(vehicle) and (GetGameTimer() - startTime) < timeout do
                Wait(0)
            end

            -- Apply repairs locally
            SetVehicleFixed(vehicle)
            SetVehicleDirtLevel(vehicle, 0.0)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
            QBCore.Functions.Notify(_U('vehicle_repaired'), 'success')

            -- Remove one repair kit from inventory and update vehicle state
            TriggerServerEvent('T3Dev_RepairCar:removeRepairKit', vehicleNetId)

            -- Notify the server to synchronize the vehicle repair
            TriggerServerEvent('T3Dev_RepairCar:syncRepair', vehicleNetId)
        end, function() -- On Cancel
            -- Stop animation
            ClearPedTasks(playerPed)

            -- Close the vehicle's hood
            SetVehicleDoorShut(vehicle, 4, false)
            -- Synchronize hood closing with other clients
            TriggerServerEvent('T3Dev_RepairCar:syncHoodClose', vehicleNetId)

            QBCore.Functions.Notify(_U('repair_cancelled'), 'error')
        end)
    else
        QBCore.Functions.Notify(_U('no_vehicle_nearby'), 'error')
    end
end)

-- Event handler for synchronizing vehicle repair
RegisterNetEvent('T3Dev_RepairCar:syncRepair', function(vehicleNetId)
    if vehicleNetId then
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if DoesEntityExist(vehicle) then
            -- Apply the repair to the vehicle
            SetVehicleFixed(vehicle)
            SetVehicleDirtLevel(vehicle, 0.0)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
        end
    end
end)

-- Event handler for synchronizing hood opening
RegisterNetEvent('T3Dev_RepairCar:syncHoodOpen', function(vehicleNetId)
    if vehicleNetId then
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if DoesEntityExist(vehicle) then
            SetVehicleDoorOpen(vehicle, 4, false, false)
        end
    end
end)

-- Event handler for synchronizing hood closing
RegisterNetEvent('T3Dev_RepairCar:syncHoodClose', function(vehicleNetId)
    if vehicleNetId then
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if DoesEntityExist(vehicle) then
            SetVehicleDoorShut(vehicle, 4, false)
        end
    end
end)
