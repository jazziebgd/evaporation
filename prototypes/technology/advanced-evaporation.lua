local advanced_evaporation_technology = {
    type = "technology",
    name = "advanced-evaporation",
    icon = mod_config.mod_root .. "/graphics/technology/advanced-evaporation.png",
    icon_size = 256,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "advanced-evaporator-recipe"
        },
        {
            type = "unlock-recipe",
            recipe = "microwave-evaporator-recipe"
        }
    },
    prerequisites =
    {
        "evaporation"
    },
    unit =
    {
        count = 200,
        ingredients =
        {
            {"science-pack-1", 2},
            {"science-pack-2", 2},
            {"science-pack-3", 1}
        },
        time = 10
    },
    upgrade = "true",
    order = "a-b"
}

data:extend{advanced_evaporation_technology}