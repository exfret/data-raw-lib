local cat_sigs = DataRawLib.cat_sigs

local function test_fcat_furnace_burnt_indicator_zero()
    local furnace = data.raw.furnace["stone-furnace"]
    local energy_source = furnace.energy_source
    for _, fuel_category in pairs(energy_source.fuel_categories or {"chemical"}) do
        assert(string.sub(assert(cat_sigs.fcat_name(fuel_category, energy_source.burnt_inventory_size)), -1, -1) == "0")
    end
end
test_fcat_furnace_burnt_indicator_zero()

local function test_fcat_reactor_burnt_indicator_one()
    local reactor = data.raw.reactor["nuclear-reactor"]
    local energy_source = reactor.energy_source
    -- Reactor should not have chemical energy source
    for _, fuel_category in pairs(energy_source.fuel_categories) do
        assert(string.sub(assert(cat_sigs.fcat_name(fuel_category, energy_source.burnt_inventory_size)), -1, -1) == "1")
    end
end
test_fcat_reactor_burnt_indicator_one()