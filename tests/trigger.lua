local trigger = DataRawLib.trigger

local function test_flattening_with_example()
    local example_fire = data.raw.fire["medium-acid-splash-fire-stomper"]
    local structs = {}
    trigger.flatten_structs_item(example_fire.on_damage_tick_effect, structs, "on_damage_tick_effect")

    local num_trigger_effects = 0
    for _, struct in pairs(structs) do
        if struct.type == "TriggerEffect" then
            num_trigger_effects = 1 + num_trigger_effects
        end
    end
    -- Manually counting shows the number of trigger effects in data.raw for this prototype/property is 2
    assert(num_trigger_effects == 2)

    local create_sticker_addr = "on_damage_tick_effect/action_delivery/target_effects/1"
    -- Assert there is a thing of this correct address
    assert(structs[create_sticker_addr] ~= nil)
    -- Assert there is not a thing of this incorrect address
    assert(structs["on_damage_tick_effect/action_delivery/1"] == nil)

    local filtered_structs = trigger.create_filters(structs)
    assert(next(filtered_structs.creates_tile) == nil)
    assert(filtered_structs.creates_entity[create_sticker_addr] ~= nil)
    assert(filtered_structs.creates_entity[create_sticker_addr].entity == "medium-acid-sticker-stomper")
end
test_flattening_with_example()

-- TODO: Test for format of tables once I make function to gather all for each prototype