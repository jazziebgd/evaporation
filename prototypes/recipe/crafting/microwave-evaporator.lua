local microwave_evaporator_recipe = {
    type = "recipe",
    name = "microwave-evaporator-recipe",
    category = "crafting",
    enabled = false,
    energy_required = 5,
    ingredients =
    {
        {type="item", name="iron-plate", amount=5},
        {type="item", name="copper-plate", amount=5},
        {type="item", name="plastic-bar", amount=5},
        {type="item", name="copper-cable", amount=20},
        {type="item", name="battery", amount=50},
        {type="item", name="advanced-circuit", amount=50},
    },
    results=
    {
        {type="item", name="faucet-microwave-evaporator", amount=1},
    },
}
data:extend{microwave_evaporator_recipe}