local command_data = {
    faucet_help = "List available mod commands",
    faucet_refresh_force_globals = "Resets force globals (evaporation statistics etc.)",
    faucet_rebuild_top_gui = "Rebuilds top GUI for all forces",
    faucet_log_stats = "Logs current force stats",
    faucet_log_settings = "Logs current mod settings",
    faucet_reset_settings = "Resets current player mod settings",
    faucet_prepare_blueprint = "Prepares player, terrain and adds blueprint for mod testing (intended for dev use)",
    faucet_prepare = "Prepares player, terrain and builds basic base for mod testing (intended for dev use)",
    faucet_statistics_add_evaporated = "Adds value from parameter to total evaporated statistic (intended for dev use)",
    faucet_statistics_add_pollution = "Adds value from parameter to total pollution statistic (intended for dev use)",
    faucet_gui = "Logs mod gui info (intended for dev use)",
    faucet_debug = "Toggle debug mode (intended for dev use)",
}

local command_methods = {
    faucet_help = function(parameters)
        game.print("List of commands:")
        for name, geko in pairs(command_data) do
            game.print(name)
        end
    end,
    faucet_prepare_blueprint = function(parameters)
        prepare_terrain_blueprint(game.players[parameters["player_index"]])
    end,
    faucet_prepare = function(parameters)
        prepare_terrain(game.players[parameters["player_index"]])
    end,
    faucet_log_settings = function(parameters)
        log_mod_settings(game.players[parameters["player_index"]])
    end,
    faucet_reset_settings = function(parameters)
        local reset_all = false
        if parameters.parameter and jazziebgd.lib.is_number(parameters.parameter) then
            if tonumber(parameters.parameter) > 0 then
                reset_all = true
            end
        end
        reset_settings(game.players[parameters["player_index"]], reset_all)
    end,
    faucet_gui = function(parameters)
        print_gui_structure(game.players[parameters["player_index"]].gui.left)
    end,
    faucet_debug = function(parameters)
        if mod_config.debug_active then
            mod_config.debug_active = false
        else
            mod_config.debug_active = true
        end
    end,
    faucet_refresh_force_globals = function(parameters)
        local player = game.players[parameters["player_index"]]
        refresh_force_globals(player)
    end,
    faucet_rebuild_top_gui = function()
        rebuild_top_gui()
    end,
    faucet_statistics_add_evaporated = function(parameters)
        local player = game.players[parameters["player_index"]]
        local quantity = 0
        if parameters.parameter and jazziebgd.lib.is_number(parameters.parameter) then
            quantity = tonumber(parameters.parameter)
        end

        if quantity > 0 then
            log_info("Adding ".. quantity .. " to total evaporation")
            global.faucet_data.force_stats[player.force.name].total_evaporation = global.faucet_data.force_stats[player.force.name].total_evaporation + quantity
        else
            log_info("Parameter either zero or absent, statistics unchanged")
        end
    end,
    faucet_statistics_add_pollution = function(parameters)
        local player = game.players[parameters["player_index"]]
        local quantity = 0
        if parameters.parameter and jazziebgd.lib.is_number(parameters.parameter) then
            quantity = tonumber(parameters.parameter)
        end

        if quantity > 0 then
            log_info("Adding ".. quantity .. " to total pollution")
            global.faucet_data.force_stats[player.force.name].total_pollution = global.faucet_data.force_stats[player.force.name].total_pollution + quantity
        else
            log_info("Parameter either zero or absent, statistics unchanged")
        end
    end,
    faucet_log_stats = function(parameters)
        local player = game.players[parameters["player_index"]]
        log_info_player(player, serpent.block(global.faucet_data.force_stats[player.force.name]))
    end,
}

function get_command_data()
    return command_data
end

function get_command_methods()
    return command_methods
end