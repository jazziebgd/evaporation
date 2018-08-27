function print_gui_structure(root)
    local structure = get_gui_structure(root)
    log_info(serpent.block(structure))
end

function get_gui_structure(root)
    local root_name = root.name
    local structure = {
        base_name = root_name,
    }
    if root.children and #root.children > 0 then
        structure.children = {}
        for _, child in ipairs(root.children) do
            structure.children[_] = get_gui_structure(root[child.name])

        end
    end
    return structure
end

function find_gui_element_by_name(name, root)
    local gui_element
    if root.name == name then
        gui_element = root
    else
        if root.children and #root.children > 0 then
            for _, child in ipairs(root.children) do
                if not gui_element then
                    gui_element = find_gui_element_by_name(name, root[child.name])
                end
            end
        end
    end
    return gui_element
end

function create_flow(parent, name, direction, style, style_extensions)
    if type(style_extensions) ~= "table" then
        style_extensions = {}
    end

    local flow = parent.add({type = "flow", name = name, direction = direction, style = style})
    for name, value in pairs(style_extensions) do
        flow.style[name] = value
    end
    return flow
end

function create_label(parent, name, caption, tooltip, style, style_extensions)
    if type(style_extensions) ~= "table" then
        style_extensions = {}
    end

    local label = parent.add({type = "label", name = name, caption = caption, tooltip = tooltip, style = style})
    for name, value in pairs(style_extensions) do
        label.style[name] = value
    end
    return label
end


function create_button(parent, name, caption, tooltip, style, style_extensions)
    if type(style_extensions) ~= "table" then
        style_extensions = {}
    end

    local button = parent.add({type = "button", name = name, caption=caption, tooltip = tooltip, style = style})
    for name, value in pairs(style_extensions) do
        button.style[name] = value
    end
    return button
end


function create_sprite(parent, name, sprite, tooltip, style, style_extensions)
    if type(style_extensions) ~= "table" then
        style_extensions = {}
    end

    local sprite = parent.add({type = "sprite", name = name, sprite=sprite, tooltip = tooltip, style=style})
    for name, value in pairs(style_extensions) do
        sprite.style[name] = value
    end
    return sprite
end

function create_spacer(parent, name, spacer_style, spacer_style_extensions, flow_style, flow_style_extensions)
    if type(flow_style_extensions) ~= "table" then
        flow_style_extensions = {}
    end
    if type(spacer_style_extensions) ~= "table" then
        spacer_style_extensions = {}
    end

    local spacer_flow = create_flow(parent, name .. "_flow", "horizontal", flow_style, flow_style_extensions)
    for name, value in pairs(flow_style_extensions) do
        spacer_flow.style[name] = value
    end
    local spacer = create_sprite(spacer_flow, name, spacer_style)
    for name, value in pairs(spacer_style_extensions) do
        spacer.style[name] = value
    end
    return spacer_flow
end