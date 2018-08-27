local evaporator = {
    name = "advanced-evaporator",
    type = "item",
    icon = mod_config.mod_root .. "/graphics/icons/advanced-evaporator.png",
    icon_size = 256,
    flags = {
        "goes-to-quickbar"
    },
    order = "b-b",
    place_result = "advanced-evaporator",
    stack_size = 50,
    subgroup = "evaporation-evaporators",
}

data:extend{evaporator}