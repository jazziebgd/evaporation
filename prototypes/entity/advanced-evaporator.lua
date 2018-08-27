local evaporator = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])

evaporator.name = "advanced-evaporator"
evaporator.icon = mod_config.mod_root .. "/graphics/icons/advanced-evaporator.png"
evaporator.icon_size = 128
evaporator.minable.result = "advanced-evaporator"

evaporator.selection_box = {
    {
        -1.3,
        -1.5
    },
    {
        1.4,
        1.4
    }
}

evaporator.collision_box = {
    {
        -1.2,
        -1.2
    },
    {
        1.2,
        1.2
    }
}

evaporator.crafting_categories = {
    "fluid-evaporation"
}

evaporator.crafting_speed = 0.5

evaporator.animation = {
    layers = {
        {
            width = 128,
            height = 128,
            filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/advanced-evaporator.png",
            frame_count = 64,
            line_length = 8,
            animation_speed = 1.6,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                width = 256,
                height = 256,
                filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/hr-advanced-evaporator.png",
                frame_count = 64,
                line_length = 8,
                animation_speed = 1.6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0
                },
            },
        },
        {
            draw_as_shadow = true,
            width = 128,
            height = 128,
            filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/advanced-evaporator-shadow.png",
            frame_count = 64,
            line_length = 8,
            animation_speed = 1.6,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                draw_as_shadow = true,
                width = 256,
                height = 256,
                filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/hr-advanced-evaporator-shadow.png",
                frame_count = 64,
                line_length = 8,
                animation_speed = 1.6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0
                },
            },
        }
    }
}

evaporator.working_visualisations = {
    {
        north_position = {0.0, 0.0},
        east_position = {0.0, 0.0},
        south_position = {0.0, 0.0},
        west_position = {0.0, 0.0},
        animation = {
            width = 128,
            height = 128,
            filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/advanced-evaporator-working.png",
            frame_count = 64,
            line_length = 8,
            animation_speed = 1.6,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                width = 256,
                height = 256,
                filename = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/hr-advanced-evaporator-working.png",
                frame_count = 64,
                line_length = 8,
                animation_speed = 1.6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0
                }
            }
        }
    }
}

evaporator.fluid_boxes[1].base_area = 20
evaporator.fluid_boxes[1].pipe_connections = {
    {
        position = {
            0,
            -2
        },
        type = "input"
    }
}

evaporator.fluid_boxes.off_when_no_fluid_recipe = false

evaporator.fluid_boxes[2] = nil

evaporator.working_sound = {
    apparent_volume = 1.5,
    sound = {
        filename = "__base__/sound/boiler.ogg",
        volume = 0.8
    }
}

evaporator.energy_usage = "300kW"
evaporator.energy_source = {
    emissions = 0.016000000000000001,
    type = "electric",
    usage_priority = "secondary-input"
}


data:extend{evaporator}