ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("fxbanking:doQuickDeposit")
AddEventHandler("fxbanking:doQuickDeposit", function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local curBank = xPlayer.getMoney()
    while xPlayer == nil do Wait(0) end
    if tonumber(amount) <= curBank then
        xPlayer.removeMoney(tonumber(amount))
        xPlayer.addAccount("bank", tonumber(amount))
        TriggerClientEvent("fxbanking:refreshBank", src)
        TriggerClientEvent("notification", src, "You made a cash deposit of $ " .. amount .. " successfully.", 69)
    else
        TriggerClientEvent("notification", src, "You don't have that amount on your cash wallet.", 2)
    end
end)

RegisterServerEvent("fxbanking:doQuickWithdraw")
AddEventHandler("fxbanking:doQuickWithdraw", function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local curBank = xPlayer.getAccount("bank")
    while xPlayer == nil do Wait(0) end
    if tonumber(amount) <= curBank then
        xPlayer.addMoney(tonumber(amount))
        xPlayer.removeAccount("bank", tonumber(amount))
        TriggerClientEvent("fxbanking:refreshBank", src)
        TriggerClientEvent("notification", src, "You made a cash withdrawl of $ " .. amount .. " successfully.", 69)
    else
        TriggerClientEvent("notification", src, "You don't have that amount on your bank wallet.", 2)
    end
end)