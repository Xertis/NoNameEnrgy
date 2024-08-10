local state_api = { }

local enabledPostfix, disabledPostfix = "_on", "_off"

function state_api.is_active(x, y, z)
    return string.ends_width(block.name(block.get(x, y, z)), enabledPostfix)
end

function state_api.set_active(x, y, z, state)
    local name = block.name(block.get(x, y, z))
    local postfix = state and enabledPostfix or disabledPostfix

    block.set(x, y, z, block.index(name:sub(1, #name - #postfix)), block.get_states(x, y, z))
end

function state_api.switch(x, y, z)
    state_api.set_active(x, y, z, not state_api.is_active(x, y, z))
end

return state_api