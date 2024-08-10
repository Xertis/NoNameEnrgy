local state_api = require "bitwise:logic/state_api"
local blocks_tick = require "bitwise:util/blocks_tick"
local metadata = require "bitwise:util/metadata"

local arrow = { }

local function getFrontBlock(x, y, z,  mul)
    mul = mul or 1

    local rx, ry, rz = 0, 0, 0

    if block.get(x, y, z) == 0 then
        local front = metadata.blocks.get_property(x, y, z, "frontBlock")

        if front then rx, ry, rz = unpack(front) end
    else
        rx, ry, rz = block.get_Y(x, y, z)
    end

    return x + rx * mul, y + ry * mul, z + rz * mul
end

local neighbors =
{
    { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 },
    { -1, 0, 0  }, { 0, -1, 0 }, { 0, 0, -1 }
}

local function canDisable(x, y, z)
    for _, pos in ipairs(neighbors) do
        local nx, ny, nz = pos[1] + x, pos[2] + y, pos[3] + z

        if block.get(nx, ny, nz) ~= 0 then
            local fx, fy, fz = getFrontBlock(nx, ny, nz)

            if fx == x and fy == y and fz == z and state_api.is_active(nx, ny, nz) then return false end 
        end
    end

    return true
end

function arrow.interact(x, y, z)
    arrow.impulse(x, y, z, not state_api.is_active(x, y, z))

    return true
end

function arrow.tick(x, y, z)
    local impulseType = metadata.blocks.get_property(x, y, z, "impulse")

    if impulseType ~= nil then
        arrow.impulse(x, y, z, impulseType)
    end
end

function arrow.placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })

    local bx, by, bz = getFrontBlock(x, y, z, -1)

    arrow.impulse(x, y, z, state_api.is_active(bx, by, bz))
end

function arrow.broken(x, y, z)
    x, y, z = getFrontBlock(x, y, z)

    arrow.impulse(x, y, z, false)
end

function arrow.impulse(x, y, z, type)
    if
    (state_api.is_active(x, y, z) == type) or
    (type == false and not canDisable(x, y, z)) or
    not state_api.set_active(x, y, z, type)
    then return false end

    metadata.blocks.set_property(x, y, z, "impulse", nil)

    x, y, z = getFrontBlock(x, y, z)

    metadata.blocks.set_property(x, y, z, "impulse", type)
    
    return true
end

return arrow