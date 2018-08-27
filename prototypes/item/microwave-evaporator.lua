local microwave_evaporator = {
    name = "microwave-evaporator",
    type = "selection-tool",
    icon = mod_config.mod_root .. "/graphics/item/microwave-evaporator.png",
    icon_size = 256,
    flags = {
        "goes-to-quickbar"
    },
    order = "a-a",
    stack_size = 1,
    stackable = false,
    subgroup = "evaporation-items",
    selection_color = mod_config.mod_base_color,
    alt_selection_color = mod_config.mod_base_color,
    selection_mode = {"matches-force"},
    alt_selection_mode = {"matches-force"},
    selection_cursor_box_type = "not-allowed",
    alt_selection_cursor_box_type = "not-allowed"
}

data:extend{microwave_evaporator}