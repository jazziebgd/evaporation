local evaporation_technology = {
    type = "technology",
    name = "evaporation",
    icon = mod_config.mod_root .. "/graphics/technology/evaporation.png",
    icon_size = 256,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "evaporator-recipe"
        }
    },
    prerequisites =
    {
        "fluid-handling"
    },
    unit =
    {
        count = 100,
        ingredients =
        {
            {"science-pack-1", 1},
            {"science-pack-2", 1}
        },
        time = 5
    },
    upgrade = "true",
    order = "a-a"
}

data:extend{evaporation_technology}