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

return cat_sigs