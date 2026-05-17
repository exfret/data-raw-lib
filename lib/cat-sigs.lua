-- Code to create signature names for recipe/fuel/etc. categories with extra information built in as to extra requirements that might be needed
-- For example, rcats contain a recipe category in the name, as well as the number of fluids in the input and output, since those also play a role in what can craft a recipe

local key_lib = require("lib.key")

local concat = key_lib.concat

local cat_sigs = {}

cat_sigs.fcat_name = function(fuel_category, burnt_inventory_size)
    local accepts_burnt = 0
    if burnt_inventory_size ~= nil and burnt_inventory_size > 0 then
        accepts_burnt = 1
    end
    return concat({fuel_category, tostring(accepts_burnt)})
end

-- Only used for resource entities
cat_sigs.mcat_name = function(entity)
    -- If not minable, return the empty mcat
    if entity.minable == nil then
        return ""
    end

    local input_fluids = 0
    if entity.minable.required_fluid ~= nil then
        input_fluids = 1
    end
    local output_fluids = 0
    if entity.minable.results ~= nil then
        for _, result in pairs(entity.minable.results) do
            if result.type == "fluid" then
                -- There can be at most one output fluid for a mining result
                output_fluids = 1
                break
            end
        end
    end

    return concat({entity.category or "basic-category", tostring(input_fluids), tostring(output_fluids)})
end

return cat_sigs