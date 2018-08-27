for name, fl in pairs(data.raw.fluid) do
    local evaporated_fluid = {
        type = "item",
        name = name .. "-vapor",
        icon = mod_config.mod_root .. "/graphics/icons/evaporation.png",
        icon_size = 32,
        stack_size = 100,
        flags = {
            "goes-to-main-inventory"
        },
        subgroup = "evaporation-vapors",
        order = "z-a",
    }
    data:extend{evaporated_fluid}
end