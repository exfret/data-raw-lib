-- Gets specific information from prototypes where it may be scattered across the prototype
-- For example, ammo_categories is within the attack_parameters table, which may not exist, and could be defined on ammo_categories or on ammo_category
-- In the example, this file provides a function to simplify the process by returning the categories for a given prototype directly

local traversal = require("lib.traversal")

local tablize = traversal.tablize

local extract = {}

-- Gets ammo categories that a prototype can use
-- Format:
--   ammo_category_name --> true or nil
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

return extract