local node_key_separator = ": "
local concat_separators = {"__", "_2_"}
local edge_separator = " --> "

local key = {}

-- Get key from type + name
-- node_type can be a table with {type = ..., name = ...} or a string for the actual type
key.key = function(node_type, node_name)
    -- If just one argument was passed, view node_type as the node
    if node_name == nil then
        if node_type == nil then
            error("Nil node type for key")
        end
        -- We need to test for userdata in the case of API objects during control stage
        if type(node_type) ~= "table" and type(node_type) ~= "userdata" then
            log(type(node_type))
            log(node_type)
            error("Node passed for key not a table")
        end
        return key.key(node_type.type, node_type.name)
    end
    return node_type .. node_key_separator .. node_name
end

return key