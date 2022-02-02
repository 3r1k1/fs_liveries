ESX = nil

CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Wait(100)
	end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
    ESX.PlayerData.job = job
end)

RegisterCommand('liveries', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerLoaded then
        if IsPedInAnyVehicle(PlayerPedId()) then
            OpenLiveryMenu()
        else
            ESX.ShowNotification('~r~Tienes que estar dentro de un vehiculo.')
        end
    else
        ESX.ShowNotification('~r~No puedes usar esto.')
    end
end)
RegisterKeyMapping('liveries', '(LSPD/LSSD) Menu Liveries', 'keyboard', '')

OpenLiveryMenu = function()
    local elements = {}
    local veh = GetVehiclePedIsIn(PlayerPedId())
    local livery = GetVehicleLiveryCount(veh)

    for i=1, livery, 1 do
        table.insert(elements, {
            label = 'Livery ' ..i,
            id = i,
            vehicle = veh
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
        title = 'Liveries',
        align = 'right',
        elements = elements
    }, function(data, menu)
        SetVehicleLivery(veh, data.current.id)
        -- menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

RegisterCommand('extras', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerLoaded then
        if IsPedInAnyVehicle(PlayerPedId()) then
            OpenExtrasMenu()
        else
            ESX.ShowNotification('~r~Tienes que estar dentro de un vehiculo.')
        end
    else
        ESX.ShowNotification('~r~No puedes usar esto.')
    end
end)
RegisterKeyMapping('extras', '(LSPD/LSSD) Menu Extras', 'keyboard', '')

OpenExtrasMenu = function()
    local elements = {}
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    for extraId = 0, 20 do
        if DoesExtraExist(vehicle, extraId) then
            local labelText
            if IsVehicleExtraTurnedOn(vehicle, extraId) then
                labelText = ('%s | <span style="color:green;">Activado</span>'):format(extraId)
            else
                labelText = ('%s | <span style="color:red;">Desactivado</span>'):format(extraId)
            end

            table.insert(elements, {
                label = 'Extra ' ..labelText,
                value = extraId
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_menu', {
        title = 'Extras',
        align = 'right',
        elements = elements
    }, function(data, menu)
        if IsVehicleExtraTurnedOn(vehicle, data.current.value) then
            SetVehicleExtra(vehicle, data.current.value, 1)
        else
            SetVehicleExtra(vehicle, data.current.value, 0)
        end

        OpenExtrasMenu()
    end, function(data, menu)
        menu.close()
    end)
end