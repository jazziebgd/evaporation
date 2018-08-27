local evaporator_recipe = {
    type = "recipe",
    name = "advanced-evaporator-recipe",
    icon = mod_config.mod_root .. "/graphics/icons/advanced-evaporator.png",
    icon_size = 256,
    enabled = false,
    ingredients =
    {
        {type="item", name="iron-plate", amount=100},
        {type="item", name="copper-plate", amount=100},
        {type="item", name="plastic-bar", amount=50},
        {type="item", name="copper-cable", amount=200},
        {type="item", name="advanced-circuit", amount=100},
        {type="item", name="electric-engine-unit", amount=10},
    },
    result = "advanced-evaporator",
    order = "a-c",
}

data:extend{evaporator_recipe}