local mtm = {}

-- Access tbl[rel[1]][rel[2]]...[rel[#rel]]
mtm.access = function(tbl, rel, extra, ind)
    extra = extra or {}
    local mode = extra.mode or "read"
    local val = extra.val or true
    local safe = extra.safe or true
    
    ind = ind or 1
    assert(type(tbl) == "table")
    assert(type(rel) == "table")
    assert(type(ind) == "number")
    assert(mode == "read" or mode == "write" or mode == "append")

    if ind == #rel then
        if mode == "write" then
            tbl[rel[ind]] = val
        elseif mode == "append" then
            tbl[rel[ind]] = tbl[rel[ind]] or {}
            table.insert(tbl[rel[ind]], val)
        end
        return tbl[rel[ind]]
    end

    if safe then
        tbl[rel[ind]] = tbl[rel[ind]] or {}
    end
    mtm.access(tbl[rel[ind]], rel, extra, ind + 1)
end

mtm.append = function(tbl, rel, val)
    assert(val ~= nil)
    return mtm.access(tbl, rel, { mode = "append", val = val })
end

mtm.insert = function(tbl, rel, val)
    return mtm.access(tbl, rel, { mode = "write", val = val })
end

mtm.read = function(tbl, rel)
    return mtm.access(tbl, rel, { safe = false })
end

return mtm