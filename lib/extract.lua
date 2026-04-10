-- Gets specific information from prototypes where it may be scattered across the prototype
-- For example, ammo_categories is within the attack_parameters table, which may not exist, and could be defined on ammo_categories or on ammo_category
-- In the example, this file provides a function to simplify the process by returning the categories for a given prototype directly

local traversal = require("lib.traversal")

local tablize = traversal.tablize

local extract = {}

-- Gets ammo categories that a prototype can use
-- Format:
--   ammo_category_name --> true | nil
-- Assumes a prototype that can support ammo in the first place is passed
extract.ammo_categories = function(prototype)
    -- AttackParameters is the only place accepted ammo categories can be defined
    -- The other places are either for the ammo category of the ammo itself or how a modifier etc. acts according to the ammo
    local attack_parameters = prototype.attack_parameters
    if attack_parameters == nil then
        return {}
    end

    local cats = {}
    for _, cat in pairs(attack_parameters.ammo_categories or tablize(attack_parameters.ammo_category)) do
        cats[cat] = true
    end

    return cats
end

-- Gets the action of the attack_parameters for this prototype, where the damage is stored, if there is any
extract.attack_action = function(tbl, flags)
    flags = flags or {}

    local key_to_check = "attack_parameters"
    if flags.revenge then
        key_to_check = "revenge_attack_parameters"
    end
    local attack_parameters = tbl[key_to_check]
    if attack_parameters == nil then
        return nil
    end
    local ammo_type = attack_parameters.ammo_type
    if ammo_type == nil then
        return nil
    end
    return ammo_type.action
end

return extract