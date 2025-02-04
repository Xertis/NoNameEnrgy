local metadata = require "bitwise:util/metadata"

local state_api = { }

local enabledPostfix, disabledPostfix = "_on", "_off"

local prefixs = {
    "15",
    "14",
    "13",
    "12",
    "11",
    "10",
    "9",
    "8",
    "7",
    "6",
    "5",
    "4",
    "3",
    "2",
    "1",
    "0",
    "on",
    "off"
}

local function isActiveByNameHex(name)
    for _, prefix in ipairs(prefixs) do
        if string.ends_with(name, prefix) then
            if prefix == "on" then
                prefix = "1"
            elseif prefix == "off" then
                prefix = "0"
            end

            return tonumber(prefix)
        end
    end
end

local function isActiveByName(name)
    for i, prefix in ipairs(prefixs) do
        if string.ends_with(name, prefix) then
            return ((i-1) % 2 == 0)
        end
    end
end

local function changeActiveByName(name, value)
    return name:sub(1, name:match(".*()_") - 1) .. "_" .. value
end

function state_api.is_active_hex(x, y, z)
    local active = isActiveByNameHex(block.name(block.get(x, y, z))) or metadata.blocks.get_property(x, y, z, "impulse") or 0

    if type(active)[1] == 'n' then
        return active
    end

    if type(active)[1] == 'b' then
        active = active and 1 or 0
    end
    return active
end

function state_api.is_active(x, y, z)
    local active = isActiveByName(block.name(block.get(x, y, z)))
    if active ~= nil then
        return active
    end

    return metadata.blocks.get_property(x, y, z, "impulse") or false
end

function state_api.set_active(x, y, z, state)
    local name = block.name(block.get(x, y, z))

    if name == "core:air" then return false end

    if type(state)[1] == "b" and name:find("hex") then
        state = state and "1" or "0"
    elseif type(state)[1] == "n" and not name:find("hex") then
        state = not (state % 2 == 0)
        state = state and "on" or "off"
    elseif type(state)[1] == "b" then
        state = state and "on" or "off"
    end

    state = tostring(state)

    local new_name = changeActiveByName(name, state)
    if block.index(new_name) == nil then
        block.set(x, y, z, block.index(name), block.get_states(x, y, z))
        return true
    end

    block.set(x, y, z, block.index(new_name), block.get_states(x, y, z))

    return true
end

function state_api.switch(x, y, z)
    state_api.set_active(x, y, z, not state_api.is_active(x, y, z))
end

return state_api