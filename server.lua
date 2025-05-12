local QBCore = exports['qb-core']:GetCoreObject()
local Locales = Locales or {}
Config = Config or {}

-- Function to get localized text
local function _U(entry)
    return Locales[Config.Locale][entry] or entry
end

-- Register the repair kit as a usable item using QBCore
QBCore.Functions.CreateUseableItem(Config.RepairKitItem, function(source, item)
    TriggerClientEvent('T3Dev_RepairCar:useRepairKit', source)
end)

RegisterNetEvent('T3Dev_RepairCar:removeRepairKit', function(vehicleNetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        -- Remove the item using QBCore's function (compatible with ox_inventory)
        if Player.Functions.RemoveItem(Config.RepairKitItem, 1) then
            -- Proceed with updating the vehicle in the database
            if vehicleNetId then
                local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
                if vehicle and DoesEntityExist(vehicle) then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    if plate then
                        -- Clean up the plate
                        plate = plate:gsub("^%s*(.-)%s*$", "%1") -- Trim spaces
                        plate = string.upper(plate)

                        -- Fetch vehicle data from the database
                        MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate', {
                            ['@plate'] = plate
                        }, function(result)
                            if result[1] then
                                -- Update vehicle damage state
                                local mods = json.decode(result[1].mods)
                                if mods then
                                    mods.engineHealth = 1000.0
                                    mods.bodyHealth = 1000.0
                                    -- Save updated mods back to the database
                                    MySQL.Async.execute('UPDATE player_vehicles SET mods = @mods WHERE plate = @plate', {
                                        ['@mods'] = json.encode(mods),
                                        ['@plate'] = plate
                                    })
                                end
                            end
                        end)
                    end
                end
            end

            -- Optionally, display the item box removal animation
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RepairKitItem], 'remove')
        else
            -- The player does not have the item or it could not be removed
            TriggerClientEvent('QBCore:Notify', src, _U('no_repair_kit'), 'error')
        end
    else
        print('Player not found for source', src)
    end
end)

-- Event to synchronize the vehicle repair across all clients
RegisterNetEvent('T3Dev_RepairCar:syncRepair', function(vehicleNetId)
    if vehicleNetId then
        -- Broadcast to all clients to repair the vehicle
        TriggerClientEvent('T3Dev_RepairCar:syncRepair', -1, vehicleNetId)
    end
end)

-- Event to synchronize hood opening
RegisterNetEvent('T3Dev_RepairCar:syncHoodOpen', function(vehicleNetId)
    if vehicleNetId then
        TriggerClientEvent('T3Dev_RepairCar:syncHoodOpen', -1, vehicleNetId)
    end
end)

-- Event to synchronize hood closing
RegisterNetEvent('T3Dev_RepairCar:syncHoodClose', function(vehicleNetId)
    if vehicleNetId then
        TriggerClientEvent('T3Dev_RepairCar:syncHoodClose', -1, vehicleNetId)
    end
end)
