local metadata = require "bitwise:util/metadata"

local state_api = { }

local enabledPostfix, disabledPostfix = "_on", "_off"

local function isActiveByName(name)
    return string.ends_with(name, enabledPostfix)
end

function state_api.is_active(x, y, z)
    return isActiveByName(block.name(block.get(x, y, z)))
end

function state_api.set_active(x, y, z, state)
    local name = block.name(block.get(x, y, z))

    if name == "core:air" then return false end

    local to = state and enabledPostfix or disabledPostfix
    local from = isActiveByName(name) and enabledPostfix or disabledPostfix

    block.set(x, y, z, block.index(name:sub(1, #name - #from)..to), block.get_states(x, y, z))

    return true
end

function state_api.switch(x, y, z)
    state_api.set_active(x, y, z, not state_api.is_active(x, y, z))
end

return state_api