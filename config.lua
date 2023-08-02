print("qb-Bakery-ACERP")

-- If you need support I now have a discord available, it helps me keep track of issues and give better support.

-- https://discord.gg/xKgQZ6wZvS

Config = {}
Config.Debug = false  -- false to remove green boxes

Config.Gabz = true -- Set to true if using Gabz legion MLO
Config.UncleJust = false -- Set to true if using Unclejust's Vinewood MLO
-- ^ These are separate from the polyzone locations below
	--Enable to add chairs and job stuff.

Config.link = "qb-inventory/html/images/" -- Change this to your inventory's name and image folder


Config.FoodItems = {
    label = "Food Store",
    slots = 5,
    items = {
        -- [1] = { name = "donutbox", price = 50, amount = 50, info = {}, type = "item", slot = 1, },
        -- [2] = { name = "yeast", price = 5, amount = 150, info = {}, type = "item", slot = 2, },
		-- [3] = { name = "water_bottle", price = 15, amount = 50, info = {}, type = "item", slot = 3, },
		-- [4] = { name = "sugar", price = 10, amount = 50, info = {}, type = "item", slot = 4, },
		-- [5] = { name = "egg", price = 5, amount = 50, info = {}, type = "item", slot = 5, },
    }
}

Config.Locations = {
    [1] = {
		zoneEnable = false,
        label = "baker", -- Set this to the required job
        zones = {
		vector2(393.09, -796.93),
		vector2(393.07, -789.62),
		vector2(382.87, -797.08),
		vector2(382.43, -789.72),
        },
		blip = vector3(383.76, -792.09, 29.27),
		blipcolor = 9,
    },
}

Crafting = {}

Crafting.Slush = {
	--[1] = { ['bigfruit'] = { ['watermelon'] = 1, ['water_bottle'] = 1, ['orange'] = 1, ['sugar'] = 1, }, },
}

Crafting.Drinks = {
	--[1] = { ['saffron_drink'] = { ['saffron'] = 1, ['water_bottle'] = 1,}, },
	--[2] = { ['mshake'] = { ['milk'] = 1, }, },
}

Crafting.ChoppingBoard = {
	[1] = { ['dough'] = { ['water_bottle'] = 1, ['flour'] = 1, ['yeast'] = 1, ['milk'] = 1,}, },
	[2] = { ['noodles'] = { ['egg'] = 2, ['flour'] = 1, ['dough'] = 1, }, },
}

Crafting.Oven = {
	-- [1] = { ['napeloni'] = { ['dough4'] = 1, }, },
	-- [2] = { ['cup_cake'] = { ['dough3'] = 1,}, },
	-- [3] = { ['donut'] = { ['dough2'] = 1, }, },
	-- [4] = { ['burgerbun'] = { ['dough'] = 1,}, },
}

Crafting.Coffee = {
	-- [1] = { ['coffee'] = { ["coffee"] = 0 }, },
	-- [2] = { ['nekolatte'] = { ["coffee"] = 0 },  },
	-- [3] = { ['bobatea'] = { ['boba'] = 1, ['milk'] = 1, }, },
	-- [4] = { ['bbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['sugar'] = 1, }, },
	-- [5] = { ['gbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	-- [6] = { ['obobatea'] = { ['boba'] = 1, ['milk'] = 1, ['orange'] = 1, }, },
	-- [7] = { ['pbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	-- [8] = { ['mocha'] = { ['milk'] = 1, ['sugar'] = 1, }, },

}

Crafting.Hob = {
	[1] = { ['pasta'] = { ['dough'] = 1, ['sugar'] = 1, ['jam'] = 1, }, },
	[2] = { ['nachos'] = { ['dough'] = 1, ['egg'] = 1,  }, },
	[3] = { ['tofu'] = { ['dough'] = 1, ['sugar'] = 1, ['milk'] = 1,}, },
	[4] = { ['pizzadough'] = { ['dough'] = 1, ['sugar'] = 2, ['milk'] = 1,}, },
}
