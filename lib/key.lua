local node_key_separator = ": "
local concat_separators = {"__", "_2_"}
-- Note that edges are formatted with more than just a separator
local edge_separator = " --> "

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
key.ekey = function(edge_type_or_edge, edge_start, edge_stop)
    local edge
    if edge_start ~= nil then
        assert(type(edge_type_or_edge) == "string")
        assert(type(edge_start) == "string")
        assert(type(edge_stop) == "string")
        edge = {
            type = edge_type_or_edge,
            start = edge_start,
            stop = edge_stop,
        }
    else
        edge = edge_type_or_edge
    end
    return edge.type .. "[" .. edge.start .. edge_separator .. edge.stop .. "]"
end

return key