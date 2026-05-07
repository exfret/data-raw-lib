local room = DataRawLib.room

local function test_stone_furnaces_not_in_space()
    assert(not room.check_conditions(data.raw.surface["space-platform"], data.raw.furnace["stone-furnace"].surface_conditions))
end
test_stone_furnaces_not_in_space()

local function test_electric_furnaces_in_space()
    assert(room.check_conditions(data.raw.surface["space-platform"], data.raw.furnace["electric-furnace"].surface_conditions))
end
test_electric_furnaces_in_space()