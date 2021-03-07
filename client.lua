ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function()
    local status = false
    local location = vector3(150.06, -1040.42, 29.37)

    while true do
        Wait(500)
        local dist = #(GetEntityCoords(PlayerPedId()) - location)
        if dist < 2.5 and not status then
            status = true
            drawTxt(dist.x, dist.y, dist.z, "[E] Banks!")
        elseif status and dist > 2.5 then
            status = false
        end
    end
end)

RegisterNetEvent("fxbanking:refreshBank")
AddEventHandler("fxbanking:refreshBank", function()
    OpenBankAccount()
end)

RegisterNetEvent("fxbanking:refreshAtm")
AddEventHandler("fxbanking:refreshAtm", function()
    OpenAtmAccount()
end)

RegisterNUICallback("doDeposit", function(data)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent("fxbanking:doQuickDeposit", data.amount)
        OpenBankAccount()
    end
end)

RegisterNUICallback("doWithdraw", function(data)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent("fxbanking:doQuickWithdraw", data.amount)
        OpenBankAccount()
    end
end)

RegisterNUICallback("closeNUI", function()
    SetNuiFocus(false, false)
end)

RegisterCommand("hidenui", function()
    NuiCloser()
end)

function drawTxt(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function OpenBankAccount()
    local LocalPlayer = ESX.GetPlayerData()
    SetNuiFocus(true, true)
    SendNUIMessage({['action'] = "show"})
    SendNUIMessage({['action'] = "update", ["data"] = LocalPlayer})
end

function NuiCloser()
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
end
