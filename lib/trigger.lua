-- TODO: Indirect relationships, such as making a projectile that does something else
-- Especially pay attention to chain effects and the like

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

    -- This applies to create-fire and create-entity trigger effects
    if tbl.find_non_colliding_position then
        -- Only loaded if find_non_colliding_position is set to true
        -- This one is really a stretch when it comes to logical functionality, but it may be useful to someone in the future for non-dependency graph needs
        flatten_structs_item(tablize(tbl.non_colliding_fail_result), structs, address .. "/non_colliding_fail_result")
    end
    -- For nested-result
    flatten_structs_item(tablize(tbl.action), structs, address .. "/action")
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

return trigger