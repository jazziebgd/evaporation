local graphic_root = mod_config.mod_root .. "/graphics/entity/evaporator/"

local function get_evaporator_anim(direction)
    local small_size = 64
    local small_scale = 1
    local large_size = 128
    local large_scale = 0.5

    local frame_count = 64
    local line_length = 8
    local animation_speed = 1.6

    local body_filename = graphic_root .. direction .. "-body.png"
    local hr_body_filename = graphic_root .. "hr-" .. direction .. "-body.png"

    local shadow_filename = graphic_root .. direction .. "-shadow.png"
    local hr_shadow_filename = graphic_root .. "hr-" .. direction .. "-shadow.png"

    local animation_shifts = {
        east = util.by_pixel(14.08, 4.16),
        north = util.by_pixel(6.08, -2.88),
        south = util.by_pixel(6.08, 4.16),
        west = util.by_pixel(-4.16, 4.16)
    }

    local anim = {
        layers = {
            {
                width = small_size,
                height = small_size,
                scale = small_scale,
                frame_count = frame_count,
                line_length = line_length,
                animation_speed = animation_speed,
                filename = body_filename,
                shift = animation_shifts[direction],
                hr_version = {
                    width = large_size,
                    height = large_size,
                    scale = large_scale,
                    frame_count = frame_count,
                    line_length = line_length,
                    animation_speed = animation_speed,
                    filename = hr_body_filename,
                    shift = animation_shifts[direction],
                },
            },
            {
                draw_as_shadow = true,
                width = small_size,
                height = small_size,
                scale = small_scale,
                frame_count = frame_count,
                line_length = line_length,
                animation_speed = animation_speed,
                filename = shadow_filename,
                shift = animation_shifts[direction],
                hr_version = {
                    draw_as_shadow = true,
                    width = large_size,
                    height = large_size,
                    scale = large_scale,
                    frame_count = frame_count,
                    line_length = line_length,
                    animation_speed = animation_speed,
                    filename = hr_shadow_filename,
                    shift = animation_shifts[direction],
                },
            }
        }
    }
    return anim
end



local evaporator = table.deepcopy(data.raw.pump.pump)

evaporator.name = "faucet-evaporator"
evaporator.icon = mod_config.mod_root .. "/graphics/icons/evaporator.png"
evaporator.icon_size = 256
evaporator.order = "a"
evaporator.minable.result = "faucet-evaporator"

evaporator.animations = {}
local directions = {"east", "north", "south", "west"}
for _, direction in pairs(directions) do
    evaporator.animations[direction] = get_evaporator_anim(direction)
end

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


evaporator.fluid_animation = nil


evaporator.fluid_box.pipe_covers.north.layers[1].filename = mod_config.mod_root .. "/graphics/entity/evaporator/north-cover-empty.png"
evaporator.fluid_box.pipe_covers.north.layers[1].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-north-cover-empty.png"

evaporator.fluid_box.pipe_covers.north.layers[2].filename = mod_config.mod_root .. "/graphics/entity/evaporator/north-cover-empty.png"
evaporator.fluid_box.pipe_covers.north.layers[2].hr_version.filename = mod_config.mod_root .. "/graphics/entity/evaporator/hr-north-cover-empty.png"

evaporator.glass_pictures = nil
evaporator.fluid_wagon_connector_frame_count = nil
evaporator.fluid_wagon_connector_graphics = nil


data:extend{evaporator}