local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	local drinks = { "saffron_drink" }
    for k,v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('qb-bakery:client:Drink', source, item.name) end) end
	
	local food = { "napeloni", "cup_cake" , "donut"}
    for k,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('qb-bakery:client:Eat', source, item.name) end) end
end)

RegisterServerEvent('qb-bakery:giveflour', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local Item = Player.Functions.GetItemByName('wheat')
    if Item ~= nil and Item.amount > 0  then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['wheat'], "remove") 
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['flour'], "add") 
        Player.Functions.RemoveItem('wheat', Item.amount)
        Player.Functions.AddItem('flour', math.floor(Item.amount))
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Dont Have Wheat..', 'error')
    end
end)

RegisterServerEvent('qb-bakery:GetFood', function(ItemMake, tablenumber, craftable)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	local amount = 2
	if craftable ~= nil then
		for k, v in pairs(craftable[tonumber(tablenumber)][tostring(ItemMake)]) do
			if Config.Debug then print("GetFood Table Result: craftable["..tablenumber.."]['"..ItemMake.."']['"..k.."']['"..v.."']") end		
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(k)], "remove", v) 
			Player.Functions.RemoveItem(tostring(k), v)
		end
		if craftable[tonumber(tablenumber)]["amount"] ~= nil then amount = craftable[tonumber(tablenumber)]["amount"] else amount = 2 end
	end
	--This should give the item, while the rest removes the requirements
	Player.Functions.AddItem(ItemMake, amount, false, {["quality"] = nil})
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ItemMake], "add", amount)
	
	if Config.Debug then print("Giving ["..src.."]: x"..amount.." "..ItemMake) end		
end)

---ITEM REQUIREMENT CHECKS
QBCore.Functions.CreateCallback('qb-bakery:get', function(source, cb, item, tablenumber, craftable)
	local src = source
	local hasitem = nil
	local hasanyitem = nil
		for k, v in pairs(craftable[tonumber(tablenumber)][tostring(item)]) do
			if QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k) and QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k).amount >= v then 
				hasitem = true
				number = tostring(QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k).amount)
			else
				hasitem = false 
				hasanyitem = false
				number = "0"
			end
			if Config.Debug then print("craftable["..tablenumber.."]['"..item.."']['"..k.."']['"..v.."'] = "..tostring(hasitem).." ("..tostring(number)..")") 
			hasitem = nil
			end
		end
	if hasanyitem == false then cb(false)
	elseif hasanyitem == nil then cb(true) end
end)