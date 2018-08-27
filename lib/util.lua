if not jazziebgd then
    jazziebgd = {}
end
if not jazziebgd.lib then
    jazziebgd.lib = {}
end

if not mod_config then
    mod_config = {}
end

if not mod_config.debug_active then
    mod_config.debug_active = false
end
if not mod_config.log_to_file then
    mod_config.log_to_file = false
end

if mod_config.debug_level == nil then
    mod_config.debug_level = 3
end


function jazziebgd.lib.array_has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function jazziebgd.lib.array_has_key (tab, key)
    for index, value in pairs(tab) do
        if index == key then
            return true
        end
    end
    return false
end

function jazziebgd.lib.find_index_by_name(tab, name)
    for index, value in pairs(tab) do
        if value.name == name then
            return index
        end
    end
    return -1
end

function jazziebgd.lib.merge(table1, table2)
    for key, value in ipairs(table2) do
        table.insert(table1, value)
    end
end



-- credit http://richard.warburton.it
function jazziebgd.lib.format_num(n, as_int)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    local formatted = left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())
    if not as_int then
        formatted = formatted..right
    end
    return formatted
end

function jazziebgd.lib.format_num_unit(n, as_int)
    local unit = ""
    if (n > 100000000000) then
        unit = "G"
        n = n / 1000000000
    elseif (n > 100000000) then
        unit = "M"
        n = n / 1000000
    elseif (n > 100000) then
        unit = "k"
        n = n / 1000
    end
    return jazziebgd.lib.format_num(n, as_int) .. unit
end

function jazziebgd.lib.get_log_file_name()
    return script.mod_name .. "-log.txt"
end

function jazziebgd.lib.is_number(value)
    local number = tonumber(value)
    local is_num = true
    if number == nil or tostring(number) == "nan" or tostring(number) == "inf" then
        is_num = false
    end
    return is_num
end





function jazziebgd.lib.message(player, message, color)
    if not color then
        color = {r = 1, g = 1, b = 1, a = 1}
    end
    if player.connected then
        player.print(message, color)
    end
end

function jazziebgd.lib.verbose(...)
    if not mod_config.debug_level or mod_config.debug_level > 1 then
        return
    end
    local line = jazziebgd.lib.get_log_line(...)
    jazziebgd.lib.do_log(line)
end

function jazziebgd.lib.debug(...)
    if not mod_config.debug_level or mod_config.debug_level > 2 then
        return
    end
    local line = jazziebgd.lib.get_log_line(...)
    jazziebgd.lib.do_log(line, {r = 0.7, g = 0.7, b = 0.7, a = 1})
end

function jazziebgd.lib.info(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_line(...)
    jazziebgd.lib.do_log(line, {r = 0.7, g = 1, b = 0.7, a = 1})
end

function jazziebgd.lib.warning(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_line(...)
    jazziebgd.lib.do_log(line, {r = 1, g = 0.8, b = 0.3, a = 1})
end

function jazziebgd.lib.error(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_line(...)
    jazziebgd.lib.do_log(line, {r = 1, g = 0.5, b = 0.5, a = 1})
end



function jazziebgd.lib.verbose_player(...)
    if not mod_config.debug_level or mod_config.debug_level > 1 then
        return
    end
    local line = jazziebgd.lib.get_log_player_line(...)
    local player = jazziebgd.lib.get_log_player(...)
    jazziebgd.lib.do_log_player(player, line)
end

function jazziebgd.lib.debug_player(...)
    if not mod_config.debug_level or mod_config.debug_level > 2 then
        return
    end
    local line = jazziebgd.lib.get_log_player_line(...)
    local player = jazziebgd.lib.get_log_player(...)
    jazziebgd.lib.do_log_player(player, line, {r = 0.7, g = 0.7, b = 0.7, a = 1})
end

function jazziebgd.lib.info_player(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_player_line(...)
    local player = jazziebgd.lib.get_log_player(...)
    jazziebgd.lib.do_log_player(player, line, {r = 0.7, g = 1, b = 0.7, a = 1})
end

function jazziebgd.lib.warning_player(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_player_line(...)
    local player = jazziebgd.lib.get_log_player(...)
    jazziebgd.lib.do_log_player(player, line, {r = 1, g = 0.8, b = 0.3, a = 1})
end

function jazziebgd.lib.error_player(...)
    if not mod_config.debug_level or mod_config.debug_level > 3 then
        return
    end
    local line = jazziebgd.lib.get_log_player_line(...)
    local player = jazziebgd.lib.get_log_player(...)
    jazziebgd.lib.do_log_player(player, line, {r = 1, g = 0.5, b = 0.5, a = 1})
end




function jazziebgd.lib.get_log_line(...)
    local line = ""
    for index, value in ipairs({...}) do
        line = line .. tostring(value)
    end
    return line
end

function jazziebgd.lib.get_log_player_line(...)
    local line = ""
    for index, value in ipairs({...}) do
        if index > 1 then
            line = line .. tostring(value)
        end
    end
    return line
end

function jazziebgd.lib.get_log_player(...)
    local player
    for index, value in ipairs({...}) do
        if index == 1 then
            player = value
        end
    end
    return player
end

function jazziebgd.lib.do_log_player(player, line, color)
    if game and game.tick then
        if mod_config.log_to_file then
            local file_line = script.mod_name .. "(" .. game.tick .. "): " .. line .. "\n"
            game.write_file(jazziebgd.lib.get_log_file_name(), file_line, true )
        end
        jazziebgd.lib.message(player, line, color)
    end
end

function jazziebgd.lib.do_log(line, color)
    if game and game.tick then
        if mod_config.log_to_file then
            local file_line = script.mod_name .. "(" .. game.tick .. "): " .. line .. "\n"
            game.write_file(jazziebgd.lib.get_log_file_name(), file_line, true )
        end

        for _, player in pairs(game.players) do
            jazziebgd.lib.message(player, line, color)
        end
    end
end

function jazziebgd.lib.clear_log()
    game.remove_path(jazziebgd.lib.get_log_file_name())
    for _, player in pairs(game.players) do
        if player.connected then
            player.clear_console()
        end
    end
end


function _log_empty()
end

if mod_config.debug_active then
    log_verbose = jazziebgd.lib.verbose
    log_debug = jazziebgd.lib.debug
    log_info = jazziebgd.lib.info
    log_warning = jazziebgd.lib.warning
    log_error = jazziebgd.lib.error

    log_verbose_player = jazziebgd.lib.verbose_player
    log_debug_player = jazziebgd.lib.debug_player
    log_info_player = jazziebgd.lib.info_player
    log_warning_player = jazziebgd.lib.warning_player
    log_error_player = jazziebgd.lib.error_player
else
    log_verbose = _log_empty
    log_debug = _log_empty
    log_info = _log_empty
    log_warning = _log_empty
    log_error = _log_empty

    log_verbose_player = _log_empty
    log_debug_player = _log_empty
    log_info_player = _log_empty
    log_warning_player = _log_empty
    log_error_player = _log_empty
end

log_message = jazziebgd.lib.message