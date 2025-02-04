local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local blocks_tick = require "bitwise:util/blocks_tick"
local direction = require "bitwise:util/direction"

local signals = { }

local neighbors =
{
    { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 },
    { -1, 0, 0  }, { 0, -1, 0 }, { 0, 0, -1 }
}

function signals.can_disable(x, y, z, is_hex)

    local is_active = is_hex and state_api.is_active_hex or state_api.is_active

    for _, pos in ipairs(neighbors) do
        local nx, ny, nz = pos[1] + x, pos[2] + y, pos[3] + z

        if block.get(nx, ny, nz) ~= 0 then
            local fx, fy, fz = direction.get_front_block(nx, ny, nz)

            local active = is_active(nx, ny, nz)

            if active == 0 then
                active = false
            end

            if fx == x and fy == y and fz == z and active then
                return false, nx, ny, nz
            end
        end
    end

    return true
end

function signals.signals_hex_max(x, y, z)

    local max = 0

    for _, pos in ipairs(neighbors) do
        local nx, ny, nz = pos[1] + x, pos[2] + y, pos[3] + z

        if block.get(nx, ny, nz) ~= 0 then
            local fx, fy, fz = direction.get_front_block(nx, ny, nz)

            if fx == x and fy == y and fz == z or block.name(block.get(nx, ny, nz)) == "bitwise:hex_coder" then
                local active = state_api.is_active_hex(nx, ny, nz)

                if active > max then
                    max = active
                end
            end
        end
    end
    return max
end

function signals.impulse(x, y, z, _type, is_block)
    blocks_tick.call_after_tick(function()
            if not is_block then
                if
                (state_api.is_active(x, y, z) == _type) or
                not string.starts_with(block.name(block.get(x, y, z)), "bitwise:wire") or
                (_type == false and not signals.can_disable(x, y, z)) or
                not state_api.set_active(x, y, z, _type)
                then return end

            end


            local ox, oy, oz = x, y, z

            if not is_block then
                metadata.blocks.set_property(x, y, z, "impulse", nil)
                x, y, z = direction.get_front_block(x, y, z)
            end

            local name = block.name(block.get(x, y, z))

            if string.starts_with(name, "bitwise:wire") and not name:find("hex") then
                metadata.blocks.set_property(x, y, z, "impulse", _type)
            elseif string.starts_with(name, "bitwise:wire") and name:find("hex") then
                signals.impulse_hex(ox, oy, oz, _type)
            end
        end
    )
end

function signals.impulse_hex(x, y, z, _type, is_block)
    local is_active = state_api.is_active_hex
    if type(_type)[1] == 'b' then
        _type = _type and 1 or 0
        is_active = state_api.is_active
    end

    blocks_tick.call_after_tick(function()
        if not is_block then
            if not string.starts_with(block.name(block.get(x, y, z)), "bitwise:wire") or
            (is_active(x, y, z) == _type) or
            (_type == 0 and not signals.can_disable(x, y, z, true)) or
            not state_api.set_active(x, y, z, _type)
            then
                return
            end
        end

        local ox, oy, oz = x, y, z

        if not is_block then
            metadata.blocks.set_property(x, y, z, "impulse", nil)
            x, y, z = direction.get_front_block(x, y, z)
        end

        local name = block.name(block.get(x, y, z))

        if (string.starts_with(name, "bitwise:wire") and name:find("hex")) or is_block then
            if state_api.is_active_hex(x, y, z) < _type then
                metadata.blocks.set_property(x, y, z, "impulse", _type)
            else
                local active = signals.signals_hex_max(x, y, z)
                metadata.blocks.set_property(x, y, z, "impulse", active)
            end
        elseif (string.starts_with(name, "bitwise:wire") and not name:find("hex")) then
            signals.impulse(ox, oy, oz, ((_type-1) % 2 == 0))
        end
    end)
end

return signals