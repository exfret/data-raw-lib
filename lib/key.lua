local node_key_separator = ": "
-- Note that edges are formatted with more than just a separator
local edge_separator = " --> "
local concat_separators = {"__", "_2_"}

local key = {}

-- Get key from type + name
-- type_or_tbl can be a table with {type = ..., name = ...} or a string for the type
-- This is used mainly for nodes, but also for other things where two strings needed to be combined as well
key.key = function(type_or_tbl, name)
    -- If just one argument was passed, view node_type as the node
    if name == nil then
        if type_or_tbl == nil then
            error("Nil node type for key")
        end
        -- We need to test for userdata in the case of API objects during control stage
        if type(type_or_tbl) ~= "table" and type(type_or_tbl) ~= "userdata" then
            log(type(type_or_tbl))
            log(type_or_tbl)
            error("Node passed for key not a table")
        end
        return key.key(type_or_tbl.type, type_or_tbl.name)
    end
    return type_or_tbl .. node_key_separator .. name
end

-- edge_type can be actual edge_type or the actual edge
-- Unlike key, this is used exclusively for edges
key.ekey = function(edge_start_or_edge, edge_stop, edge_desc)
    local edge
    if edge_stop ~= nil then
        assert(type(edge_start_or_edge) == "string")
        assert(type(edge_stop) == "string")
        assert(type(edge_desc) == "string" or edge_desc == nil)
        edge = {
            start = edge_start_or_edge,
            stop = edge_stop,
            desc = edge_desc,
        }
    else
        edge = edge_start_or_edge
    end
    return (edge.desc or "") .. "[" .. edge.start .. edge_separator .. edge.stop .. "]"
end

-- Turn a list of strings into a string
key.concat = function(key_tbl, sep_level)
    -- Sometimes, we need a second unique separator for "concatenations over concatenations"
    sep_to_use = concat_separators[sep_level or 1]

    local compound_key = ""
    for _, key in pairs(key_tbl) do
        compound_key = compound_key .. sep_to_use .. tostring(key)
    end
    
    return string.sub(compound_key, 1 + #sep_to_use, -1)
end

return key