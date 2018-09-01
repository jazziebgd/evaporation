require("lib.config")
require("lib.util")
require("lib.helper")
require("lib.dev")
require("lib.gui")
require("lib.commands")


function initialize_mod()
    init_interfaces()
    init_mod_commands()
    init_globals()
    check_technologies()
end


function init_globals()
    if global.faucet_data == nil then
        global.faucet_data = {
            force_stats = {}
        }
        init_all_forces_globals()
    end
    validate_player_settings()
    update_global_settings()
end

function init_all_forces_globals()
    if game and game.forces then
        for _, force in pairs(game.forces) do
            init_force_globals(force)
        end
    end
end

function init_force_globals(force)
    log_debug("Initializing force globals for " .. force.name)
    local force_name = force.name
    if not jazziebgd.lib.array_has_key(global.faucet_data.force_stats, force_name) then
        global.faucet_data.force_stats[force_name] = get_initial_force_stats()
    end
end

function refresh_force_globals(player)
    log_info_player(player, "Refreshing force globals for " .. player.force.name)
    local force_name = player.force.name
    if not jazziebgd.lib.array_has_key(global.faucet_data.force_stats, force_name) then
        global.faucet_data.force_stats[force_name] = get_initial_force_stats()
    end

    local evaporator_count = 0
    local advanced_evaporator_count = 0
    for s_key, surface in pairs(game.surfaces) do
        evaporator_count = evaporator_count + surface.count_entities_filtered{ name = mod_config.evaporator_entity_names, force = player.force }
        advanced_evaporator_count = advanced_evaporator_count + surface.count_entities_filtered{ name = mod_config.advanced_evaporator_entity_names, force = player.force }
    end
    global.faucet_data.force_stats[force_name].evaporator_count = evaporator_count
    global.faucet_data.force_stats[force_name].advanced_evaporator_count = advanced_evaporator_count
    global.faucet_data.force_stats[force_name].total_pollution = 0
    global.faucet_data.force_stats[force_name].total_evaporation = 0
    -- global.faucet_data.force_stats[force_name].fluid_filter = nil
    for key, fluid_data in pairs(global.faucet_data.force_stats[force_name].total_fluids) do
        initialize_fluid_table(player, key, true)
    end
    refresh_statistics(player)
end

function get_force_stats(force)
    local force_name = force.name
    if not jazziebgd.lib.array_has_key(global.faucet_data.force_stats, force_name) then
        init_force_globals(force)
    end
    return global.faucet_data.force_stats[force_name]
end


function get_initial_force_stats()
    local force_stats = {
        last_stat_tick = 0,
        evaporator_count = 0,
        advanced_evaporator_count = 0,
        total_fluids = {},
        fluid_filter = nil,
        total_pollution = 0,
        total_evaporation = 0,
        arrow_data = {
            last_arrow_tick = nil,
            last_arrow_entity = nil,
        }
    }
    force_stats.map_settings = {
        pollution = game.map_settings.pollution.enabled
    }
    force_stats.settings = get_mod_default_settings()
    return force_stats
end


function get_runtime_player_setting(player, setting_name)
    local value
    local mod_settings = settings.get_player_settings(player)
    if mod_settings[setting_name] then
        value = mod_settings[setting_name].value
    end
    return value
end

function validate_player_settings()
    if game and game.players then
        local initial_settings = get_mod_default_settings()
        for _, player in pairs(game.players) do
            for name, value in pairs(initial_settings) do
                if global.faucet_data.force_stats[player.force.name].settings[name] == nil then
                    global.faucet_data.force_stats[player.force.name].settings[name] = initial_settings[name]
                end
            end
        end
    end
end

function init_interfaces()
    log_debug("Initializing faucet interface")
    remote.add_interface("faucet", {
        check_technologies = function()
            log_info("Check technologies called")
            check_technologies()
        end
    })
end

function init_mod_commands()
    log_debug("Initializing faucet commands")
    local command_data = get_command_data()
    local command_methods = get_command_methods()
    for name, help in pairs(command_data) do
        commands.add_command(name, help, command_methods[name])
    end
end

function update_global_settings(player)
    log_debug_player(player, "Updating global settings")
    if mod_config.debug_active then
        if player ~= nil or game then
            if player == nil then
                for _, _player in pairs(game.players) do
                    if _player.connected then
                        mod_config.debug_level = get_player_setting(_player, "debug_level")
                        mod_config.log_to_file = get_player_setting(_player, "log_to_file")
                    end
                end
            else
                mod_config.debug_level = get_player_setting(player, "debug_level")
                mod_config.log_to_file = get_player_setting(player, "log_to_file")
            end
        end
    end
end

-- script event functions
local function on_init()
    log_debug("on_init called")
    initialize_mod()
end

local function on_load()
    log_debug("on_load called")
    initialize_mod()
end

local function on_player_created(event)
    init_globals()
    local player = game.players[event.player_index]
    log_debug_player(player, "Faucet on_player_created ", player.name)
    check_technologies()
end

local function on_gui_click(event)
    local player = game.players[event.player_index]
    if event.element.name == "faucet_button_info" then
        log_verbose_player(player, "Click: info button")
        toggle_gui_info_frame(player)
    elseif event.element.name == "close_frame_button" then
        log_verbose_player(player, "Click: close info frame button")
        hide_gui_info_frame(player)
    elseif event.element.name == "settings_button" then
        toggle_info_settings(player)
    elseif event.element.name == "details_button" then
        toggle_info_details(player)
    elseif event.element.name == "reset_settings_button" then
        reset_settings(player)
    elseif event.element.name == "reset_statistics_button" then
        refresh_force_globals(player)
    elseif event.element.name == "reset_fluid_filter_button" then
        set_fluid_filter(player, nil)
    elseif string.find(event.element.name, "faucet_setting_checkbox_") then
        setting_click(event)
    elseif string.find(event.element.name, "faucet_setting_label_") then
        setting_click(event)
    elseif string.find(event.element.name, "faucet_setting_icon_") then
        setting_click(event)
    elseif event.element.name == "total_entities_button" then
        point_to_evaporator(player)
    elseif event.element.name == "total_advanced_entities_button" then
        point_to_evaporator(player, true)
    end

end

local function on_gui_selection_state_changed(event)
    if event.element.name == "faucet_setting_dropdown_debug_level" then
        mod_config.debug_level = event.element.selected_index
        set_player_setting(game.players[event.player_index], "debug_level", mod_config.debug_level)
    end
end

function on_half_second()
    for _, player in pairs(game.players) do
        if player.connected then
            process_evaporation(player)
        end
    end
end

function on_second()
    refresh_all_statistics()
    for _, player in pairs(game.players) do
        if player.connected then
            if global.faucet_data.force_stats[player.force.name].arrow_data.last_arrow_tick ~= nil then
                local elapsed_ticks = game.tick - global.faucet_data.force_stats[player.force.name].arrow_data.last_arrow_tick
                if elapsed_ticks >= 600 then
                    player.clear_gui_arrow()
                    global.faucet_data.force_stats[player.force.name].arrow_data.last_arrow_tick = nil
                end
            end
        end
    end
end

function on_player_selected_area(e)
    if e.item == "faucet-microwave-evaporator" then
        local player = game.players[e.player_index]
        local area = e.area
        if is_zero_area(area) ~= true then
            clean_fluids_area(player, area)
        end
    end
end


local function on_configuration_changed(data)
    log_info("Configuration changed")
    -- if data.mod_changes ~= nil then
    --     local changes = data.mod_changes[script.mod_name]
    --     if changes ~= nil then
    --         log_debug( "update mod: ", script.mod_name, " ", tostring(changes.old_version), " to ", tostring(changes.new_version) )
    --     end
    -- end
    if data.mod_startup_settings_changed and data.mod_startup_settings_changed == true then
        for key, player in pairs(game.players) do
            check_player_top_gui(player)
        end
    end
end

local function on_research_finished(event)
    if event.research.name == "evaporation" or event.research.name == "advanced-evaporation" then
        check_technologies()
    end
end

local function on_player_main_inventory_changed(event)
    local player = game.players[event.player_index]
    local inventory = player.get_main_inventory()
    for _, val in pairs(game.fluid_prototypes) do
        local item_count = inventory.get_item_count(_ .. "-vapor")
        if item_count > 0 then
            inventory.remove({name = _ .. "-vapor", count = item_count})
        end
    end
end

local function toggle_gui_key_handler(event)
    local player = game.players[event.player_index]
    if player.force.technologies["evaporation"].researched then
        toggle_gui_info_frame(player)
    end
end

local function on_gui_elem_changed(event)
    if (event.element.name == "fluid_filter_button") then
        local player = game.players[event.player_index]
        set_fluid_filter(player, event.element.elem_value)
    end
end


script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_configuration_changed)

script.on_event(defines.events.on_player_created, on_player_created )
script.on_event(defines.events.on_gui_click, on_gui_click )
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_selection_state_changed)
script.on_event(defines.events.on_player_selected_area, on_player_selected_area)
script.on_event(defines.events.on_research_finished, on_research_finished)
script.on_event(defines.events.on_player_main_inventory_changed, on_player_main_inventory_changed)
script.on_event(defines.events.on_gui_elem_changed, on_gui_elem_changed)
script.on_event("toggle-evaporation-gui", toggle_gui_key_handler)
script.on_nth_tick(30, function(e) on_half_second() end)
script.on_nth_tick(60, function(e) on_second() end)



function on_built_entity(e)
    log_debug("Player built ", e.created_entity.name)
    local entity = e.created_entity
    local force_name = e.created_entity.force.name
    if is_entity_basic_evaporator(entity) then
        global.faucet_data.force_stats[force_name].evaporator_count = global.faucet_data.force_stats[force_name].evaporator_count + 1
    elseif is_entity_advanced_evaporator(entity) then
        global.faucet_data.force_stats[force_name].advanced_evaporator_count = global.faucet_data.force_stats[force_name].advanced_evaporator_count + 1
    end
end

function on_robot_built_entity(e)
    log_debug("Robot built ", e.created_entity.name)

    local entity = e.created_entity
    local force_name = e.robot.force.name
    if is_entity_basic_evaporator(entity) then
        global.faucet_data.force_stats[force_name].evaporator_count = global.faucet_data.force_stats[force_name].evaporator_count + 1
    elseif is_entity_advanced_evaporator(entity) then
        global.faucet_data.force_stats[force_name].advanced_evaporator_count = global.faucet_data.force_stats[force_name].advanced_evaporator_count + 1
    end
end


function on_entity_died(e)
    log_debug("Died ", e.entity.name)
    local entity = e.entity
    local force_name = e.entity.force.name
    if is_entity_basic_evaporator(entity) and global.faucet_data.force_stats[force_name].evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].evaporator_count = global.faucet_data.force_stats[force_name].evaporator_count - 1
    elseif is_entity_advanced_evaporator(entity) and global.faucet_data.force_stats[force_name].advanced_evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].advanced_evaporator_count = global.faucet_data.force_stats[force_name].advanced_evaporator_count - 1
    end
end

function on_player_mined_entity(e)
    log_debug("Player mined ", e.entity.name)
    local entity = e.entity
    local force_name = e.entity.force.name
    if is_entity_basic_evaporator(entity) and global.faucet_data.force_stats[force_name].evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].evaporator_count = global.faucet_data.force_stats[force_name].evaporator_count - 1
    elseif is_entity_advanced_evaporator(entity) and global.faucet_data.force_stats[force_name].advanced_evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].advanced_evaporator_count = global.faucet_data.force_stats[force_name].advanced_evaporator_count - 1
    end
end

function on_robot_mined_entity(e)
    log_debug("Robot mined ", e.entity.name)
    local entity = e.entity
    local force_name = e.robot.force.name
    if is_entity_basic_evaporator(entity) and global.faucet_data.force_stats[force_name].evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].evaporator_count = global.faucet_data.force_stats[force_name].evaporator_count - 1
    elseif is_entity_advanced_evaporator(entity) and global.faucet_data.force_stats[force_name].advanced_evaporator_count > 0 then
        global.faucet_data.force_stats[force_name].advanced_evaporator_count = global.faucet_data.force_stats[force_name].advanced_evaporator_count - 1
    end
end


script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_robot_built_entity)
script.on_event(defines.events.on_entity_died, on_entity_died)
script.on_event(defines.events.on_player_mined_entity, on_player_mined_entity)
script.on_event(defines.events.on_robot_mined_entity, on_robot_mined_entity)



function setting_click(event)
    local match = "faucet_setting_label_"
    if not string.find(event.element.name, match) then
        match = "faucet_setting_icon_"
    end
    if not string.find(event.element.name, match) then
        match = "faucet_setting_checkbox_"
    end
    if string.find(event.element.name, match) then
        local player = game.players[event.player_index]
        local setting_name = string.sub(event.element.name, string.len(match) + 1)
        local setting_info = get_mod_setting_info(setting_name)
        if setting_info and setting_info.control == "checkbox" then
            local show_default_column = false
            local settings = get_player_settings(player)
            local state = false
            if not settings[setting_name] then
                state = true
            end
            if state == false and setting_name ~= "show_inactive" and string.find(setting_name, "show_") then
                local group_settings = get_mod_group_setting_names("columns")
                local true_count = 0
                for _, group_setting_name in pairs(group_settings) do
                    if settings[group_setting_name] then
                        true_count = true_count + 1
                    end
                end
                if true_count <= 1 then
                    show_default_column = true
                end
            end
            toggle_checkbox_setting(player, setting_name, state)
            if show_default_column then
                toggle_checkbox_setting(player, mod_config.default_column_name, true)
            end
        end
    end
end

function reset_settings(player, reset_all)
    local initial_settings = get_mod_default_settings()
    for name, value in pairs(initial_settings) do
        local setting_info = get_mod_setting_info(name)
        if setting_info.control ~= "hidden" or reset_all == true then
            global.faucet_data.force_stats[player.force.name].settings[name] = initial_settings[name]
        end
    end
    if is_gui_info_frame_displayed(player) then
        hide_gui_info_frame(player)
        show_gui_info_frame(player)
    end
end

function are_settings_changed(player, check_all)
    local changed = false
    local initial_settings = get_mod_default_settings()
    for name, value in pairs(initial_settings) do
        local setting_info = get_mod_setting_info(name)
        if setting_info.control ~= "hidden" or check_all == true then
            if global.faucet_data.force_stats[player.force.name].settings[name] ~= initial_settings[name] then
                changed = true
            end
        end
    end
    return changed
end

function check_technologies()
    if game and game.forces then
        for _, force in pairs(game.forces) do
            if force.technologies["evaporation"].researched then
                force.recipes["evaporator-recipe"].enabled = true
                for key, player in pairs(force.players) do
                    check_player_top_gui(player)
                end
            else
                force.recipes["evaporator-recipe"].enabled = false
                for key, player in pairs(force.players) do
                    hide_top_gui(player)
                end
            end
            if force.technologies["advanced-evaporation"].researched then
                force.recipes["advanced-evaporator-recipe"].enabled = true
                force.recipes["microwave-evaporator-recipe"].enabled = true
                for fluid_name, fluid_prototype in pairs(game.fluid_prototypes) do
                    if force.recipes[fluid_name .. "-evaporation"] then
                        force.recipes[fluid_name .. "-evaporation"].enabled = true
                    end
                end
            else
                force.recipes["advanced-evaporator-recipe"].enabled = false
                force.recipes["microwave-evaporator-recipe"].enabled = false
                for fluid_name, fluid_prototype in pairs(game.fluid_prototypes) do
                    if force.recipes[fluid_name .. "-evaporation"] then
                        force.recipes[fluid_name .. "-evaporation"].enabled = false
                    end
                end
            end
        end
    end
end

function process_evaporation(player)
    if not global.faucet_data then
        init_globals()
    end
    local entity_names = mod_config.all_evaporator_entity_names
    local faucet_info = global.faucet_data.force_stats[player.force.name]
    for s_key, surface in pairs(game.surfaces) do
        for key, ent in pairs(surface.find_entities_filtered{ name = entity_names, force = player.force } ) do

            if jazziebgd.lib.array_has_value(mod_config.advanced_evaporator_entity_names, ent.name) then
                local inventory = ent.get_output_inventory()
                local item_count = inventory.get_item_count();
                inventory.clear()
                local recipe = ent.get_recipe()
                if recipe ~= nil and item_count > 0 then
                    for ing_key, fluid in pairs(recipe.ingredients) do
                        if fluid.type == "fluid" then
                            initialize_fluid_table(player, fluid.name)
                            if fluid.amount > 0 then
                                faucet_info.total_fluids[fluid.name].total = faucet_info.total_fluids[fluid.name].total + fluid.amount
                                faucet_info.total_evaporation = faucet_info.total_evaporation + fluid.amount
                                local pollution = get_pollution_per_tick(fluid.name)
                                if pollution > 0 then
                                    faucet_info.total_fluids[fluid.name].total_pollution = faucet_info.total_fluids[fluid.name].total_pollution + pollution
                                    faucet_info.total_pollution = faucet_info.total_pollution + pollution
                                end
                            end
                        end
                    end
                end
            else
                for i=1,#ent.fluidbox do
                    local fluid = ent.fluidbox[i]
                    if type(fluid) == "table" then
                        initialize_fluid_table(player, fluid.name)
                        if fluid.amount > 0 then
                            faucet_info.total_fluids[fluid.name].total = faucet_info.total_fluids[fluid.name].total + fluid.amount
                            faucet_info.total_evaporation = faucet_info.total_evaporation + fluid.amount
                            local pollution = get_pollution_per_tick(fluid.name)
                            if pollution > 0 then
                                surface.pollute(ent.position, pollution)
                                faucet_info.total_fluids[fluid.name].total_pollution = faucet_info.total_fluids[fluid.name].total_pollution + pollution
                                faucet_info.total_pollution = faucet_info.total_pollution + pollution
                            end

                            ent.fluidbox[i] = nil;
                        end
                    end
                end
            end
        end
    end
end


function clean_fluid_entities(entities, skip_cleaning)
    local cleaned_fluid_volumes = {}
    local cleaned_fluids = {}
    for key, ent in pairs(entities) do
        for i=1,#ent.fluidbox do
            local fluid = ent.fluidbox[i]
            if type(fluid) == "table" then
                if fluid.amount > 0 then
                    if not jazziebgd.lib.array_has_value(cleaned_fluids, fluid.name) then
                        -- first time encountering this fluid
                        cleaned_fluids[#cleaned_fluids+1] = fluid.name
                        cleaned_fluid_volumes[#cleaned_fluid_volumes+1] = {name = fluid.name, amount = fluid.amount, entity_count = 1}
                    else
                        -- global force fluid structures already created
                        local index = jazziebgd.lib.find_index_by_name(cleaned_fluid_volumes, fluid.name)
                        if index > -1 then
                            cleaned_fluid_volumes[index].amount = cleaned_fluid_volumes[index].amount + fluid.amount
                            cleaned_fluid_volumes[index].entity_count = cleaned_fluid_volumes[index].entity_count + 1
                        end
                    end
                end
            end
            if not skip_cleaning then
                ent.fluidbox[i] = nil;
            end
        end
    end
    return cleaned_fluid_volumes
end


function clean_fluids_area(player, area)
    local total_entities = 0
    local total_amount = 0

    local eligible_entities = get_eligible_entities_area(player, area)
    local cleaned_fluid_volumes = clean_fluid_entities(eligible_entities)

    for key, fluid_info in pairs(cleaned_fluid_volumes) do
        total_amount = total_amount + fluid_info.amount
        total_entities = total_entities + fluid_info.entity_count
    end

    if get_runtime_player_setting(player, "faucet-show-cleaning-result") then
        if total_entities > 0 then
            for i=1,#cleaned_fluid_volumes do
                log_message(player, "Cleaned " .. jazziebgd.lib.format_num(math.ceil(cleaned_fluid_volumes[i].amount)) .. " " .. cleaned_fluid_volumes[i].name .. " from " .. cleaned_fluid_volumes[i].entity_count .. " entities")
            end
            if #cleaned_fluid_volumes > 1 then
                log_message(player, "---------------------------------------------------")
                log_message(player, "Total cleaned " .. jazziebgd.lib.format_num(math.ceil(total_amount)) .. " from " .. total_entities .. " entities")
            end
        else
            log_message(player, "No valid entities found")
        end
    end

    highlight_entities(player, eligible_entities)
end

function get_player_settings(player)
    local settings = global.faucet_data.force_stats[player.force.name].settings
    if game.map_settings.pollution.enabled ~= true then
        settings["show_pollution"] = false
        settings["show_pollution_per_second"] = false
    end
    return settings
end

function get_player_setting(player, setting_name)
    local value
    if global.faucet_data.force_stats[player.force.name].settings[setting_name] ~= nil then
        value = global.faucet_data.force_stats[player.force.name].settings[setting_name]
    else
        log_warning_player(player, "No setting found: ", setting_name)
    end
    return value
end

function set_player_setting(player, setting_name, value)
    log_debug_player(player, "Setting change: ", setting_name, " to ", value)
    global.faucet_data.force_stats[player.force.name].settings[setting_name] = value
    update_global_settings(player)
end

function toggle_checkbox_setting(player, setting_name, state)
    set_player_setting(player, setting_name, state)
    hide_gui_info_frame(player)
    show_gui_info_frame(player)
    refresh_info_data(player)
    refresh_gui_info_frame_data(player)
end

function point_to_evaporator(player, advanced_evaporator)
    local force_stats = global.faucet_data.force_stats[player.force.name]
    local entity_names = mod_config.evaporator_entity_names
    if advanced_evaporator then
        entity_names = mod_config.advanced_evaporator_entity_names
    end
    local evaporators = player.surface.find_entities_filtered{ name = entity_names, force = player.force }
    local evaporator = nil
    if #evaporators > 0 then
        player.clear_gui_arrow();
        if force_stats.arrow_data.last_arrow_entity and force_stats.arrow_data.last_arrow_entity.type ~= evaporators[1].type then
            force_stats.arrow_data.last_arrow_entity = nil
        end
        if force_stats.arrow_data.last_arrow_entity ~= nil then
            for index = 1, #evaporators, 1 do
                if evaporators[index] == force_stats.arrow_data.last_arrow_entity then
                    local new_index = index + 1
                    if force_stats.arrow_data.last_arrow_tick == nil then
                        new_index = index
                    end
                    if #evaporators < new_index then
                        new_index = 1
                    end
                    evaporator = evaporators[new_index]
                end
            end
        end
        if evaporator == nil and #evaporators > 0 then
            evaporator = evaporators[1]
        end
        if evaporator then
            force_stats.arrow_data.last_arrow_entity = evaporator
            force_stats.arrow_data.last_arrow_tick = game.tick
            player.set_gui_arrow({type="entity", entity=evaporator})
        end
    end
end

function set_fluid_filter(player, fluid_filter)
    global.faucet_data.force_stats[player.force.name].fluid_filter = fluid_filter
    update_fluid_filter_gui(player)
end