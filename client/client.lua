local QBCore = exports['qb-core']:GetCoreObject()

PlayerJob = {}
local onDuty = false

local function installCheck()
	local items = {"donut"}
	for k, v in pairs(items) do if QBCore.Shared.Items[v] == nil then print("Missing Item from QBCore.Shared.Items: '"..v.."'") end end
	if QBCore.Shared.Jobs["baker"] == nil then print("Error: Job role not found - 'baker'") end
	if Config.Debug then print(" Total seating locations") end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
		installCheck()
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then if PlayerData.job.name == "baker" then TriggerServerEvent("QBCore:ToggleDuty") end end
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate') AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty') AddEventHandler('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource)
	installCheck()
    if GetCurrentResourceName() == resource then
		QBCore.Functions.GetPlayerData(function(PlayerData)
			PlayerJob = PlayerData.job
			if PlayerData.job.name == "baker" then onDuty = PlayerJob.onduty end
		end)
    end
end)

local function jobCheck()
	canDo = true
	if not onDuty then TriggerEvent('QBCore:Notify', "Not clocked in!", 'error') canDo = false end
	return canDo
end

CreateThread(function()
	local bossroles = {}
	for k, v in pairs(QBCore.Shared.Jobs["baker"].grades) do
		if QBCore.Shared.Jobs["baker"].grades[k].isboss == true then
			if bossroles["baker"] ~= nil then
				if bossroles["baker"] > tonumber(k) then bossroles["baker"] = tonumber(k) end
			else bossroles["baker"] = tonumber(k)	end
		end
	end
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].zoneEnable then
			JobLocation = PolyZone:Create(Config.Locations[k].zones, { name = Config.Locations[k].label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside) if not isPointInside and onDuty and PlayerJob.name == "baker" then TriggerServerEvent("QBCore:ToggleDuty") end end)
		end
	end
	for k, v in pairs(Config.Locations) do
		if 1 == 1 then
			blip = AddBlipForCoord(Config.Locations[k].blip)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 106)
			SetBlipColour(blip, Config.Locations[k].blipcolor)
			SetBlipScale(blip, 0.7)
			SetBlipDisplay(blip, 6)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString("Bakery")
			EndTextCommandSetBlipName(blip)
		end
	end

    exports["qb-target"]:AddBoxZone("ardtolidkon", vector3(2367.932, 4942.401, 42.485), 1.5, 1.5, {
        name="ardtolidkon",
        heading=0,
        debugPoly=false,
        minZ=41.13,
        maxZ=43.13,
    }, {
        options = {
            {
                event = "qb-bakery:takeflo",
                icon = "fas fa-cash-register",
                label = "Get Flour",
            },
        },
        distance = 2
    });
    -- local pedias = {
    --     GetHashKey("ig_old_man2")
    -- }
    -- exports["qb-target"]:AddTargetModel(pedias, {
    --     options = {
    --         {
    --             event = "qb-bakery:takeflo",
    --             icon = "fas fa-cash-register",
    --             label = "Get Flour",
    --         },
    --     },
    --     distance = 2.0
    -- })

		exports['qb-target']:AddBoxZone("BakeryWash", vector3(386.49, -791.94, 29.29), 0.3, 0.6, { name="BakeryWash", heading = 179.0, debugPoly=Config.Debug, minZ=78.00, maxZ=29.99 },
			{ options = { { event = "qb-bakery:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands", job = "baker" }, }, distance = 1.5 })

		exports['qb-target']:AddBoxZone("BakeryCounter", vector3(386.47, -794.84, 29.29), 0.5,0.5, { name="BakeryCounter", heading = 205.0, debugPoly=Config.Debug, minZ=28.00, maxZ=29.99 },
			{ options = { { event = "qb-bakery:Stash", icon = "fas fa-mug-saucer", label = "Open Counter", stash = "Counter" }, }, distance = 2.0 })

		-- exports['qb-target']:AddBoxZone("BakeryReceipt", vector3(-1261.54, -290.133, 38.048), 0.6, 0.6, { name="BakeryReceipt", heading = 144.8, debugPoly=Config.Debug, minZ=36.45, maxZ=38.45 },
		-- 	{ options = { { event = "qb-payments:client:Charge", icon = "fas fa-credit-card", label = "Charge Customer", job = "baker",
		-- 	img = "<center><p><img src=https://cdn.discordapp.com/attachments/944039196203552799/949814700068200448/bakeryText.png width=100px></p>"
		-- 	} }, distance = 2.0 })
		-- exports['qb-target']:AddBoxZone("BakeryReceipt2",vector3(-1264.61, -291.300, 38.049), 0.6, 0.6, { name="BakeryReceipt2", heading = 210.5, debugPoly=Config.Debug, minZ=36.45, maxZ=38.45 },
		-- 	{ options = { { event = "qb-payments:client:Charge", icon = "fas fa-credit-card", label = "Charge Customer", job = "baker",
		-- 	img = "<center><p><img src=https://cdn.discordapp.com/attachments/944039196203552799/949814700068200448/bakeryText.png width=100px></p>"
		-- 	} }, distance = 2.0 })

			--Stashes
		exports['qb-target']:AddBoxZone("BakeryPrepared", vector3(389.17, -797.3, 29.29), 0.6, 0.6, { name="BakeryPrepared", heading = 243.0, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45 },
		{ options = { {  event = "qb-bakery:Stash", icon = "fas fa-box-open", label = "Prepared Food", stash = "Shelf", job = "baker" }, },  distance = 2.0 })
		--FRIDGE
		exports['qb-target']:AddBoxZone("BakeryFridge", vector3(391.61, -789.74, 29.29), 1.5, 0.5, { name="BakeryFridge", heading = 96.35, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45 },
			{ options = { {  event = "qb-bakery:Stash", icon = "fas fa-temperature-low", label = "Open Fridge", stash = "Fridge", job = "baker" }, }, distance = 1.0 })

		--WARESTORAGE
		exports['qb-target']:AddBoxZone("BakeryStorage", vector3(388.62, -789.86, 29.29), 1.5, 1.5, { name="BakeryStorage", heading = 22.04, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45 },
			{ options = { {  event = "qb-bakery:Shop", icon = "fas fa-box-open", label = "Open Store", job = "baker" }, }, distance = 2.0 })
		--Oven
		exports['qb-target']:AddBoxZone("BakeryOven", vector3(384.94, -793.97, 29.78), 2.5, 0.6, { name="BakeryOven", heading = 27.05, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45, },
			{ options = { { event = "qb-bakery:Menu:Oven", icon = "fas fa-temperature-high", label = "Use Oven", job = "baker" }, }, distance = 2.0 })
		--Hob
		exports['qb-target']:AddBoxZone("BakeryHob", vector3(379.99, -792.25, 28.91), 0.5, 0.6, { name="BakeryHob", heading = 0, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45, },
			{ options = { { event = "qb-bakery:Menu:Hob", icon = "fas fa-recycle", label = "Use Mixer", job = "baker" }, }, distance = 2.0 })
		--Coffee
		exports['qb-target']:AddBoxZone("BakeryCoffee", vector3(380.05, -796.74, 28.91), 0.7, 0.5, { name="BakeryCoffee", heading = 0, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45 },
			{ options = { { event = "qb-bakery:Menu:Drinks", icon = "fas fa-mug-hot", label = "Pour Coffee", job = "baker" }, }, distance = 2.0 })
		--Chopping Board
		exports['qb-target']:AddBoxZone("BakeryBoard",vector3(382.98, -792.92, 28.96), 0.5, 0.6, { name="BakeryBoard", heading = 19.54, debugPoly=Config.Debug, minZ=28.45, maxZ=29.45, },
			{ options = { { event = "qb-bakery:Menu:ChoppingBoard", icon = "fas fa-utensils", label = "Prepare Dough", job = "baker" }, }, distance = 2.0 })
		--Clockin
		exports['qb-target']:AddBoxZone("BakeryClockin", vector3(385.25, -789.51, 29.14), 0.5, 0.5, { name="BakeryClockin", heading = 0, debugPoly=Config.Debug,minZ=28.45, maxZ=29.45 },
			{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = "Toggle Duty", job = "baker" },
						--{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-clipboard-check", label = "Open Bossmenu", job = bossroles, },
						}, distance = 2.0 })

						exports['qb-target']:AddBoxZone('bakerystash', vector3(379.96, -795.11, 29.14), 0.9, 0.7, {
							name="bakerystash",
							heading = 96,
							debugPoly=false,
							useZ=true,
							},{
								options = {
									{
										event = "qb-bakery:client:openstashbakery",
										icon = "fas fa-cogs",
										label = 'Stash Large',
										job = 'baker'
									}
								},
								distance = 2.0
							})
end)

RegisterNetEvent('qb-bakery:takeflo',function()
    if PlayerJob.name == "baker" then
        QBCore.Functions.TriggerCallback("QBCore:HasItem", function(data)
            if data then
                QBCore.Functions.Progressbar('washing_hands', 'Makeing Flour', 30000, false, false, {
					disableMovement = true, --
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function()
					TriggerServerEvent('qb-bakery:giveflour')
					QBCore.Functions.Notify("You\'ve Get your Flours!", "success")
				end, function() -- Cancel
					TriggerEvent('inventory:client:busy:status', false)
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
            else
                QBCore.Functions.Notify("You don\'t have all ingredients!", "error")
            end
        end, "wheat")
    else
        QBCore.Functions.Notify("You aren\'t a Bakery employee!", "error")
    end
end)

RegisterNetEvent('qb-bakery:washHands', function()
    QBCore.Functions.Progressbar('washing_hands', 'Washing hands', 5000, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = false, },
	{ animDict = "mp_arresting", anim = "a_uncuff", flags = 8, }, {}, {}, function()
		TriggerEvent('QBCore:Notify', "You've washed your hands!", 'success')
	end, function()
        TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Cancelled", 'error')
    end)
end)

RegisterNetEvent('qb-bakery:MakeItem', function(data)
	local amount = nil
	if data.craftable then
		for k, v in pairs(data.craftable[data.tablenumber]) do
			QBCore.Functions.TriggerCallback('qb-bakery:get', function(amount)
				if not amount then
					TriggerEvent('QBCore:Notify', "You don't have the correct ingredients", 'error')
				else
					TriggerEvent("qb-bakery:FoodProgress", data.item, data.tablenumber, data.craftable)
				end
			end, data.item, data.tablenumber, data.craftable)
		end
	end
end)

RegisterNetEvent('qb-bakery:Menu:Oven', function()
	if not jobCheck() then return end
	local OvenMenu = {}
	OvenMenu[#OvenMenu + 1] = { header = "Oven Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Oven do
			for k, v in pairs(Crafting.Oven[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.Oven[i]["img"] ~= nil then setheader = Crafting.Oven[i]["img"]..setheader end
					for l, b in pairs(Crafting.Oven[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					OvenMenu[#OvenMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext,
												params = { event = "qb-bakery:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Oven,
														   bartext = "Preparing a ", time = 5000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(OvenMenu)
end)

RegisterNetEvent('qb-bakery:Menu:Hob', function()
	if not jobCheck() then return end
	local HobMenu = {}
	HobMenu[#HobMenu + 1] = { header = "Hob Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Hob do
			for k, v in pairs(Crafting.Hob[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.Hob[i]["img"] ~= nil then setheader = Crafting.Hob[i]["img"]..setheader end
					for l, b in pairs(Crafting.Hob[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					HobMenu[#HobMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext,
											  params = { event = "qb-bakery:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Hob,
														 bartext = "Preparing a ", time = 7000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(HobMenu)
end)

RegisterNetEvent('qb-bakery:Menu:ChoppingBoard', function()
	if not jobCheck() then return end
	local ChopMenu = {}
	ChopMenu[#ChopMenu + 1] = { header = "Chopping Board", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.ChoppingBoard do
			for k, v in pairs(Crafting.ChoppingBoard[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.ChoppingBoard[i]["img"] ~= nil then setheader = Crafting.ChoppingBoard[i]["img"]..setheader end
					for l, b in pairs(Crafting.ChoppingBoard[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
					end
					ChopMenu[#ChopMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext,
												params = { event = "qb-bakery:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.ChoppingBoard,
														   bartext = "Preparing a ", time = 7000, animDict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_b_idle" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(ChopMenu)
end)

RegisterNetEvent('qb-bakery:client:openstashbakery', function()
	TriggerEvent("inventory:client:SetCurrentStash", 'BakeryStashApolo')
	TriggerServerEvent("inventory:server:OpenInventory", "stash", 'BakeryStashApolo', { maxweight = 6000000, slots = 170, })
end)

RegisterNetEvent('qb-bakery:JustGive', function(data) if not jobCheck() then return else TriggerEvent("qb-bakery:FoodProgress", data.id, nil, nil)  end end)

RegisterNetEvent('qb-bakery:Stash', function(data) TriggerServerEvent("inventory:server:OpenInventory", "stash", "bakery_"..data.stash) TriggerEvent("inventory:client:SetCurrentStash", "bakery_"..data.stash) end)

RegisterNetEvent('qb-bakery:Shop', function(data)	if not onDuty then TriggerEvent('QBCore:Notify', "Not clocked in!", 'error') else TriggerServerEvent("inventory:server:OpenInventory", "shop", "bakery", Config.FoodItems)	end end)

RegisterNetEvent('qb-bakery:FoodProgress', function(ItemMake, tablenumber, craftable)
	if craftable then
		for k, v in pairs(craftable[tablenumber]) do
			if ItemMake == k then
				bartext = "Making "
				bartime = 5000
				animDictNow = "mp_ped_interaction"
				animNow = "handshake_guy_a"
			end
		end
	elseif craftable == nil then
		bartext = "Grabbing "
		bartime = 3500
		animDictNow = "mp_ped_interaction"
		animNow = "handshake_guy_a"
	end
	QBCore.Functions.Progressbar('making_food', bartext..QBCore.Shared.Items[ItemMake].label, bartime, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
	{ animDict = animDictNow, anim = animNow, flags = 16, }, {}, {}, function()
		TriggerServerEvent('qb-bakery:GetFood', ItemMake, tablenumber, craftable)
		StopAnimTask(GetPlayerPed(-1), animDictNow, animNow, 1.0)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Cancelled!", 'error')
	end)
end)

RegisterNetEvent('qb-bakery:Menu:Drinks', function()
	if not jobCheck() then return end
	local DrinksMenu = {}
	DrinksMenu[#DrinksMenu + 1] = { header = "Drinks Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Drinks do
			for k, v in pairs(Crafting.Drinks[i]) do
				local text = ""
				for l, b in pairs(Crafting.Drinks[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					text = text..""..QBCore.Shared.Items[l].label..number.."<br>"
					settext = 	text							end
				DrinksMenu[#DrinksMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..QBCore.Shared.Items[k].label, txt = settext, params = { event = "qb-bakery:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Drinks } } }
				settext = nil
				end
		end
	exports['qb-menu']:openMenu(DrinksMenu)
end)

RegisterNetEvent('qb-bakery:client:Drink', function(itemName)
	if itemName == "sprunk" or itemName == "sprunklight" then TriggerEvent('animations:client:EmoteCommandStart', {"sprunk"})
	elseif itemName == "ecola" or itemName == "ecolalight" then TriggerEvent('animations:client:EmoteCommandStart', {"ecola"})
	elseif itemName == "ecocoffee" then TriggerEvent('animations:client:EmoteCommandStart', {"bmcoffee"})
	--elseif itemName == "flusher" then TriggerEvent('animations:client:EmoteCommandStart', {"bmcoffee2"})
	elseif itemName == "caffeagra" then TriggerEvent('animations:client:EmoteCommandStart', {"bmcoffee3"})
	else TriggerEvent('animations:client:EmoteCommandStart', {"coffee"}) end
	QBCore.Functions.Progressbar("drink_something", "Drinking "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true, },
	{}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
		if QBCore.Shared.Items[itemName].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst) end
		if QBCore.Shared.Items[itemName].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger) end
		local startStamina = 50
        while startStamina > 0 do
            Citizen.Wait(100)
                RestorePlayerStamina(PlayerId(), 1.0)
            startStamina = startStamina - 1
        end
        startStamina = 0
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	end)
end)

RegisterNetEvent('qb-bakery:client:Eat', function(itemName)
	if itemName == "crisps" then TriggerEvent('animations:client:EmoteCommandStart', {"crisps"})
	elseif itemName == "beandonut" then TriggerEvent('animations:client:EmoteCommandStart', {"donut2"})
	elseif itemName == "chocolate" then TriggerEvent('animations:client:EmoteCommandStart', {"egobar"})
	else TriggerEvent('animations:client:EmoteCommandStart', {"sandwich"}) end
    QBCore.Functions.Progressbar("eat_something", "Eating "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = true, },
	{}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		if QBCore.Shared.Items[itemName].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst) end
		if QBCore.Shared.Items[itemName].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger) end
        --TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
		local startStamina = 50
        while startStamina > 0 do
            Citizen.Wait(100)
                RestorePlayerStamina(PlayerId(), 1.0)
            startStamina = startStamina - 1
        end
        startStamina = 0
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
			exports['qb-target']:RemoveZone("BakeryWash")
			exports['qb-target']:RemoveZone("BakeryCounter")
			exports['qb-target']:RemoveZone("BakerySoda")
			exports['qb-target']:RemoveZone("BakerySlush")
			exports['qb-target']:RemoveZone("BakeryDrink")
			exports['qb-target']:RemoveZone("BakeryDrink2")
			exports['qb-target']:RemoveZone("BakeryFridge")
			exports['qb-target']:RemoveZone("BakeryFridge2")
			exports['qb-target']:RemoveZone("BakeryReceipt")
			exports['qb-target']:RemoveZone("BakeryReceipt2")
			exports['qb-target']:RemoveZone("BakeryCounter")
			exports['qb-target']:RemoveZone("BakeryCounter2")
			exports['qb-target']:RemoveZone("BakeryWash2")
	end
end)