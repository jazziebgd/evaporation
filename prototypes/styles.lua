data:extend(
    {
        {
            type = "font",
            name = "faucet_small_font",
            from = "default",
            border = false,
            size = 14
        },
        {
            type = "font",
            name = "faucet_small_bold_font",
            from = "default-bold",
            border = false,
            size = 14
        },
        {
            type = "font",
            name = "faucet_font",
            from = "default",
            border = false,
            size = 16
        },
        {
            type = "font",
            name = "faucet_bold_font",
            from = "default-bold",
            border = false,
            size = 16
        },
        {
            type = "font",
            name = "faucet_heading_font",
            from = "default",
            border = false,
            size = 18
        },
        {
            type = "font",
            name = "faucet_heading_bold_font",
            from = "default-bold",
            border = false,
            size = 18
        },


        {
            type = "sprite",
            name = "faucet_fluids_sprite",
            filename = mod_config.mod_root .. "/graphics/icons/fluids.png",
            width = 32,
            height = 32,
        },
        {
            type = "sprite",
            name = "faucet_pollution_sprite",
            filename = mod_config.mod_root .. "/graphics/icons/pollution.png",
            width = 32,
            height = 32,
        },
        {
            type = "sprite",
            name = "faucet_pollution_per_second_sprite",
            filename = mod_config.mod_root .. "/graphics/icons/pollution-per-second.png",
            width = 32,
            height = 32,
        },
        {
            type = "sprite",
            name = "faucet_evaporation_sprite",
            filename = mod_config.mod_root .. "/graphics/icons/evaporation.png",
            width = 32,
            height = 32,
        },
        {
            type = "sprite",
            name = "faucet_evaporation_per_second_sprite",
            filename = mod_config.mod_root .. "/graphics/icons/evaporation-per-second.png",
            width = 32,
            height = 32,
        },
        {
            type = "sprite",
            name = "faucet_spacer_500",
            filename = mod_config.mod_root .. "/graphics/gui/spacer-500.png",
            width = 500,
            height = 5,
        },
        {
            type = "sprite",
            name = "faucet_spacer_400",
            filename = mod_config.mod_root .. "/graphics/gui/spacer-400.png",
            width = 300,
            height = 5,
        },
        {
            type = "sprite",
            name = "faucet_spacer_300",
            filename = mod_config.mod_root .. "/graphics/gui/spacer-300.png",
            width = 300,
            height = 5,
        },
        {
            type = "sprite",
            name = "faucet_spacer_200",
            filename = mod_config.mod_root .. "/graphics/gui/spacer-200.png",
            width = 200,
            height = 5,
        },
        {
            type = "sprite",
            name = "faucet_spacer_100",
            filename = mod_config.mod_root .. "/graphics/gui/spacer-100.png",
            width = 100,
            height = 5,
        },
    }
)

local default_gui = data.raw["gui-style"].default

default_gui.faucet_flow_style =
{
    type="horizontal_flow_style",
    parent="horizontal_flow",
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 0,

    horizontal_spacing = 0,
    vertical_spacing = 0,
    max_on_row = 0,
    resize_row_to_width = true,

    graphical_set = { type = "none" },
    font = "faucet_font",
    vertical_align = "center",
}

default_gui.faucet_stretch_flow_style = {
    type="horizontal_flow_style",
    parent="faucet_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center"
}

default_gui.faucet_data_cell_right_flow_style =
{
    type="horizontal_flow_style",
    parent="horizontal_flow",
    align = "right",
    vertical_align = "center",
    horizontally_stretchable = "on",
}

default_gui.faucet_vertical_flow_style =
{
    type="vertical_flow_style",
    parent="vertical_flow",
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 0,

    horizontal_spacing = 0,
    vertical_spacing = 0,
    max_on_row = 0,
    horizontally_stretchable = "on",

    graphical_set = { type = "none" },
}

default_gui.faucet_info_button_style =
{
    type = "button_style",
    parent = "button",
    width = 34,
    height = 34,
    top_padding = 1,
    bottom_padding = 1,
    left_padding = 1,
    right_padding = 1,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/gui-button-info.png",
            width = 256,
            height = 256,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/gui-button-info-hover.png",
            width = 256,
            height = 256,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/gui-button-info.png",
            width = 256,
            height = 256,
        }
    },
}

default_gui.faucet_small_button_style =
{
    type = "button_style",
    parent = "button",
    width = 28,
    height = 28
}

default_gui.faucet_close_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/button-close.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/button-close-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/button-close.png",
            width = 128,
            height = 128,
        }
    }
}

default_gui.faucet_settings_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings.png",
            width = 128,
            height = 128,
        }
    }
}

default_gui.faucet_settings_inactive_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings-inactive.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings-inactive-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/settings-inactive.png",
            width = 128,
            height = 128,
        }
    }
}

default_gui.faucet_eye_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle.png",
            width = 128,
            height = 128,
        }
    }
}

default_gui.faucet_eye_inactive_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle-inactive.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle-inactive-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/eye-toggle-inactive.png",
            width = 128,
            height = 128,
        }
    }
}

default_gui.faucet_evaporator_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/evaporator.png",
            width = 64,
            height = 64,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/evaporator-hover.png",
            width = 64,
            height = 64,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/evaporator.png",
            width = 64,
            height = 64,
        }
    }
}

default_gui.faucet_advanced_evaporator_button_style =
{
    type = "button_style",
    parent = "faucet_small_button_style",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/advanced-evaporator.png",
            width = 128,
            height = 128,
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/advanced-evaporator-hover.png",
            width = 128,
            height = 128,
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = mod_config.mod_root .. "/graphics/gui/advanced-evaporator.png",
            width = 128,
            height = 128,
        }
    }
}


default_gui.faucet_frame_style =
{
    type = "frame_style",
    parent="frame",
    top_padding  = 4,
    bottom_padding = 2,
    -- width = 500,
    minimal_height = 50,
    vertically_stretchable = "on",
    vertically_squashable = "on",
}



default_gui.faucet_default_button_style =
{
    type = "button_style",
    parent = "button",
    min_width = 34,
    min_height = 34,
    top_padding = 1,
    bottom_padding = 1,
    left_padding = 1,
    right_padding = 1,
}

default_gui.faucet_filter_button_style =
{
    type = "button_style",
    parent = "button",
    width = 31,
    height = 31
}

default_gui.faucet_reset_filter_button_style =
{
    type = "button_style",
    parent = "button",
    font = "faucet_font",
    top_padding = 1,
    bottom_padding = 1,
    left_padding = 5,
    right_padding = 5,
}

default_gui.faucet_reset_settings_button_style =
{
    type = "button_style",
    parent = "button",
    top_padding = 1,
    bottom_padding = 1,
    left_padding = 5,
    right_padding = 5,
    font = "faucet_small_font",
}

default_gui.faucet_data_pane_style = {
    type = "scroll_pane_style",
    parent = "scroll_pane",
    maximal_height = 220,
    vertically_squashable = "on",
}

default_gui.faucet_data_table_style = {
    type = "table_style",
    parent = "table",
}

default_gui.faucet_label_style =
{
    type = "label_style",
    parent = "label",
    font = "faucet_font",
}


default_gui.faucet_highlight_text_style =
{
    type = "label_style",
    parent = "label",
    font = "faucet_font",
    font_color = mod_config.mod_highlight_color,
}

default_gui.faucet_heading_label_style = {
    type = "label_style",
    parent = "label",
    font = "faucet_heading_bold_font",
    font_color = mod_config.mod_light_color,
}







default_gui.faucet_composition_button_style = {
    type = "button_style",
    parent = "button",
    font = "faucet_font",
    top_padding = 0,
    left_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    -- hovered_font_color = mod_config.mod_base_color,
    clicked_font_color = mod_config.mod_base_color,
    default_graphical_set = {
        type = "composition",
        filename = mod_config.mod_root .. "/graphics/gui/round-button.png",
        position = { 0, 0 },
        corner_size = { 4, 4 }
    },
    hovered_graphical_set = {
        type = "composition",
        filename = mod_config.mod_root .. "/graphics/gui/round-button.png",
        position = { 9, 0 },
        corner_size = { 4, 4 }
    },
    clicked_graphical_set = {
        type = "composition",
        filename = mod_config.mod_root .. "/graphics/gui/round-button.png",
        position = { 18, 0 },
        corner_size = { 4, 4 }
    },
    disabled_graphical_set = {
        type = "composition",
        filename = mod_config.mod_root .. "/graphics/gui/round-button.png",
        position = { 27, 0 },
        corner_size = { 4, 4 }
    },
    left_click_sound = {{
        filename = "__core__/sound/gui-click.ogg",
        volume = 1
    }}
}