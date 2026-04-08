-- TODO: In DepGraphLib, make sure to add a new node type for triggers

local traversal = require("lib.traversal")

local tablize = traversal.tablize
local listify = traversal.listify

local trigger = {}

trigger.flatten_structs_effect = function(tbl, structs, address)
    if tbl.type == nil then
        structs[address] = {
            type = "TriggerEffectList",
            tbl = tbl,
            address = address,
        }

        for ind, elt in pairs(listify(tbl)) do
            trigger.flatten_structs_effect(elt, structs, address .. "/" .. tostring(ind))
        end
        return
    end

    structs[address] = {
        type = "TriggerEffect",
        tbl = tbl,
        address = address,
    }

    -- This applies to create-fire and create-entity trigger effects
    if tbl.find_non_colliding_position ~= nil then
        -- Only loaded if find_non_colliding_position is set to true
        -- This one is really a stretch when it comes to logical functionality, but it may be useful to someone in the future for non-dependency graph needs
        trigger.flatten_structs_item(tablize(tbl.non_colliding_fail_result), structs, address .. "/non_colliding_fail_result")
    end
    -- For nested-result
    trigger.flatten_structs_item(tablize(tbl.action), structs, address .. "/action")
end

trigger.flatten_structs_delivery = function(tbl, structs, address)
    if tbl.type == nil then
        structs[address] = {
            type = "TriggerDeliveryList",
            tbl = tbl,
            address = address,
        }

        for ind, elt in pairs(listify(tbl)) do
            trigger.flatten_structs_delivery(elt, structs, address .. "/" .. tostring(ind))
        end
        return
    end

    structs[address] = {
        type = "TriggerDelivery",
        tbl = tbl,
        address = address,
    }

    trigger.flatten_structs_effect(tablize(tbl.source_effects), structs, address .. "/source_effects")
    trigger.flatten_structs_effect(tablize(tbl.target_effects), structs, address .. "/target_effects")
end

trigger.flatten_structs_item = function(tbl, structs, address)
    if tbl.type == nil then
        structs[address] = {
            type = "TriggerItemList",
            tbl = tbl,
            address = address,
        }

        for ind, elt in pairs(listify(tbl)) do
            trigger.flatten_structs_item(elt, structs, address .. "/" .. tostring(ind))
        end
        return
    end

    structs[address] = {
        type = "TriggerItem",
        tbl = tbl,
        address = address,
    }

    trigger.flatten_structs_delivery(tablize(tbl.action_delivery), structs, address .. "/action_delivery")

    -- From LineTriggerItem
    trigger.flatten_structs_effect(tablize(tbl.range_effects), structs, address .. "/range_effects")
end

-- Takes a table of trigger structs and finds addresses for notable things, such as structs corresponding to entity creation
-- Takes address --> filter info
trigger.create_filters = function(structs)
    local active_triggers = {}
    local creates_asteroid_chunk = {}
    local creates_entity = {}
    local creates_item = {}
    local creates_tile = {}
    local damage = {}

    for address, struct in pairs(structs) do
        local tbl = struct.tbl
        if struct.type == "TriggerDelivery" then
            if tbl.projectile ~= nil then
                creates_entity[address] = {
                    struct = struct,
                    entity = tbl.projectile,
                }
            end
            if tbl.beam ~= nil then
                creates_entity[address] = {
                    struct = struct,
                    entity = tbl.beam,
                }
            end
            if tbl.stream ~= nil then
                creates_entity[address] = {
                    struct = struct,
                    entity = tbl.stream,
                }
            end
            if tbl.chain ~= nil then
                active_triggers[address] = {
                    struct = struct,
                    trigger = tbl.chain,
                }
            end
            if tbl.delayed ~= nil then
                active_triggers[address] = {
                    struct = struct,
                    trigger = tbl.delayed,
                }
            end
        elseif struct.type == "TriggerEffect" then
            -- We can't test for just damage as a key since we don't really care about damage done to tiles
            -- In the future, we could also test filters to make sure the damage can be done to a specific entity, but it's not that important
            if tbl.type == "damage" then
                damage[address] = {
                    struct = struct,
                    damage = struct.damage,
                }
            end
            local create_entity_types = {
                ["create-entity"] = true,
                ["create-explosion"] = true,
                ["create-fire"] = true,
                ["create-smoke"] = true,
                -- Trivial smoke is not an entity
                -- Asteroid chunks are not an entity
                -- Particles are not entities
                -- create-sticker doesn't inherit from create-entity
                -- Decoratives aren't entities
            }
            if create_entity_types[tbl.type] then
                creates_entity[address] = {
                    struct = struct,
                    entity = tbl.entity_name,
                }
            end
            if tbl.type == "create-asteroid-chunk" then
                creates_asteroid_chunk[address] = {
                    struct = struct,
                    chunk = tbl.asteroid_name,
                }
            end
            if tbl.type == "create-sticker" then
                creates_entity[address] = {
                    struct = struct,
                    entity = tbl.sticker,
                }
            end
            if tbl.type == "destroy-cliffs" then
                if tbl.explosion_at_trigger ~= nil then
                    creates_entity[address] = {
                        struct = struct,
                        entity = tbl.explosion_at_trigger,
                    }
                end
                if tbl.explosion_at_cliff ~= nil then
                    creates_entity[address] = {
                        struct = struct,
                        entity = tbl.explosion_at_cliff,
                    }
                end
            end
            if tbl.type == "insert-item" then
                creates_item[address] = {
                    struct = struct,
                    item = tbl.item,
                }
            end
            if tbl.type == "set-tile" then
                creates_tile[address] = {
                    struct = struct,
                    tile = tbl.tile_name,
                }
            end
            -- Technically, we could have an edge showing tile trigger is invoked, but I think that usually doesn't do much beyond visuals
            -- Same for activate-impact trigger
        end
    end

    return {
        active_triggers = active_triggers,
        creates_asteroid_chunk = creates_asteroid_chunk,
        creates_entity = creates_entity,
        creates_item = creates_item,
        creates_tile = creates_tile,
        damage = damage,
    }
end

return trigger