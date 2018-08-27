local start_x = 0
local start_y = 0

local default_direction = defines.direction.east

function connect_with_fluid_filter(filter_entity, other_entity, fluid, amount)
    filter_entity.connect_neighbour({wire = defines.wire_type.red, target_entity = other_entity})

    local control = filter_entity.get_control_behavior()
    if control and control.valid then
        control.circuit_condition = {
            condition={
                comparator=">",
                first_signal={type="fluid", name=fluid},
                constant=amount
            }
        }
    end
end


function add_modules(entity, name, count)
    local entity_module_inventory = entity.get_module_inventory()
    if entity_module_inventory and entity_module_inventory.valid then
        entity_module_inventory.insert({name=name, count=count})
    end
end

function place_entity(player, entity_name, position, direction, skip_check)
    local entity
    local real_position = {
        start_x + position[1],
        start_y + position[2],
    }
    if not direction then
        direction = default_direction
    end
    if skip_check or player.surface.can_place_entity({name=entity_name, position=real_position, direction = direction, force=player.force}) then
        entity = player.surface.create_entity({name=entity_name, position=real_position, force=player.force, direction = direction})
    else
        log_info("Can not place " .. entity_name .. " at " .. position[1] .. "x" .. position[2])
    end
    return entity
end

function place_entities(player, entity_name, positions, direction, skip_check)
    for _, position in pairs(positions) do
        place_entity(player, entity_name, position, direction, skip_check)
    end
end

function place_entities_direction(player, entity_name, positions_directions, skip_check)
    for _, position_direction in pairs(positions_directions) do
        place_entity(player, entity_name, position_direction.position, position_direction.direction, skip_check)
    end
end

function get_blueprint_string()
    return "0eNq9mt1yozgQhd+Fa5NCIJDki3mRrVRKBtnWDAZKgHddKb/7COP4J26BOnH2ZjJ20IfUfdR9BHkPVmWvGqOrLli+BzqvqzZY/vMetHpTyXL4rjs0KlgGulO7YBFUcjd8autSmrCRlSqD4yLQVaH+C5bk+LoIVNXpTqsRc/pweKv63UoZewEIWARN3doxdTXcz3LCOFoEB/uTiONx8UCJPSmETVESXwqdolBfCpmipJ4UPgXJsMHNIArDBhekcGxwQYrABhekkAgZXZiC1m4CYtDihTFo9cIYtHxhDFa/MAUt4AjEoBUMY9AShjE3Gu5XbSdPQ6EAv6QfnJcUrHpYGYPzibEyZiAFq2KYghUxTMFqGKYgJQxDsAqmIAUrYJiC1S9MwZZgkJIgpQtD0AUYpKDrL0hBl1+Qgq6+IAVbfEHIVblqL5vayK42ACM5MYi1fNYpdqYu31ZqK/faXmyvyLXJe9292d8Vl2Frbdru7cFPrsteFzeGsi/XvdF5KHP79ci31XKwpSSKouHzrpHjtJbBr+A4XlKpfLhPO4DJ8I9Rxa3xtKwljY+vR3DRDKeoGIRwnKBgiMDpCYTQCCcnGEJQaoIZN3vM5ktuVGgz+QeAjKtJbC4LbcZUnuy9Z2aTzJFZet2fjbZyA1I6MX06N3gqftfdmG/VTueyDJty0PEDhjgWb/+vm8c9sTgdwU7xaBulinBXF32pwmRgQDNBNiPQdFBkL4IhyFYEQ5CdCISkuEYEM8iMPMYaCfaw9HZnyPxPqKtWmU4ZF+WzOiDmTS/qlCpDq7sWkNvHXoMQ1K/6jw6VPb/656YvVFjr8r7y029W/ow46kOa3uUw7OpwY+q+Klx5gJWQeXn75OzsM9jXp8wr+GScSPb84G+V3B8eg//dtssiV/C5V9hIdo5b6oib8Irbubr9QNxKvdl2PxA3l2izCHmUZHDgMuLbnrMTRny1PafUtZJ4rsOOxYqDg2d7ezIxmHpv/LNF4PerzyCofzWhEBOq6lk2s8p0YpHXimLVGRq11pUyh0cGd+T34kBWsrX2Y4A0ps5V2+pqgzYiGfcOD4kvHWYuPsIfSiAolEgWee4Mcs2j715gjr3AfHfj8CQJ0I7/DIRrBje7sd81v60vcdsqQh7u71QDaJDZ7PYdVQk/vmKz3lxMjU6xohEeoskw/dtO7OmNqFEDTfW7cCPb5zYj7jo7M+YfSgaWGQjKUU8h4ueH8l85mPG7EMbRd2PoaoNMIF3oacU3MaTQm5cIW20ftjREJdid85kKbR0e4+rtR8a9bJTr2QC/FqB6vW63tVHhUPfctST1WAn19VRj3yb0q2Wc8ZvbD18Il1/kqZ9Rgt/G8AzrlEjiESf/shGBUFCcfGah8dQ6xcxgMjFYRF7PAhyDyV3fdQ6mL58ESP+Pskd+rOyJ2NMBgKcXMesfxlOL443yrH9gU/dO/dIN39rvaQE9H96I49grGLZ8eZxgBPdMCXjeEMIzJQx+PR95DufwcOKZUsfwqxplsZdVbi3slPk4p3hwM5dj0mn7XEYN14J3SvzUY6P0Orrq4QR2+fOcRbBXph1TyFkccyIiZi32XzbGwsk="
end

function pre_prepare(player)
    local radius = 5
    local player_x = player.position.x
    local player_y = player.position.y
    start_x = player_x - 2*radius
    start_y = player_y - radius
end


function prepare_player(player)
    local quickbar = player.get_inventory(defines.inventory.player_quickbar)
    quickbar.clear()
    quickbar.set_filter(1,"blueprint")
    player.force.research_all_technologies()
    player.surface.always_day = true
    player.insert{name="evaporator", count=3}
    player.insert{name="advanced-evaporator", count=3}

    player.insert{name="power-armor-mk2", count = 1}
    local p_armor = player.get_inventory(5)[1].grid
    p_armor.put({name = "fusion-reactor-equipment"})
    p_armor.put({name = "fusion-reactor-equipment"})
    p_armor.put({name = "fusion-reactor-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "personal-roboport-mk2-equipment"})
    p_armor.put({name = "night-vision-equipment"})
    p_armor.put({name = "battery-mk2-equipment"})
    p_armor.put({name = "battery-mk2-equipment"})
    player.insert{name="construction-robot", count = 25}
    player.insert{name="deconstruction-planner", count = 1}
    player.insert{name="steel-axe", count = 10}
    player.insert{name="microwave-evaporator", count = 1}
end


function prepare_blueprint(player)
    local bp_entity = player.surface.create_entity{name='item-on-ground',position={x = player.position.x, y = player.position.y - 2},stack='blueprint'}
    local stack = bp_entity.stack
    stack.import_stack(get_blueprint_string())
    local quickbar = player.get_inventory(defines.inventory.player_quickbar)
    player.insert(stack)
    return bp_entity;
end


function prepare_tiles(player, skip_trees)
    local radius = 50
    local clear_area = {{start_x - radius, start_y - radius}, {start_x + radius, start_y + radius}}
    local tiles = {}

    local types = {
        "tree",
        "cliff",
        "resource",
        "decorative",
    }

    for _,entity in pairs(player.surface.find_entities_filtered({area=clear_area, type=types})) do
        entity.destroy()
    end

    local names = {
        "rock-huge",
        "rock-big",
        "rock-medium",
        "rock-small",
        "rock-tiny",
        "sand-rock-big",
        "sand-rock-medium",
        "sand-rock-small",
    }

    for _,entity in pairs(player.surface.find_entities_filtered({area=clear_area, name=names})) do
        entity.destroy()
    end

    for x = -radius, radius, 1 do
        for y = -radius, radius, 1 do
            local tile_name = "grass-1"
            if x >= -1 and x <= 2 and y >= 0 and y <=12 then
                tile_name = "water"
            end
            table.insert(tiles, {name = tile_name, position = {start_x+x, start_y+y}})
        end
    end
    player.surface.set_tiles(tiles)

    player.surface.create_entity({name="crude-oil", amount=50000000, position={start_x, start_y-3}})


    if not skip_trees then
        local inner_radius = math.ceil(radius * 0.8)
        local tree_positions = {}
        for x = -inner_radius, inner_radius, 2 do
            table.insert(tree_positions, {x, -inner_radius})
            table.insert(tree_positions, {x, inner_radius})
        end
        for y = (-inner_radius + 1), (inner_radius - 1), 2 do
            table.insert(tree_positions, {-inner_radius, y})
            table.insert(tree_positions, {inner_radius, y})
        end
        place_entities(player, "tree-01", tree_positions, defines.direction.east)
    end
end


function prepare_terrain_blueprint(player)
    pre_prepare(player)
    prepare_player(player)
    prepare_tiles(player)

    local bp_entity = prepare_blueprint(player)
    local bp_entities = bp_entity.stack.get_blueprint_entities()
    bp_entity.destroy()
    local player_inventory = player.get_main_inventory()
    for _,entity in pairs(bp_entities) do
        player_inventory.insert({name = entity.name, count = 1})
    end

    player.insert({name = "speed-module-3", count = 10})
    player.insert({name = "iron-plate", count = 2000})
    player.insert({name = "sulfur", count = 2000})

    local quickbar = player.get_inventory(defines.inventory.player_quickbar)
    quickbar.set_filter(1,nil)

    -- local bp_item = quickbar.find_item_stack("blueprint")
    -- bp_item.build_blueprint({surface = player.surface, force = player.force, position = {x = player.position.x+1, y = player.position.y - 19}, force_build = true})

end

function prepare_terrain(player)
    pre_prepare(player)
    prepare_player(player)
    prepare_tiles(player)

    local quickbar = player.get_inventory(defines.inventory.player_quickbar)
    quickbar.set_filter(1,nil)

    local east = defines.direction.east
    local west = defines.direction.west
    local north = defines.direction.north
    local south = defines.direction.south

    local force = player.force
    local surface = player.surface

    local pipe_positions = {
        {3, 1},
        {4, 1},
        {8, -1},
        {3, 4},
        {4, 4},
        {5, 4},
        {5, 3},
        {5, 2},
        {12, -1},
        {13, -1},
        {14, -1},
        {14, -10},
        {14, 2},
        {14, 3},
        {2, -4},
        {3, -4},
        {7, -6},
        {8, -6},
        {16, -6},
        {10, -12},
        {9, -12}
    }

    local ground_pipe_data = {
        {
            position = {9, -1},
            direction = west
        },
        {
            position = {11, -1},
            direction = east
        },
        {
            position = {14, -2},
            direction = south
        },
        {
            position = {14, -9},
            direction = north
        },
        {
            position = {9, -6},
            direction = west
        },
        {
            position = {15, -6},
            direction = east
        },
        {
            position = {22, -7},
            direction = west
        },
        {
            position = {23, -7},
            direction = east
        },
        {
            position = {22, -5},
            direction = west
        },
        {
            position = {28, -5},
            direction = east
        },
        {
            position = {22, -3},
            direction = west
        },
        {
            position = {23, -3},
            direction = east
        }
    }

    local substation_positions = {
        {0, -6},
        {0, -24},
        {15, -7},
        {16, 2},
        {28, -8}
    }

    local offshore_pump_positions = {
        {2, 1},
        {2, 4}
    }

    local solar_positions = {}
    -- local solar_x = -9
    -- local solar_y = -33
    for step_x = 0,4,1 do
        local current_x = -9 + (3 * step_x)
        for step_y = 0,8,1 do
            local current_y = -33 + (3 * step_y)
            if current_x == 0 and current_y == -24 then
                log_debug("Leaving place for substation")
            else
                table.insert(solar_positions, {current_x, current_y})
            end
        end
    end


    local water_tank = place_entity(player, "storage-tank", {6, 0})
    local water_evaporator = place_entity(player, "evaporator", {8, -2}, north)
    connect_with_fluid_filter(water_evaporator, water_tank, "water", 20000)

    local water_pump = place_entity(player, "pump", {14, 1}, south)
    connect_with_fluid_filter(water_pump, water_tank, "water", 10000)

    local water_advanced_evaporator = place_entity(player, "advanced-evaporator", {14, 5}, north)
    water_advanced_evaporator.set_recipe("water-evaporation")

    local pumpjack = place_entity(player, "pumpjack", {0, -3})
    add_modules(pumpjack, "speed-module-3", 2)

    local oil_tank = place_entity(player, "storage-tank", {5, -5})
    local oil_evaporator = place_entity(player, "evaporator", {6, -7}, north)
    connect_with_fluid_filter(oil_evaporator, oil_tank, "crude-oil", 10000)

    local refinery = place_entity(player, "oil-refinery", {19, -5})
    refinery.set_recipe("basic-oil-processing")
    add_modules(refinery, "speed-module-3", 3)

    local heavy_oil_tank = place_entity(player, "storage-tank", {25, -6}, north)
    local heavy_oil_evaporator = place_entity(player, "evaporator", {24, -8}, north)
    connect_with_fluid_filter(heavy_oil_evaporator, heavy_oil_tank, "heavy-oil", 1000)

    local light_oil_tank = place_entity(player, "storage-tank", {30, -6})
    local light_oil_evaporator = place_entity(player, "evaporator", {31, -8}, north)
    connect_with_fluid_filter(light_oil_evaporator, light_oil_tank, "light-oil", 1000)

    local petroleum_gas_tank = place_entity(player, "storage-tank", {25, -2}, north)
    local petroleum_gas_evaporator = place_entity(player, "evaporator", {24, -4}, north)
    connect_with_fluid_filter(petroleum_gas_evaporator, petroleum_gas_tank, "petroleum-gas", 1000)


    local plant = place_entity(player, "chemical-plant", {12, -11})
    plant.set_recipe("sulfuric-acid")
    plant.insert{name="iron-plate", count=100}
    plant.insert{name="sulfur", count=100}
    add_modules(plant, "speed-module-3", 3)

    local chest = place_entity(player, "steel-chest", {15, -11})
    chest.insert{name="iron-plate", count=2000}
    chest.insert{name="sulfur", count=3000}

    place_entity(player, "stack-inserter", {14, -11})

    local sulfuric_acid_tank = place_entity(player, "storage-tank", {7, -11})
    local sulfuric_acid_evaporator = place_entity(player, "evaporator", {8, -13}, north)
    connect_with_fluid_filter(sulfuric_acid_evaporator, sulfuric_acid_tank, "sulfuric-acid", 10000)

    place_entities(player, "offshore-pump", offshore_pump_positions, west)
    place_entities(player, "solar-panel", solar_positions, east)
    place_entities(player, "substation", substation_positions, east)
    place_entities_direction(player, "pipe-to-ground", ground_pipe_data)
    place_entities(player, "pipe", pipe_positions, east)

    refresh_force_globals(player)
    show_gui_info_frame(player)
end
