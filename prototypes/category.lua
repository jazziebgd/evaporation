data:extend(
{
    {
        type = "item-group",
        name = "evaporation",
        order = "a-a",
        inventory_order = "a-a",
        icon = mod_config.mod_root .. "/graphics/technology/evaporation.png",
        icon_size = 256,
    },
    {
        type = "item-subgroup",
        name = "evaporation-items",
        group = "evaporation",
        order = "a-a",
    },

    {
        type = "item-subgroup",
        name = "evaporation-evaporators",
        group = "evaporation",
        order = "b-a",
    },
    {
        type = "item-subgroup",
        name = "evaporation-vapors",
        group = "evaporation",
        order = "c-a",
    }
}
)