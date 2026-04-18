local categories = {}

categories.corpses = {
    ["character-corpse"] = true,
    ["corpse"] = true,
    ["rail-remnants"] = true,
}

-- Artillery projectile doesn't inherit from projectile, but basically acts the same
categories.projectiles = {
    ["artillery-projectile"] = true,
    ["projectile"] = true,
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

return categories