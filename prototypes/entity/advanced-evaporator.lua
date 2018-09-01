local graphics_root = mod_config.mod_root .. "/graphics/entity/advanced-evaporator/"

local evaporator = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])

evaporator.name = "faucet-advanced-evaporator"
evaporator.icon = mod_config.mod_root .. "/graphics/icons/advanced-evaporator.png"
evaporator.icon_size = 128
evaporator.minable.result = "faucet-advanced-evaporator"

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

local sprite_size = 128
local sprite_scale = 1
local hr_sprite_size = 256
local hr_sprite_scale = 0.5

local filename_base = graphics_root .. "advanced-evaporator"
local hr_filename_base = graphics_root .. "hr-advanced-evaporator"

local frame_count = 64
local line_length = 8
local animation_speed = 1.6

evaporator.animation = {
    layers = {
        {
            width = sprite_size,
            height = sprite_size,
            scale = sprite_scale,
            filename = filename_base .. ".png",
            frame_count = frame_count,
            line_length = line_length,
            animation_speed = animation_speed,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                width = hr_sprite_size,
                height = hr_sprite_size,
                filename = hr_filename_base .. ".png",
                frame_count = frame_count,
                line_length = line_length,
                animation_speed = animation_speed,
                priority = "high",
                scale = hr_sprite_scale,
                shift = {
                    0,
                    0
                },
            },
        },
        {
            draw_as_shadow = true,
            width = sprite_size,
            height = sprite_size,
            scale = sprite_scale,
            filename = filename_base .. "-shadow.png",
            frame_count = frame_count,
            line_length = line_length,
            animation_speed = animation_speed,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                draw_as_shadow = true,
                width = hr_sprite_size,
                height = hr_sprite_size,
                filename = hr_filename_base .. "-shadow.png",
                frame_count = frame_count,
                line_length = line_length,
                animation_speed = animation_speed,
                priority = "high",
                scale = hr_sprite_scale,
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
            width = sprite_size,
            height = sprite_size,
            scale = sprite_scale,
            filename = filename_base .. "-working.png",
            frame_count = frame_count,
            line_length = line_length,
            animation_speed = animation_speed,
            priority = "high",
            shift = {
                0,
                0
            },
            hr_version = {
                width = hr_sprite_size,
                height = hr_sprite_size,
                filename = hr_filename_base .. "-working.png",
                frame_count = frame_count,
                line_length = line_length,
                animation_speed = animation_speed,
                priority = "high",
                scale = hr_sprite_scale,
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