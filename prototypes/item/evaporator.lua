local evaporator = {
    name = "faucet-evaporator",
    type = "item",
    icon = mod_config.mod_root .. "/graphics/icons/evaporator.png",
    icon_size = 256,
    flags = {
        "goes-to-quickbar"
    },
    order = "b-a",
    place_result = "faucet-evaporator",
    stack_size = 50,
    subgroup = "evaporation-evaporators",
}

data:extend{evaporator}