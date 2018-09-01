mod_config = {
    mod_root = "__faucet__",
    mod_base_color = {r = 0.165, g = 0.373, b = 0.792, a = 1},
    mod_highlight_color = {r = 0.99, g = 0.505, b = 0.105, a = 1},
    mod_light_color = {r = 0.819, g = 0.635, b = 0.376, a = 1},
    debug_active = false,
    log_to_file = false,
    debug_level = 3,

    all_evaporator_entity_names = {
        "faucet-evaporator",
        "faucet-advanced-evaporator"
    },

    evaporator_entity_names = {
        "faucet-evaporator",
    },

    advanced_evaporator_entity_names = {
        "faucet-advanced-evaporator",
    },

    microwave_evaporator_entity_names = {
        "faucet-microwave-evaporator",
    },

    mod_settings = {
        {
            type = "bool-setting",
            name = "faucet-show-gui",
            setting_type = "startup",
            default_value = true,
            order = "a-a"
        },
        {
            type = "bool-setting",
            name = "faucet-show-cleaning-result",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "b-a"
        },
        {
            type = "bool-setting",
            name = "faucet-clean-pipes",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "b-b"
        },
        {
            type = "bool-setting",
            name = "faucet-clean-pumps",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "b-c"
        },
        {
            type = "bool-setting",
            name = "faucet-clean-tanks",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "b-d"
        }
    },


    mod_gui_settings = {
        show_details = {
            name = "show_details",
            control = "hidden",
            group = "main",
            sprite = nil,
            debug_only = false,
            is_info_column = false,
            default_value = false,
            item_values = {}
        },
        show_settings = {
            name = "show_settings",
            control = "hidden",
            group = "main",
            sprite = nil,
            debug_only = false,
            is_info_column = false,
            default_value = false,
            item_values = {}
        },
        show_inactive = {
            name = "show_inactive",
            control = "checkbox",
            group = "main",
            sprite = nil,
            debug_only = false,
            is_info_column = false,
            default_value = true,
            item_values = {}
        },
        show_evaporated = {
            name = "show_evaporated",
            control = "checkbox",
            group = "columns",
            sprite = "faucet_evaporation_sprite",
            debug_only = false,
            is_info_column = true,
            default_value = true,
            item_values = {}
        },
        show_evaporated_per_second = {
            name = "show_evaporated_per_second",
            control = "checkbox",
            group = "columns",
            sprite = "faucet_evaporation_per_second_sprite",
            debug_only = false,
            is_info_column = true,
            default_value = true,
            item_values = {}
        },
        show_pollution = {
            name = "show_pollution",
            control = "checkbox",
            group = "columns",
            sprite = "faucet_pollution_sprite",
            debug_only = false,
            is_info_column = true,
            default_value = true,
            item_values = {}
        },
        show_pollution_per_second = {
            name = "show_pollution_per_second",
            control = "checkbox",
            group = "columns",
            sprite = "faucet_pollution_per_second_sprite",
            debug_only = false,
            is_info_column = true,
            default_value = true,
            item_values = {}
        },
        debug_level = {
            name = "debug_level",
            control = "dropdown",
            group = "debug",
            sprite = nil,
            debug_only = true,
            is_info_column = false,
            default_value = 3,
            item_values = {{"faucet-info-setting-debug_level_verbose"}, {"faucet-info-setting-debug_level_debug"}, {"faucet-info-setting-debug_level_info"}}
        },
        log_to_file = {
            name = "log_to_file",
            control = "checkbox",
            group = "debug",
            sprite = nil,
            debug_only = true,
            is_info_column = false,
            default_value = false,
            item_values = {}
        },
        show_horizontal_table_borders = {
            name = "show_horizontal_table_borders",
            control = "checkbox",
            group = "debug",
            sprite = nil,
            debug_only = true,
            is_info_column = false,
            default_value = false,
            item_values = {}
        },
        show_vertical_table_borders = {
            name = "show_vertical_table_borders",
            control = "checkbox",
            group = "debug",
            sprite = nil,
            debug_only = true,
            is_info_column = false,
            default_value = false,
            item_values = {}
        },
    },


    default_column_name = "show_evaporated",

    pollution_per_tick = {
        _default = 1,
        ["petroleum-gas"] = 0.5,
        water = 0,
        steam = 0,
    },

    dev_player_names = {
        "jazziebgd",
    },
}

function get_mod_config()
    return mod_config
end

function get_mod_config_var(name)
    if mod_config[name] then
        return mod_config[name]
    else
        log_info("Config var " .. name .. " not found")
        return nil
    end
end