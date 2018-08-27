require("gui_util")

local gui_elements = {
    details_button = nil,
    settings_button = nil,
    total_entities_label = nil,
    total_advanced_entities_label = nil,
    total_pollution_label = nil,
    total_evaporation_label = nil,
    data_table = nil,
    settings_flow = nil,
    group_flow_main = nil,
    group_flow_debug = nil,
    group_flow_columns = nil,
    details_flow = nil,
    fluid_filter_button = nil,
    fluid_filter_label = nil,
    reset_fluid_filter_button = nil,
    reset_settings_button = nil,
    reset_statistics_button = nil,
    fluid_data_elements = {}
}

function reset_gui_elements()
    gui_elements = {
        details_button = nil,
        settings_button = nil,
        total_entities_label = nil,
        total_advanced_entities_label = nil,
        total_pollution_label = nil,
        total_evaporation_label = nil,
        data_table = nil,
        settings_flow = nil,
        group_flow_main = nil,
        group_flow_debug = nil,
        group_flow_columns = nil,
        details_flow = nil,
        fluid_filter_button = nil,
        fluid_filter_label = nil,
        reset_fluid_filter_button = nil,
        reset_settings_button = nil,
        reset_statistics_button = nil,
        fluid_data_elements = {}
    }
end

function detect_gui_elements(player)
    local faucet_info = player.gui.left.faucet_info
    gui_elements = {
        details_button = find_gui_element_by_name("details_button", faucet_info),
        settings_button = find_gui_element_by_name("settings_button", faucet_info),
        total_entities_label = find_gui_element_by_name("total_entities_label", faucet_info),
        total_advanced_entities_label = find_gui_element_by_name("total_advanced_entities_label", faucet_info),
        total_pollution_label = find_gui_element_by_name("total_pollution_label", faucet_info),
        total_evaporation_label = find_gui_element_by_name("total_evaporation_label", faucet_info),
        data_table = find_gui_element_by_name("data_table", faucet_info),
        settings_flow = find_gui_element_by_name("settings_flow", faucet_info),
        group_flow_main = find_gui_element_by_name("group_flow_main", faucet_info),
        group_flow_debug = find_gui_element_by_name("group_flow_debug", faucet_info),
        group_flow_columns = find_gui_element_by_name("group_flow_columns", faucet_info),
        details_flow = find_gui_element_by_name("details_flow", faucet_info),
        fluid_filter_button = find_gui_element_by_name("fluid_filter_button", faucet_info),
        fluid_filter_label = find_gui_element_by_name("fluid_filter_label", faucet_info),
        reset_fluid_filter_button = find_gui_element_by_name("reset_fluid_filter_button", faucet_info),
        reset_settings_button = find_gui_element_by_name("reset_settings_button", faucet_info),
        reset_statistics_button = find_gui_element_by_name("reset_statistics_button", faucet_info),
        fluid_data_elements = {}
    }
    for key, fluid_data in pairs(global.faucet_data.force_stats[player.force.name].total_fluids) do
        gui_elements.fluid_data_elements[key] = {}
        local fluid_data_sprite_flow = find_gui_element_by_name("sprite_cell_flow_" .. key, faucet_info)
        if fluid_data_sprite_flow then
            gui_elements.fluid_data_elements[key].sprite = fluid_data_sprite_flow.fluid_sprite
        else
            gui_elements.fluid_data_elements[key].sprite = nil
        end
        local total_cell_flow = find_gui_element_by_name("total_cell_flow_" .. key, faucet_info)
        if total_cell_flow then
            gui_elements.fluid_data_elements[key].total_label = total_cell_flow.label
        else
            gui_elements.fluid_data_elements[key].total_label = nil
        end
        local per_sec_cell_flow = find_gui_element_by_name("per_sec_cell_flow_" .. key, faucet_info)
        if per_sec_cell_flow then
            gui_elements.fluid_data_elements[key].per_second_label = per_sec_cell_flow.label
        else
            gui_elements.fluid_data_elements[key].per_second_label = nil
        end
        local total_pollution_cell_flow = find_gui_element_by_name("total_pollution_cell_flow_" .. key, faucet_info)
        if total_pollution_cell_flow then
            gui_elements.fluid_data_elements[key].total_pollution_label = total_pollution_cell_flow.label
        else
            gui_elements.fluid_data_elements[key].total_pollution_label = nil
        end
        local pollution_per_sec_cell_flow = find_gui_element_by_name("pollution_per_sec_cell_flow_" .. key, faucet_info)
        if pollution_per_sec_cell_flow then
            gui_elements.fluid_data_elements[key].pollution_per_second_label = pollution_per_sec_cell_flow.label
        else
            gui_elements.fluid_data_elements[key].pollution_per_second_label = nil
        end
    end
end

function create_setting_flow(player, parent, setting_name, items, selected_index)
    local setting_info = get_mod_setting_info(setting_name)
    local setting_flow
    if setting_info then
        if setting_info.control ~= "hidden" then
            local tooltip = {"faucet-info-setting-tooltip-" .. setting_name}
            setting_flow = create_flow(parent, "setting_" .. setting_name .. "_flow", "horizontal", "faucet_stretch_flow_style", {vertical_align = "center", top_padding = 0, bottom_padding = 4})
            local setting_label_flow = create_flow(setting_flow, "setting_label_flow", "horizontal", "faucet_stretch_flow_style", {align = "right"})
            create_label(setting_label_flow, "faucet_setting_label_" .. setting_name, {"faucet-info-setting-" .. setting_name}, tooltip, "faucet_label_style")
            if setting_info.sprite ~= nil then
                local setting_icon_flow = create_flow(setting_flow, "setting_icon_flow", "horizontal", "faucet_flow_style", {left_padding = 5, right_padding = 5})
                create_sprite(setting_icon_flow, "faucet_setting_icon_" .. setting_name, setting_info.sprite, tooltip)
            end
            if setting_info.control == "checkbox" then
                create_checkbox_setting_flow(player, setting_flow, setting_name)
            elseif setting_info.control == "dropdown" then
                create_dropdown_setting_flow(player, setting_flow, setting_name, items, selected_index)
            end
        end
    else
        log_info("Can not create setting flow for " .. setting_name)
    end
    return setting_flow
end

function create_setting_table_cell_flow(player, parent, setting_name, items, selected_index)
    local setting_info = get_mod_setting_info(setting_name)
    local setting_flow
    if setting_info then
        if setting_info.control ~= "hidden" then
            local tooltip = {"faucet-info-setting-tooltip-" .. setting_name}
            setting_flow = create_flow(parent, "setting_" .. setting_name .. "_flow", "vertical", "faucet_vertical_flow_style", {align="center", vertical_align = "center", bottom_padding = 5, left_padding = 30})
            local setting_label_flow = create_flow(setting_flow, "setting_label_flow", "horizontal", "faucet_flow_style", {align = "center"})
            create_label(setting_label_flow, "faucet_setting_label_" .. setting_name, {"faucet-info-setting-" .. setting_name}, tooltip, "faucet_label_style")
            if setting_info.sprite ~= nil then
                local setting_icon_flow = create_flow(setting_flow, "setting_icon_flow", "horizontal", "faucet_flow_style", {left_padding = 10})
                create_sprite(setting_icon_flow, "faucet_setting_icon_" .. setting_name, setting_info.sprite, tooltip)
                setting_label_flow.style.visible = false
            end
            if setting_info.control == "checkbox" then
                create_checkbox_setting_flow(player, setting_flow, setting_name)
            elseif setting_info.control == "dropdown" then
                create_dropdown_setting_flow(player, setting_flow, setting_name, items, selected_index)
            end
        end
    else
        log_info("Can not create setting flow for " .. setting_name)
    end
    return setting_flow
end

function create_dropdown_setting_flow(player, parent, setting_name, items, selected_index)
    local setting_info = get_mod_setting_info(setting_name)
    local force_stats = global.faucet_data.force_stats[player.force.name]
    local tooltip = {"faucet-info-setting-tooltip-" .. setting_name}
    local setting_dropdown_flow = create_flow(parent, "setting_dropdown_flow", "horizontal", "faucet_flow_style", {left_padding = 10})
    if items == nil then
        if setting_info.item_values and #setting_info.item_values > 0 then
            items = setting_info.item_values
        else
            items = {" "}
        end
    end
    if selected_index == nil then
        selected_index = 1
    end
    if force_stats.settings[setting_name] ~= nil then
        selected_index = force_stats.settings[setting_name] + 0
    end
    if selected_index < 1 then
        selected_index = 1
    elseif selected_index > #items then
        selected_index = #items
    end
    setting_dropdown_flow.add({type="drop-down", name="faucet_setting_dropdown_" .. setting_name, items=items, selected_index = selected_index, tooltip = tooltip})
    return setting_flow
end

function create_checkbox_setting_flow(player, parent, setting_name)
    local setting_info = get_mod_setting_info(setting_name)
    local force_stats = global.faucet_data.force_stats[player.force.name]
    local tooltip = {"faucet-info-setting-tooltip-" .. setting_name}
    local state = false
    if force_stats.settings[setting_name] then
        state = true
    end
    local setting_checkbox_flow = create_flow(parent, "setting_checkbox_flow", "horizontal", "faucet_flow_style", {left_padding = 10})
    setting_checkbox_flow.add({type="checkbox", name="faucet_setting_checkbox_" .. setting_name, state = state, tooltip = tooltip})
    return setting_flow
end

function check_top_gui()
    for _, player in pairs(game.players) do
        check_player_top_gui(player)
    end
end

function check_player_top_gui(player)
    local show_gui = false
    if settings.startup["faucet-show-gui"] and settings.startup["faucet-show-gui"].value then
        show_gui = true
    end
    if player.connected then
        if show_gui then
            build_top_gui(player)
        else
            hide_top_gui(player)
        end
    end
end


function build_top_gui_frame(player)
    local flow = player.gui.top.faucet_flow
    if flow == nil then
        log_debug("Create GUI frame for player " .. player.name)
        flow = create_flow(player.gui.top, "faucet_flow", "horizontal", "faucet_flow_style")
    else
        show_top_gui(player)
        log_debug("GUI frame exists for player " .. player.name)
    end
    return flow
end

function build_top_gui_buttons(player)
    local flow = build_top_gui_frame(player)
    log_debug("Add GUI button 1 for player " .. player.name)
    local gui_button_2 = flow.add({type = "button", name = "faucet_button_info", style = "faucet_info_button_style", tooltip={"faucet-button-gui-info-tooltip"}})

    return flow
end

function build_top_gui( player )
    local flow = player.gui.top.faucet_flow
    if flow == nil then
        flow = build_top_gui_frame(player)
    else
        flow.clear()
    end
    flow = build_top_gui_buttons(player)
    return(flow)
end

function rebuild_top_gui()
    log_debug("Rebuilding faucet GUI")
    for _, player in pairs(game.players) do
        build_top_gui(player)
    end
end

function show_top_gui(player)
    local flow = player.gui.top.faucet_flow
    if flow == nil then
        flow = build_top_gui(player)
    end
    flow.style.visible = true
end

function hide_top_gui(player)
    local flow = player.gui.top.faucet_flow
    if flow == nil then
        flow = build_top_gui(player)
    end
    flow.style.visible = false
    hide_gui_info_frame(player)
end


function show_gui_info_frame(player)
    if player.gui.left.faucet_info then
        return
    end
    reset_gui_elements()
    local settings = global.faucet_data.force_stats[player.force.name].settings
    local draw_h_border = settings["show_horizontal_table_borders"]
    local draw_v_border = settings["show_vertical_table_borders"]

    local info_frame = player.gui.left.add({type="frame", name="faucet_info", direction="vertical", style="faucet_frame_style"})
    local info_frame_table = info_frame.add({type = "table", name = "faucet_info_frame_table", style="faucet_data_table_style", column_count=1, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border})

    local info_heading_table = info_frame_table.add({type = "table", name = "faucet_info_frame_heading_table", style="faucet_data_table_style", column_count=3, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border})
    local info_heading_flow_1 = create_flow(info_heading_table, "info_heading_flow_1", "horizontal", "faucet_flow_style", {align = "center", horizontally_stretchable = "on"})

    local info_heading_label_flow = create_flow(info_heading_flow_1, "info_heading_label_flow", "horizontal", "faucet_stretch_flow_style", {align = "center", left_padding = 80, vertical_align = "center", width = 210})
    create_label(info_heading_label_flow, "info_heading", {"faucet-info-heading"}, nil, "faucet_heading_label_style")

    local details_visible = get_player_setting(player, "show_details")

    local info_heading_flow_2 = create_flow(info_heading_table, "info_heading_flow_2", "horizontal", "faucet_flow_style", {align = "right", width = 80, vertical_align = "center"})
    local settings_button = create_button(info_heading_flow_2, "settings_button", nil, {"faucet-info-settings-button-tooltip"}, "faucet_settings_button_style", {visible = details_visible})

    local eye_toggle_style = "faucet_eye_button_style"
    if not details_visible then
        eye_toggle_style = "faucet_eye_inactive_button_style"
    end
    local eye_button = create_button(info_heading_flow_2, "details_button", nil, {"faucet-info-details-button-tooltip"}, eye_toggle_style)
    local close_frame_button = create_button(info_heading_flow_2, "close_frame_button", nil, {"faucet-info-close-button-tooltip"}, "faucet_close_button_style")

    gui_elements.details_button = eye_button
    gui_elements.settings_button = settings_button


    local info_frame_flow_settings = create_flow(info_frame_table, "info_frame_flow_settings", "vertical", "faucet_vertical_flow_style")
    build_info_settings_flow(player, info_frame_flow_settings)
    local info_frame_flow_1 = create_flow(info_frame_table, "info_frame_flow_1", "horizontal", "faucet_flow_style", {align = "center"})

    local column_count = 8
    if game.map_settings.pollution.enabled ~= true then
        column_count = 6
    end

    local info_frame_flow_1_table = info_frame_flow_1.add({type = "table", name = "info_frame_flow_table", style="faucet_data_table_style", column_count=column_count, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border})


    local button_flow_styles = {
        vertical_align = "center",
        left_padding = 5
    }

    local label_styles = {
        minimal_width = 20,
        maximal_width = 100,
        single_line = true,
        want_ellipsis = true
    }


    local total_entities_button_flow = create_flow(info_frame_flow_1_table, "total_entities_button_flow", "horizontal", "faucet_stretch_flow_style", button_flow_styles)
    local total_entities_button = create_button(total_entities_button_flow, "total_entities_button", nil, {"faucet-info-evaporator-button-tooltip"}, "faucet_evaporator_button_style")
    local total_entities_label_flow = create_flow(info_frame_flow_1_table, "total_entities_label_flow", "horizontal", "faucet_flow_style", {align = "left", vertical_align = "center", right_padding = 15})
    local total_entities_label = create_label(total_entities_label_flow, "total_entities_label", " ", nil, "faucet_label_style", label_styles)

    local total_advanced_entities_button_flow = create_flow(info_frame_flow_1_table, "total_advanced_entities_button_flow", "horizontal", "faucet_stretch_flow_style", button_flow_styles)
    local total_advanced_entities_button = create_button(total_advanced_entities_button_flow, "total_advanced_entities_button", nil, {"faucet-info-advanced-evaporator-button-tooltip"}, "faucet_advanced_evaporator_button_style")
    local total_advanced_entities_label_flow = create_flow(info_frame_flow_1_table, "total_advanced_entities_label_flow", "horizontal", "faucet_flow_style", {align = "left", vertical_align = "center", right_padding = 15})
    local total_advanced_entities_label = create_label(total_advanced_entities_label_flow, "total_advanced_entities_label", " ", nil, "faucet_label_style", label_styles)

    local total_evaporation_icon_flow = create_flow(info_frame_flow_1_table, "total_evaporation_icon_flow", "horizontal", "faucet_flow_style", {vertical_align = "center"})
    local total_evaporation_icon = create_sprite(total_evaporation_icon_flow, "total_evaporation_icon", "faucet_evaporation_sprite", {"faucet-info-total-text"}, nil, icon_styles)
    local total_evaporation_label_flow = create_flow(info_frame_flow_1_table, "total_evaporation_label_flow", "horizontal", "faucet_flow_style", {align = "left", vertical_align = "center"})
    local total_evaporation_label = create_label(total_evaporation_label_flow, "total_evaporation_label"," ", nil, "faucet_label_style", label_styles)

    if game.map_settings.pollution.enabled == true then
        local total_pollution_icon_flow = create_flow(info_frame_flow_1_table, "total_pollution_icon_flow", "horizontal", "faucet_flow_style", {vertical_align = "center"})
        local total_pollution_icon = create_sprite(total_pollution_icon_flow, "total_pollution_icon", "faucet_pollution_sprite", {"faucet-info-pollution-text"}, nil, icon_styles)
        local total_pollution_label_flow = create_flow(info_frame_flow_1_table, "total_pollution_label_flow", "horizontal", "faucet_flow_style", {align = "left", vertical_align = "center"})
        local total_pollution_label = create_label(total_pollution_label_flow, "total_pollution_label"," ", nil, "faucet_label_style", label_styles)
        gui_elements.total_pollution_label = total_pollution_label
    end

    gui_elements.total_entities_label = total_entities_label
    gui_elements.total_advanced_entities_label = total_advanced_entities_label
    gui_elements.total_evaporation_label = total_evaporation_label

    local details_visible = get_player_setting(player, "show_details")
    local details_flow = create_flow(info_frame_table, "details_flow", "vertical", "faucet_vertical_flow_style", {visible = details_visible})
    gui_elements.details_flow = details_flow
    show_info_data(player)
    refresh_gui_info_frame_data(player)
end

function refresh_gui_info_frame_data(player)
    local force_name = player.force.name
    local total_entities = global.faucet_data.force_stats[force_name].evaporator_count or 0
    local total_advanced_entities = global.faucet_data.force_stats[force_name].advanced_evaporator_count or 0
    local total_pollution = jazziebgd.lib.format_num(global.faucet_data.force_stats[force_name].total_pollution, true)
    local total_pollution_unit = jazziebgd.lib.format_num_unit(global.faucet_data.force_stats[force_name].total_pollution, true)
    local total_evaporation = jazziebgd.lib.format_num(global.faucet_data.force_stats[force_name].total_evaporation, true)
    local total_evaporation_unit = jazziebgd.lib.format_num_unit(global.faucet_data.force_stats[force_name].total_evaporation, true)

    if not gui_elements.total_entities_label then
        detect_gui_elements(player)
    end

    if gui_elements.total_entities_label then
        gui_elements.total_entities_label.caption = total_entities
    end
    if gui_elements.total_advanced_entities_label then
        gui_elements.total_advanced_entities_label.caption = total_advanced_entities
    end
    if gui_elements.total_pollution_label then
        gui_elements.total_pollution_label.caption = total_pollution_unit
        gui_elements.total_pollution_label.tooltip = total_pollution
    end
    if gui_elements.total_evaporation_label then
        gui_elements.total_evaporation_label.caption = total_evaporation_unit
        gui_elements.total_evaporation_label.tooltip = total_evaporation
    end
end


function show_info_data(player)
    local force_name = player.force.name

    local info_frame = player.gui.left.faucet_info
    if info_frame then
        build_info_data_header(player)
        for key, fluid_data in pairs(global.faucet_data.force_stats[force_name].total_fluids) do
            add_info_data_fluid_row(player, gui_elements.data_table, key, fluid_data)
        end
    end
end

function hide_info_data(player)
    local force_name = player.force.name

    local info_frame = player.gui.left.faucet_info
    if info_frame then
        local data_flow = info_frame.faucet_info_frame_table.details_flow
        if data_flow then
            data_flow.destroy()
        end
    end
end

function build_info_data_header(player)
    local force_name = player.force.name
    local settings = global.faucet_data.force_stats[player.force.name].settings
    local draw_h_border = settings["show_horizontal_table_borders"]
    local draw_v_border = settings["show_vertical_table_borders"]

    local info_frame = player.gui.left.faucet_info
    if info_frame then
        local data_flow = info_frame.faucet_info_frame_table.details_flow
        if data_flow then
            data_flow.clear()

            local inner_data_flow = create_flow(data_flow, "inner_data_flow", "horizontal", "faucet_stretch_flow_style")
            local inner_heading_flow = create_flow(inner_data_flow, "inner_heading_flow", "vertical", "faucet_vertical_flow_style", {top_padding = 5, bottom_padding = 5, align = "center", horizontally_stretchable = "on"})
            local inner_heading_spacer = create_sprite(inner_heading_flow, "inner_heading_spacer", "faucet_spacer_500", nil, nil, {width = nil, horizontally_squashable = "on"})
            local inner_heading_label_flow = create_flow(inner_heading_flow, "inner_heading_label_flow", "horizontal", "faucet_stretch_flow_style", {align = "center"})
            local inner_heading_label_item_flow = create_flow(inner_heading_label_flow, "inner_heading_label_item_flow", "horizontal", "faucet_stretch_flow_style", {align = "center", left_padding = 100})
            local statistics_label = create_label(inner_heading_label_item_flow, "inner_heading_label", {"faucet-info-inner-heading"}, nil, "faucet_label_style")

            local statistic_filter_flow = create_flow(inner_heading_label_flow, "statistic_filter_flow", "horizontal", "faucet_flow_style", {align = "right", width = 100})

            local initial_filter = global.faucet_data.force_stats[player.force.name].fluid_filter
            local visible = true
            local label_visible = false
            if initial_filter == nil then
                visible = false
                label_visible = true
            end

            local reset_fluid_filter_flow = create_flow(statistic_filter_flow, "reset_fluid_filter_flow", "horizontal", "faucet_flow_style", {right_padding = 2, vertical_align = "center"})
            local fluid_filter_label = create_label(reset_fluid_filter_flow, "fluid_filter_label", {"faucet-info-filter-label"}, nil, "faucet_label_style", {visible = label_visible, top_padding = 3})
            local reset_fluid_filter_button = create_button(reset_fluid_filter_flow, "reset_fluid_filter_button", {"faucet-info-reset-filter-label"}, {"faucet-info-reset-filter-tooltip"}, "faucet_composition_button_style", {visible = visible})
            gui_elements.fluid_filter_label = fluid_filter_label
            gui_elements.reset_fluid_filter_button = reset_fluid_filter_button

            local fluid_filter_button = statistic_filter_flow.add({type = "choose-elem-button", sprite="faucet_fluids_sprite", name = "fluid_filter_button", caption={"faucet-info-filter-label"}, tooltip={"faucet-info-filter-label"}, style = "faucet_composition_button_style", elem_type = "fluid", fluid = initial_filter})
            gui_elements.fluid_filter_button = fluid_filter_button


            build_data_table_header(player, data_flow)
        end
    end
end

function build_data_table_header(player, data_flow)
    local force_stats = global.faucet_data.force_stats[player.force.name]

    local settings = get_player_settings(player)
    local draw_h_border = settings["show_horizontal_table_borders"]
    local draw_v_border = settings["show_vertical_table_borders"]

    local columns = get_mod_column_setting_names()

    local column_count = 1
    for _, name in pairs(columns) do
        if force_stats.settings[name] then
            column_count = column_count + 1
        end
    end


    local data_table_heading = data_flow.add({type = "table", name = "data_table_heading", style="faucet_data_table_style", column_count=column_count, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border, draw_horizontal_line_after_headers = false})
    data_table_heading.style.right_padding = 10
    local data_table_heading_flow_1 = create_flow(data_table_heading, "data_table_heading_flow_1", "horizontal", "faucet_flow_style", {align = "center"})
    data_table_heading_flow_1.add({type = "sprite", name = "resource_sprite", sprite="faucet_fluids_sprite", tooltip={"faucet-info-resource-text"}})

    if force_stats.settings["show_evaporated"] then
        local data_table_heading_flow_2 = create_flow(data_table_heading, "data_table_heading_flow_2", "horizontal", "faucet_stretch_flow_style", {align = "right"})
        data_table_heading_flow_2.add({type = "sprite", name = "evaporation_sprite", sprite="faucet_evaporation_sprite", tooltip={"faucet-info-total-text"}})
    end
    if force_stats.settings["show_evaporated_per_second"] then
        local data_table_heading_flow_3 = create_flow(data_table_heading, "data_table_heading_flow_3", "horizontal", "faucet_stretch_flow_style", {align = "right"})
        data_table_heading_flow_3.add({type = "sprite", name = "evaporation_per_second_sprite", sprite="faucet_evaporation_per_second_sprite", tooltip={"faucet-info-per-second-text"}})
    end

    if force_stats.settings["show_pollution"] then
        local data_table_heading_flow_4 = create_flow(data_table_heading, "data_table_heading_flow_4", "horizontal", "faucet_stretch_flow_style", {align = "right"})
        data_table_heading_flow_4.add({type = "sprite", name = "pollution_sprite", sprite="faucet_pollution_sprite", tooltip={"faucet-info-pollution-text"}})
    end

    if force_stats.settings["show_pollution_per_second"] then
        local data_table_heading_flow_5 = create_flow(data_table_heading, "data_table_heading_flow_5", "horizontal", "faucet_stretch_flow_style", {align = "right"})
        data_table_heading_flow_5.add({type = "sprite", name = "pollution_per_second_sprite", sprite="faucet_pollution_per_second_sprite", tooltip={"faucet-info-pollution-per-second-text"}})
    end

    create_spacer(data_flow, "data_table_heading_spacer", "faucet_spacer_300", nil, "faucet_stretch_flow_style", {align = "center", top_padding = 5, bottom_padding = 5})

    local inner_table_data_pane = data_flow.add({type = "scroll-pane", name = "inner_table_data_pane", horizontal_scroll_policy = "never", style = "faucet_data_pane_style"})
    inner_table_data_pane.style.maximal_height = 200
    local inner_table_data_flow = inner_table_data_pane.add({type = "flow", name = "inner_table_data_flow", direction = "vertical", style = "faucet_vertical_flow_style"})


    local data_table = inner_table_data_flow.add({type = "table", name = "data_table", style="faucet_data_table_style", column_count=column_count, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border, draw_horizontal_line_after_headers = false})
    data_table.style.horizontally_stretchable = "on"
    gui_elements.data_table = data_table
end

function build_info_settings_flow(player, data_flow)
    local settings = global.faucet_data.force_stats[player.force.name].settings
    local draw_h_border = settings["show_horizontal_table_borders"]
    local draw_v_border = settings["show_vertical_table_borders"]

    local visible = get_player_setting(player, "show_settings")
    local settings_flow = create_flow(data_flow, "settings_flow", "vertical", "faucet_vertical_flow_style", {visible = visible})
    gui_elements.settings_flow = settings_flow



    local groups = get_mod_setting_groups()

    for group_key, group_name in pairs(groups) do
        local render = true
        local columns = false
        if group_name == "debug" then
            if not mod_config.debug_active then
                render = false
            end
            if not is_dev(player) then
                render = false
            end
        end
        if group_name == "columns" then
            columns = true
        end

        local column_count = 4
        if game.map_settings.pollution.enabled ~= true then
            column_count = 2
        end

        if render then
            local group_flow = create_flow(settings_flow, "group_flow_" .. group_name, "vertical", "faucet_vertical_flow_style")
            create_spacer(group_flow, "group_spacer_" .. group_name, "faucet_spacer_200", nil, "faucet_stretch_flow_style", {align = "right"})
            local group_header_flow = create_flow(group_flow, "group_header_flow", "horizontal", "faucet_stretch_flow_style", {align = "right"})
            create_label(group_header_flow, "group_header_label", {"faucet-info-settings-group-header-" .. group_name}, {"faucet-info-settings-group-header-tooltip-" .. group_name}, "faucet_label_style", {font = "faucet_bold_font", top_padding = 5, bottom_padding = 5, right_padding = 10})

            local group_inner_flow
            if columns then
                group_inner_flow = group_flow.add({type = "table", name = "group_inner_flow_" .. group_name, style="faucet_data_table_style", column_count = column_count, draw_vertical_lines = draw_v_border, draw_horizontal_lines = draw_h_border})
            else
                group_inner_flow = create_flow(group_flow, "group_inner_flow_" .. group_name, "vertical", "faucet_vertical_flow_style")
            end

            local setting_names = get_mod_group_setting_names(group_name)
            for _, setting_name in pairs(setting_names) do
                if columns then
                    local do_column = true
                    if game.map_settings.pollution.enabled ~= true then
                        if setting_name == "show_pollution" or setting_name == "show_pollution_per_second" then
                            do_column = false
                        end
                    end
                    if do_column then
                        create_setting_table_cell_flow(player, group_inner_flow, setting_name)
                    end
                else
                    create_setting_flow(player, group_inner_flow, setting_name)
                end
            end
            if group_name == "main" then
                gui_elements.group_flow_main = group_flow
                gui_elements.group_flow_main.style.visible = get_player_setting(player, "show_details")
            elseif group_name == "columns" then
                gui_elements.group_flow_columns = group_flow
                gui_elements.group_flow_columns.style.visible = get_player_setting(player, "show_details")
            elseif group_name == "debug" then
                gui_elements.group_flow_debug = group_flow
                gui_elements.group_flow_debug.style.visible = get_player_setting(player, "show_details")
            end
        end
    end

    local button_enabled = false
    if are_settings_changed(player) then
        button_enabled = true
    end
    create_spacer(settings_flow, "reset_settings_spacer", "faucet_spacer_200", nil, "faucet_stretch_flow_style", {align = "right", top_padding = 5, bottom_padding = 5})
    local reset_settings_flow = create_flow(settings_flow, "reset_settings_flow", "horizontal", "faucet_stretch_flow_style", {align = "center", top_padding = 5, bottom_padding = 5})
    local reset_settings_button = create_button(reset_settings_flow, "reset_settings_button", {"faucet-info-reset-settings-button-text"}, {"faucet-info-reset-settings-button-tooltip"}, "faucet_composition_button_style", {})
    reset_settings_button.enabled = button_enabled
    gui_elements.reset_settings_button = reset_settings_button

    if is_dev(player) then
        local reset_statistics_button = create_button(reset_settings_flow, "reset_statistics_button", {"faucet-info-reset-statistics-button-text"}, {"faucet-info-reset-statistics-button-tooltip"}, "faucet_composition_button_style", {})
    end

    create_spacer(settings_flow, "reset_settings_bottom_spacer", "faucet_spacer_200", nil, "faucet_stretch_flow_style", {align = "center", top_padding = 5, bottom_padding = 5})

    return settings_flow
end

function refresh_info_data(player)
    local show_details = get_player_setting(player, "show_details")
    if show_details then
        local force_name = player.force.name
        local elapsed_ticks = game.tick - global.faucet_data.force_stats[player.force.name].last_stat_tick
        if not gui_elements.data_table then
            detect_gui_elements(player)
        end
        if gui_elements.group_flow_main then
            gui_elements.group_flow_main.style.visible = show_details
        end
        if gui_elements.group_flow_columns then
            gui_elements.group_flow_columns.style.visible = show_details
        end
        if gui_elements.group_flow_debug then
            gui_elements.group_flow_debug.style.visible = show_details
        end
        local data_table = gui_elements.data_table
        if data_table then
            local elapsed_time = math.floor(game.tick / 60)
            for key, fluid_data in pairs(global.faucet_data.force_stats[force_name].total_fluids) do
                if elapsed_ticks >= 60 then
                    local tick_ratio = 60 / elapsed_ticks
                    fluid_data.per_second = (fluid_data.total - fluid_data.previous_total) * tick_ratio
                    fluid_data.previous_total = fluid_data.total

                    fluid_data.pollution_per_second = (fluid_data.total_pollution - fluid_data.previous_pollution) * tick_ratio
                    fluid_data.previous_pollution = fluid_data.total_pollution

                    global.faucet_data.force_stats[player.force.name].last_stat_tick = game.tick
                end

                local visible = true

                if fluid_data.per_second > 0 then
                    fluid_data.active = true
                else
                    fluid_data.active = false
                    if not global.faucet_data.force_stats[player.force.name].settings.show_inactive then
                        visible = false
                    end
                end

                if global.faucet_data.force_stats[player.force.name].fluid_filter ~= nil then
                    visible = false
                    if global.faucet_data.force_stats[player.force.name].fluid_filter == key then
                        visible = true
                    end
                end

                if data_table["sprite_cell_flow_" .. key] then
                    local total = math.floor(fluid_data.total)
                    local total_pollution = math.floor(fluid_data.total_pollution)
                    local per_second = math.floor(fluid_data.per_second)
                    local pollution_per_second = math.floor(fluid_data.pollution_per_second)
                    if per_second and per_second ~= math.huge then
                        per_second = jazziebgd.lib.format_num_unit(per_second, true) .. "/s"
                    else
                        per_second = ""
                    end
                    if pollution_per_second and pollution_per_second ~= math.huge then
                        pollution_per_second = jazziebgd.lib.format_num_unit(pollution_per_second, true) .. "/s"
                    else
                        pollution_per_second = ""
                    end
                    local color = {r = 1, g = 1, b = 1, a = 0.6}
                    if fluid_data.active then
                        color = {r = 1, g = 1, b = 1, a = 1}
                    end

                    local labels = gui_elements.fluid_data_elements[key]
                    if labels.sprite then
                        labels.sprite.style.visible = visible
                    end
                    if labels.total_label then
                        labels.total_label.caption = jazziebgd.lib.format_num_unit(total, true)
                        labels.total_label.tooltip = jazziebgd.lib.format_num(total, true)
                        labels.total_label.style.font_color = color
                        labels.total_label.style.visible = visible
                    end
                    if labels.per_second_label then
                        labels.per_second_label.caption = per_second
                        labels.per_second_label.style.font_color = color
                        labels.per_second_label.style.visible = visible
                    end
                    if labels.total_pollution_label then
                        labels.total_pollution_label.caption = jazziebgd.lib.format_num_unit(total_pollution, true)
                        labels.total_pollution_label.tooltip = jazziebgd.lib.format_num(total_pollution, true)
                        labels.total_pollution_label.style.font_color = color
                        labels.total_pollution_label.style.visible = visible
                    end
                    if labels.pollution_per_second_label then
                        labels.pollution_per_second_label.caption = pollution_per_second
                        labels.pollution_per_second_label.style.font_color = color
                        labels.pollution_per_second_label.style.visible = visible
                    end
                else
                    add_info_data_fluid_row(player, data_table, key, fluid_data)
                end
            end
        end
    end
end


function add_info_data_fluid_row(player, data_table, key, fluid_data)
    local total = math.floor(fluid_data.total)
    local per_second = math.floor(fluid_data.per_second)
    local total_pollution = fluid_data.total_pollution
    local pollution_per_second = math.floor(fluid_data.pollution_per_second)

    if per_second and per_second ~= math.huge then
        per_second = jazziebgd.lib.format_num_unit(per_second, true) .. "/s"
    else
        per_second = ""
    end

    if pollution_per_second and pollution_per_second ~= math.huge then
        pollution_per_second = jazziebgd.lib.format_num_unit(pollution_per_second, true) .. "/s"
    else
        pollution_per_second = ""
    end

    local label_style_extension = {
        font_color = {r = 1, g = 1, b = 1, a = 0.6}
    }
    if fluid_data.per_second > 0 then
        label_style_extension.font_color = {r = 1, g = 1, b = 1, a = 1}
    end

    local columns = get_mod_column_setting_names()
    local settings = global.faucet_data.force_stats[player.force.name].settings

    local visible = true
    if global.faucet_data.force_stats[player.force.name].fluid_filter ~= nil then
        visible = false
        if global.faucet_data.force_stats[player.force.name].fluid_filter == key then
            visible = true
        end
    end

    label_style_extension.visible = visible

    gui_elements.fluid_data_elements[key] = {}

    local sprite_cell_flow = create_flow(data_table, "sprite_cell_flow_" .. key, "horizontal", "faucet_flow_style", {align = "center"})
    local fluid_sprite = sprite_cell_flow.add({type = "sprite", name = "fluid_sprite", sprite="fluid/" .. key, tooltip={"fluid-name." .. key}})
    fluid_sprite.style.visible = visible
    gui_elements.fluid_data_elements[key].sprite = fluid_sprite

    if settings["show_evaporated"] then
        local total_cell_flow = create_flow(data_table, "total_cell_flow_" .. key, "horizontal", "faucet_data_cell_right_flow_style")
        local total_label = create_label(total_cell_flow, "label", jazziebgd.lib.format_num_unit(total, true), nil, "faucet_label_style", label_style_extension)
        gui_elements.fluid_data_elements[key].total_label = total_label
    end

    if settings["show_evaporated_per_second"] then
        local per_sec_cell_flow = create_flow(data_table, "per_sec_cell_flow_" .. key, "horizontal", "faucet_data_cell_right_flow_style")
        local per_sec_label = create_label(per_sec_cell_flow, "label", per_second, nil, "faucet_label_style", label_style_extension)
        gui_elements.fluid_data_elements[key].per_second_label = per_sec_label
    end

    if settings["show_pollution"] then
        local total_pollution_cell_flow = create_flow(data_table, "total_pollution_cell_flow_" .. key, "horizontal", "faucet_data_cell_right_flow_style")
        local total_pollution_label = create_label(total_pollution_cell_flow, "label", jazziebgd.lib.format_num_unit(total_pollution, true), nil, "faucet_label_style", label_style_extension)
        gui_elements.fluid_data_elements[key].total_pollution_label = total_pollution_label
    end

    if settings["show_pollution_per_second"] then
        local pollution_per_sec_cell_flow = create_flow(data_table, "pollution_per_sec_cell_flow_" .. key, "horizontal", "faucet_data_cell_right_flow_style")
        local pollution_per_sec_label = create_label(pollution_per_sec_cell_flow, "label", pollution_per_second, nil, "faucet_label_style", label_style_extension)
        gui_elements.fluid_data_elements[key].pollution_per_second_label = pollution_per_sec_label
    end
end

function toggle_info_settings(player)
    local visible
    if not gui_elements.settings_flow then
        detect_gui_elements(player)
    end
    if gui_elements.settings_flow then
        if gui_elements.settings_flow.style.visible then
            visible = false
        else
            visible = true
        end
    end
    set_player_setting(player, "show_settings", visible)
    gui_elements.settings_flow.style.visible = visible
    if visible then
        gui_elements.settings_button.style = "faucet_settings_button_style"
    else
        gui_elements.settings_button.style = "faucet_settings_inactive_button_style"
    end
end


function toggle_info_details(player)
    local visible
    if not gui_elements.details_flow then
        detect_gui_elements(player)
    end
    if gui_elements.details_flow then
        if gui_elements.details_flow.style.visible then
            visible = false
        else
            visible = true
        end
    end
    set_player_setting(player, "show_details", visible)
    gui_elements.details_flow.style.visible = visible
    if visible then
        gui_elements.details_button.style = "faucet_eye_button_style"
        if gui_elements.settings_button then
            gui_elements.settings_button.style.visible = true
        end
        if gui_elements.group_flow_columns then
            gui_elements.group_flow_columns.style.visible = true
        end
        if gui_elements.group_flow_main then
            gui_elements.group_flow_main.style.visible = true
        end
        if gui_elements.group_flow_debug then
            gui_elements.group_flow_debug.style.visible = true
        end
    else
        gui_elements.details_button.style = "faucet_eye_inactive_button_style"
        if gui_elements.settings_button then
            gui_elements.settings_button.style.visible = false
        end
        if gui_elements.group_flow_columns then
            gui_elements.group_flow_columns.style.visible = false
        end
        if gui_elements.group_flow_main then
            gui_elements.group_flow_main.style.visible = false
        end
        if gui_elements.group_flow_debug then
            gui_elements.group_flow_debug.style.visible = false
        end
    end
end


function is_gui_info_frame_displayed(player)
    if player.gui.left.faucet_info then
        return true
    else
        return false
    end
end


function toggle_gui_info_frame(player)
    local info_frame = player.gui.left.faucet_info
    if info_frame then
        info_frame.destroy()
    else
        show_gui_info_frame(player)
    end
end


function hide_gui_info_frame(player)
    local info_frame = player.gui.left.faucet_info
    if info_frame then
        info_frame.destroy()
        reset_gui_elements()
    end
end

function refresh_statistics(player)
    if player and player.connected and is_gui_info_frame_displayed(player) then
        refresh_gui_info_frame_data(player)
        refresh_info_data(player)
    end
end

function refresh_all_statistics()
    for _, player in pairs(game.players) do
        refresh_statistics(player)
    end
end

function update_fluid_filter_gui(player)
    local filter = global.faucet_data.force_stats[player.force.name].fluid_filter
    if filter == nil then
        if gui_elements.reset_fluid_filter_button then
            gui_elements.reset_fluid_filter_button.style.visible = false
        end
        if gui_elements.fluid_filter_label then
            gui_elements.fluid_filter_label.style.visible = true
        end
        if gui_elements.fluid_filter_button then
            gui_elements.fluid_filter_button.elem_value = nil
        end
    else
        if gui_elements.reset_fluid_filter_button then
            gui_elements.reset_fluid_filter_button.style.visible = true
        end
        if gui_elements.fluid_filter_label then
            gui_elements.fluid_filter_label.style.visible = false
        end
    end
end
