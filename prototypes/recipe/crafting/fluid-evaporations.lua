for name, fl in pairs(data.raw.fluid) do
    local fluid_evaporation_recipe = {
        type = "recipe",
        name = name .. "-evaporation",
        icon = fl.icon,
        icon_size = fl.icon_size,
        category = "fluid-evaporation",
        energy_required = 0.1,
        ingredients =
        {
            {type="fluid", name=name, amount=200},
        },
        results=
        {
            {type="item", name=name .. "-vapor", amount=0},
        },
        enabled = false,
        always_show_made_in = true,
        allow_decomposition = false,
        subgroup = "evaporation-vapors",
        order = "c-d",
        hidden_from_flow_stats = true,
    }

    data:extend{fluid_evaporation_recipe}
end