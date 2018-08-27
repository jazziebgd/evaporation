local evaporator = table.deepcopy(data.raw.pump.pump)

evaporator.name = "evaporator"
evaporator.icon = mod_config.mod_root .. "/graphics/icons/evaporator.png"
evaporator.icon_size = 256
evaporator.order = "a"


evaporator.minable.result = "evaporator"

evaporator.fluid_box.height = 1
evaporator.fluid_box.pipe_connections = {
    {
        position = {
            0,
            0.85
        },
        type = "input"
    }
}

evaporator.selection_box = {
    {
        -0.5,
        -0.5
    },
    {
        0.5,
        0.5
    }
}
evaporator.collision_box = {
    {
        -0.29,
        -0.395
    },
    {
        0.29,
        0.395
    }
}

evaporator.energy_source = {
    emissions = 0.004,
    type = "electric",
    usage_priority = "secondary-input"
}
evaporator.energy_usage = "50kW"

local function get_evaporator_anim(direction)
    local small_size = 64
    local small_scale = 1
    local large_size = 128
    local large_scale = 0.5
    local animation_speed = 1.6
    local anim = {
        layers = {
            {
                width = small_size,
                height = small_size,
                scale = small_scale,
                frame_count = 64,
                line_length = 8,
                animation_speed = animation_speed,
                shift = {
                    0,
                    0
                },
                hr_version = {
                    width = large_size,
                    height = large_size,
                    scale = large_scale,
                    frame_count = 64,
                    line_length = 8,
                    animation_speed = animation_speed,
                    shift = {
                        0,
                        0
                    },
                },
            },
            {
                draw_as_shadow = true,
                width = small_size,
                height = small_size,
                scale = small_scale,
                frame_count = 64,
                line_length = 8,
                animation_speed = animation_speed,
                shift = {
                    0,
                    0
                },
                hr_version = {
                    draw_as_shadow = true,
                    width = large_size,
                    height = large_size,
                    scale = large_scale,
                    frame_count = 64,
                    line_length = 8,
                    animation_speed = animation_speed,
                    shift = {
                        0,
                        0
                    },
                },
            }
        }
    }

    anim.layers[1].filename = mod_config.mod_root .. "/graphics/entity/evaporator/" .. direction .. ".png"
    anim.layers[2].filename = mod_config.mod_root .. "/graphics/entity/evaporator/" .. direction .. "-shadow.png"

    anim.layers[1].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-" .. direction .. ".png"
    anim.layers[2].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-" .. direction .. "-shadow.png"

    return anim
end

local animation_shifts = {
    east = {
        0.5,
        -0.1
    },
    north = {
        0.21,
        -0.045,
    },
    south = {
        0.2,
        0.15,
    },
    west = {
        -0.1,
        0
    }
}


evaporator.fluid_animation = nil
evaporator.animations = {}
local directions = {"east", "north", "south", "west"}
for _, direction in pairs(directions) do
    evaporator.animations[direction] = get_evaporator_anim(direction)
    evaporator.animations[direction].layers[1].shift = animation_shifts[direction]
    evaporator.animations[direction].layers[2].shift = animation_shifts[direction]
end

evaporator.fluid_box.pipe_covers.north.layers[1].filename = mod_config.mod_root .. "/graphics/entity/evaporator/north-cover-empty.png"
evaporator.fluid_box.pipe_covers.north.layers[1].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-north-cover-empty.png"

evaporator.fluid_box.pipe_covers.north.layers[2].filename = mod_config.mod_root .. "/graphics/entity/evaporator/north-cover-empty.png"
evaporator.fluid_box.pipe_covers.north.layers[2].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-north-cover-empty.png"

evaporator.glass_pictures = nil
evaporator.fluid_wagon_connector_frame_count = nil
evaporator.fluid_wagon_connector_graphics = nil


data:extend{evaporator}