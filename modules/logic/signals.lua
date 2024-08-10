local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local signals = { }

local neighbors =
{
    { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 },
    { -1, 0, 0  }, { 0, -1, 0 }, { 0, 0, -1 }
}

local function canDisable(x, y, z)
    for _, pos in ipairs(neighbors) do
        local nx, ny, nz = pos[1] + x, pos[2] + y, pos[3] + z

        if block.get(nx, ny, nz) ~= 0 then
            local fx, fy, fz = direction.get_front_block(nx, ny, nz)

            if fx == x and fy == y and fz == z and state_api.is_active(nx, ny, nz) then return false end 
        end
    end

    return true
end

function signals.impulse(x, y, z, type)
    if
    not string.starts_with(block.name(block.get(x, y, z)), "bitwise:wire") or
    (state_api.is_active(x, y, z) == type) or
    (type == false and not canDisable(x, y, z)) or
    not state_api.set_active(x, y, z, type)
    then return false end

    metadata.blocks.set_property(x, y, z, "impulse", nil)

    x, y, z = direction.get_front_block(x, y, z)

    if string.starts_with(block.name(block.get(x, y, z)), "bitwise:wire") then
        metadata.blocks.set_property(x, y, z, "impulse", type)
    end
    
    return true
end

return signals