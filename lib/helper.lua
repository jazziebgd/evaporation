local nbsp = " "

function get_nbsp(count)
    local value = ""
    if not count then
        count = 1
    end
    for i=1,count,1 do
        value = value .. nbsp
    end
    return value
end

function is_dev(player)
    return jazziebgd.lib.array_has_value(mod_config.dev_player_names, player.name)
end


function get_clean_area(player, radius)
    local player_x = player.position.x
    local player_y = player.position.y
    local local_area = nil

    if radius == nil then
        radius = 0
    end

    if radius > 0 then
        local min_x = player_x - radius
        local max_x = player_x + radius
        local min_y = player_y - radius
        local max_y = player_y + radius

        local_area = {{min_x, min_y}, {max_x, max_y}}
    end
    return local_area
end


function get_entity_types(player)
    local do_pipes = get_runtime_player_setting(player, "faucet-clean-pipes")
    local do_pumps = get_runtime_player_setting(player, "faucet-clean-pumps")
    local do_tanks = get_runtime_player_setting(player, "faucet-clean-tanks")

    local entity_types = {}
    if do_pipes == true then
        entity_types[#entity_types+1] = "pipe"
        entity_types[#entity_types+1] = "pipe-to-ground"
    end

    if do_pumps == true then
        entity_types[#entity_types+1] = "pump"
    end

    if do_tanks == true then
        entity_types[#entity_types+1] = "storage-tank"
    end
    return entity_types
end

function is_zero_area(area)
    local zero = false
    if area.left_top.x == area.right_bottom.x and area.left_top.y == area.right_bottom.y then
        zero = true
    end
    return zero
end

function get_eligible_entities_area(player, local_area)
    local entities = {}
    local entity_types = get_entity_types(player)
    for key, ent in pairs(player.surface.find_entities_filtered{ area = local_area, type = entity_types, force = player.force } ) do
        local is_eligible = false
        for i=1,#ent.fluidbox do
            local fluid = ent.fluidbox[i]
            if type(fluid) == "table" then
                is_eligible = true
            end
        end
        if is_eligible then
            table.insert(entities, ent)
        end
    end
    return entities
end


function highlight_entities(player, entities)
    for key, ent in pairs(entities) do
        ent.surface.create_trivial_smoke({name="smoke-fast", position=ent.position})
    end
end


function technology_researched(player, technology)
    if player.force.technologies[technology] then
        return player.force.technologies[technology].researched
    end
end



function is_entity_evaporator(entity)
    if entity and entity.name then
        if jazziebgd.lib.array_has_value(mod_config.all_evaporator_entity_names, entity.name) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function is_entity_basic_evaporator(entity)
    if entity and entity.name then
        if jazziebgd.lib.array_has_value(mod_config.evaporator_entity_names, entity.name) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function is_entity_advanced_evaporator(entity)
    if entity and entity.name then
        if jazziebgd.lib.array_has_value(mod_config.advanced_evaporator_entity_names, entity.name) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function get_mod_setting_groups()
    local groups = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        if not jazziebgd.lib.array_has_value(groups, value.group) then
            table.insert(groups, value.group)
        end
    end
    return groups
end

function get_mod_setting_info(setting_name)
    if mod_config.mod_gui_settings[setting_name] then
        return mod_config.mod_gui_settings[setting_name]
    else
        return false
    end
end

function get_mod_group_setting_names(group)
    local setting_names = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        local add = false
        if group == nil then
            add = true
        elseif group == value.group then
            add = true
        end

        if add then
            table.insert(setting_names, name)
        end
    end
    return setting_names
end

function get_mod_setting_names(debug_mode)
    local setting_names = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        local add = false
        if debug_mode and value.debug_only  then
            add = true
        elseif not debug_mode and not value.debug_only then
            add = true
        end

        if add then
            table.insert(setting_names, name)
        end
    end
    return setting_names
end

function get_mod_checkbox_setting_names(debug_mode)
    local setting_names = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        local add = false
        if value.control == "checkbox" then
            if debug_mode and value.debug_only  then
                add = true
            elseif not debug_mode and not value.debug_only then
                add = true
            end
        end
        if add then
            table.insert(setting_names, name)
        end
    end
    return setting_names
end

function get_mod_dropdown_setting_names(debug_mode)
    local setting_names = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        local add = false
        if value.control == "dropdown" then
            if debug_mode and value.debug_only  then
                add = true
            elseif not debug_mode and not value.debug_only then
                add = true
            end
        end
        if add then
            table.insert(setting_names, name)
        end
    end
    return setting_names
end

function get_mod_column_setting_names(debug_mode)
    local setting_names = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        if value.is_info_column then
            table.insert(setting_names, name)
        end
    end
    return setting_names
end

function get_mod_default_settings()
    local settings = {}
    for name, value in pairs(mod_config.mod_gui_settings) do
        settings[name] = value.default_value
    end
    if game.map_settings.pollution.enabled ~= true then
        settings["show_pollution"] = false
        settings["show_pollution_per_second"] = false
    end
    return settings
end


function get_pollution_per_tick(fluid_name)
    local pollution = 0
    if mod_config.pollution_per_tick[fluid_name] then
        pollution = mod_config.pollution_per_tick[fluid_name]
    else
        pollution = mod_config.pollution_per_tick._default
    end
    return pollution
end

function initialize_fluid_table(player, fluid_name, force)
    local faucet_info = global.faucet_data.force_stats[player.force.name]
    if not faucet_info.total_fluids[fluid_name] or force == true then
        faucet_info.total_fluids[fluid_name] = {
            total = 0,
            previous_total = 0,
            per_second = 0,
            total_pollution = 0,
            previous_pollution = 0,
            pollution_per_second = 0,
            active = 0
        }
    end
end

function log_mod_settings(player)
    local mod_setting_categories = {
        startup = "startup",
        global = "runtime-global",
        player = "runtime-per-user"
    }
    local mod_settings = settings.get_player_settings(player)
    local mod_settings_info = get_mod_config_var("mod_settings")
    local mod_settings_data = {}
    for setting_category_index, setting_category in pairs(mod_setting_categories) do
        for _, setting_info in pairs(mod_settings_info) do
            if setting_info.setting_type == setting_category then
                if not mod_settings_data[setting_category] then
                    mod_settings_data[setting_category] = {}
                end
                if settings[setting_category_index] then
                    if settings[setting_category_index][setting_info.name] ~= nil then
                        mod_settings_data[setting_category][setting_info.name] = settings[setting_category_index][setting_info.name].value
                    else
                        mod_settings_data[setting_category][setting_info.name] = nil
                    end
                end
            end
        end
    end

    local is_first_category = true
    for setting_category_name, setting_category_data in pairs(mod_settings_data) do
        if is_first_category == false then
            log_message(player, nbsp)
            log_message(player, nbsp)
        end
        is_first_category = false
        log_message(player, setting_category_name .. " settings:", {r=1, g=1, b=0, a=1})
        for name, value in pairs(setting_category_data) do
            log_info(get_nbsp(4) .. name .. " = ", value)
        end
        log_info(" ")
    end
end
