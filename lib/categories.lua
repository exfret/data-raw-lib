local categories = {}

categories.corpses = {
    ["character-corpse"] = true,
    ["corpse"] = true,
    ["rail-remnants"] = true,
}

-- Entity classes to keys for the properties determining how their input energy is provided
categories.energy_sources_input = {
    ["agricultural-tower"] = "energy_source",
    ["ammo-turret"] = "energy_source",
    ["arithmetic-combinator"] = "energy_source",
    ["assembling-machine"] = "energy_source",
    ["asteroid-collector"] = "energy_source",
    beacon = "energy_source",
    boiler = "energy_source",
    ["burner-generator"] = "burner", -- Has burner energy source key
    car = "energy_source",
    ["decider-combinator"] = "energy_source",
    ["electric-turret"] = "energy_source",
    furnace = "energy_source",
    ["fusion-reactor"] = {"burner", "energy_source"}, -- Has two operability energy sources
    inserter = "energy_source",
    lab = "energy_source",
    lamp = "energy_source",
    loader = "energy_source",
    ["loader-1x1"] = "energy_source",
    locomotive = "energy_source",
    ["mining-drill"] = "energy_source",
    ["offshore-pump"] = "energy_source",
    ["programmable-speaker"] = "energy_source",
    pump = "energy_source",
    radar = "energy_source",
    reactor = "energy_source",
    roboport = "energy_source",
    ["rocket-silo"] = "energy_source",
    ["selector-combinator"] = "energy_source",
    ["spider-vehicle"] = "energy_source"
}

-- Note: Doesn't include thruster; that requires two fluids and so is treated specially
categories.fluid_required = {
    ["boiler"] = true,
    ["fusion-generator"] = true,
    ["fusion-reactor"] = true,
    ["generator"] = true,
    ["fluid-turret"] = true,
}

-- Artillery projectile doesn't inherit from projectile, but basically acts the same
categories.projectiles = {
    ["artillery-projectile"] = true,
    ["projectile"] = true,
}

categories.rail = {
    ["curved-rail-a"] = true,
    ["elevated-curved-rail-a"] = true,
    ["curved-rail-b"] = true,
    ["elevated-curved-rail-b"] = true,
    ["half-diagonal-rail"] = true,
    ["elevated-half-diagonal-rail"] = true,
    ["legacy-curved-rail"] = true,
    ["legacy-straight-rail"] = true,
    ["rail-ramp"] = true,
    ["straight-rail"] = true,
    ["elevated-straight-rail"] = true,
}

categories.rolling_stock = {
    ["artillery-wagon"] = true,
    ["cargo-wagon"] = true,
    ["infinity-cargo-wagon"] = true,
    ["fluid-wagon"] = true,
    ["locomotive"] = true,
}

categories.triggers = {
    ["chain-active-trigger"] = true,
    ["delayed-active-trigger"] = true,
}

categories.turrets = {
    ["ammo-turret"] = true,
    ["electric-turret"] = true,
    ["fluid-turret"] = true,
    ["turret"] = true,
    -- Excludes artillery turret and artillery wagon
}

categories.units = {
    ["segmented-unit"] = true,
    ["spider-unit"] = true,
    ["unit"] = true,
}

-- It's easier to write down which entities don't have health
categories.without_health = {
    ["arrow"] = true,
    ["artillery-flare"] = true,
    ["artillery-projectile"] = true,
    ["beam"] = true,
    ["character-corpse"] = true,
    ["cliff"] = true,
    ["corpse"] = true,
    ["rail-remnants"] = true,
    ["deconstructible-tile-proxy"] = true,
    ["entity-ghost"] = true,
    ["explosion"] = true,
    ["fire"] = true,
    ["stream"] = true,
    ["highlight-box"] = true,
    ["item-entity"] = true,
    ["item-request-proxy"] = true,
    ["lightning"] = true,
    ["particle-source"] = true,
    ["projectile"] = true,
    ["resource"] = true,
    ["rocket-silo-rocket"] = true,
    ["rocket-silo-rocket-shadow"] = true,
    ["smoke-with-trigger"] = true,
    ["speech-bubble"] = true,
    ["sticker"] = true,
    ["tile-ghost"] = true,
}

return categories