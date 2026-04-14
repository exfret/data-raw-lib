local mtm = {}

-- Set tbl[rel[1]][rel[2]]...[rel[#rel]] = true while ensuring all tables exist
mtm.insert = function(tbl, rel, ind)
    ind = ind or 1
    assert(type(ind) == "number")
    assert(type(tbl) == "table")
    assert(type(rel) == "table")

    if ind == #rel then
        tbl[rel[ind]] = true
        return
    end

    tbl[rel[ind]] = tbl[rel[ind]] or {}
    mtm.insert(tbl[rel[ind]], rel, ind + 1)
end

return mtm