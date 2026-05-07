local map_gen = {}

-- Gets all prototypes of a type that appear on a planet via autoplace, or checks if a single prototype is there
-- If to_check is "tile" or "entity", returns a table of all matching prototypes in the room
-- If to_check is a prototype table, returns true/false for whether it appears in the room
-- For entities, doesn't check for the existence of a tile where the entity can actually be placed
map_gen.check_on_planet = function(planet_name, to_check)
    local base_prots = DataRawLib.traversal.base_prots
    local find_prot = DataRawLib.traversal.find_prot
    local prots = DataRawLib.traversal.prots

    local planet = data.raw.planet[planet_name]

    local control_to_prots
    local check_type
    local get_all
    if to_check == "tile" or to_check == "entity" then
        -- First, do a mini lookup of tile/entity to control if we're getting all prots
        control_to_prots = {}
        for _, control in pairs(prots("autoplace-control")) do
            control_to_prots[control.name] = {}
        end
        for _, prot in pairs(base_prots(to_check)) do
            local autoplace = prot.autoplace
            if autoplace ~= nil then
                local control_name = autoplace.control
                if control_name ~= nil then
                    control_to_prots[control_name][prot.name] = true
                end
            end
        end
        get_all = true
        check_type = to_check
    else
        assert(type(to_check) == "table")
        get_all = false
        check_type = to_check.type
    end

    local matches = {}
    
    local map_gen_settings = planet.map_gen_settings
    if map_gen_settings ~= nil then
        local autoplace_settings = map_gen_settings.autoplace_settings[check_type]
        if autoplace_settings ~= nil and autoplace_settings.settings ~= nil then
            if get_all then
                for prot_name, _ in pairs(autoplace_settings.settings) do
                    local prot = find_prot(check_type, prot_name)
                    if autoplace_settings.treat_missing_as_default or prot.autoplace ~= nil then
                        matches[prot_name] = true
                    end
                end
            else
                if autoplace_settings.settings[to_check.name] ~= nil and (autoplace_settings.treat_missing_as_default or prot.autoplace ~= nil) then
                    return true
                end
            end
        end

        local autoplace_controls = map_gen_settings.autoplace_controls
        if autoplace_controls ~= nil then
            for control_name, _ in pairs(autoplace_controls) do
                if get_all then
                    for prot_name, _ in pairs(control_to_prots[control_name]) do
                        matches[prot_name] = true
                    end
                else
                    if to_check.autoplace ~= nil and to_check.autoplace.control == control_name then
                        return true
                    end
                end
            end
        end
    end

    if get_all then
        return matches
    else
        return false
    end
end

return map_gen