local sharedItems = exports['qbr-core']:GetItems()

exports['qbr-core']:CreateUseableItem("saloonkit", function(source, item)
    local Player = exports['qbr-core']:GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('saloon:client:saloonkit', source, item.name)
    end
end)

exports['qbr-core']:CreateUseableItem("cuisinekit", function(source, item)
    local Player = exports['qbr-core']:GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('saloon:client:cuisinekit', source, item.name)
    end

end)
