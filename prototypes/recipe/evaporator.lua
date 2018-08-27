local evaporator_recipe = {
    type = "recipe",
    name = "evaporator-recipe",
    icon = mod_config.mod_root .. "/graphics/icons/evaporator.png",
    icon_size = 256,
    enabled = false,
    ingredients =
    {
        {type="item", name="iron-plate", amount=5},
        {type="item", name="copper-plate", amount=5},
        {type="item", name="electronic-circuit", amount=10},
        {type="item", name="engine-unit", amount=10},
    },
    result = "evaporator",
    order = "a-b",
}

data:extend{evaporator_recipe}