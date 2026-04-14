local mtm = DataRawLib.mtm

local function test_mtm_insert_creates_tables_as_needed()
    local tbl = {}
    mtm.insert(tbl, {"index1", "index2", 3, "index4"})
    assert(tbl.index1.index2[3].index4 == true)
end
test_mtm_insert_creates_tables_as_needed()