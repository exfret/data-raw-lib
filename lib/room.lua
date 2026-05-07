local traversal = require("lib.traversal")
local base_prots = traversal.base_prots
local tablize = traversal.tablize

local room = {}

room.check_conditions = function(room_prot, conditions)
    if conditions == nil then
        return true
    end

    for _, condition in pairs(conditions) do
        local surface_val = data.raw["surface-property"][condition.property].default_value

        if room_prot.surface_properties ~= nil then
            if room_prot.surface_properties[condition.property] ~= nil then
                surface_val = room_prot.surface_properties[condition.property]
            end
        end

        local satisfies_condition = true
        if condition.min ~= nil and condition.min > surface_val then
            return false
        end
        if condition.max ~= nil and condition.max < surface_val then
            return false
        end
    end

    return true
end

return room