local traversal = {}

traversal.base_prots = function(base_class)
    local base_prots = {}
    for class, _ in pairs(defines.prototypes[base_class]) do
        for _, prot in pairs(traversal.prots(class)) do
            base_prots[prot.name] = prot
        end
    end
    return base_prots
end

traversal.find_prot = function(base_class, name)
    for class, _ in pairs(defines.prototypes[base_class]) do
        local prot = traversal.prots(class)[name]
        if prot ~= nil then
            return prot
        end
    end
    error(name .. " is not a prototype of type " .. base_class)
end

traversal.prots = function(class)
    return data.raw[class] or {}
end

-- Useful for when a table property could be nil
traversal.tablize = function(obj)
    if obj == nil then
        return {}
    elseif type(obj) ~= "table" then
        return { obj }
    else
        return obj
    end
end

-- If tbl already appears to be a list (having numeric key 1), then return it
-- Otherwise, return { tbl }
-- Useful for things like Triggers within TriggerItems, which can be present as a list of triggers or a single trigger
traversal.listify = function(tbl)
    if type(tbl) ~= "table" then
        error("Cannot listify non-table value.")
    end
    -- The second condition is to check for empty tables (i.e.- length zero lists)
    if tbl[1] ~= nil or next(tbl) == nil then
        return tbl
    end
    return { tbl }
end

return traversal