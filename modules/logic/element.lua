local signals = require "bitwise:logic/signals"
local direction = require "bitwise:util/direction"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"

local element = { }

function element:tick(x, y, z)
    local impulseType = metadata.blocks.get_property(x, y, z, "impulse")

    if impulseType ~= nil then
        signals.impulse(x, y, z, impulseType)
    end
end

function element:placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })

    local bx, by, bz = direction.get_front_block(x, y, z, -1)
    local fx, fy, fz = direction.get_front_block(bx, by, bz)

    if fx == x and fy == y and fz == z and string.starts_with(block.name(block.get(x, y, z)), "bitwise:wire") then
        signals.impulse(x, y, z, state_api.is_active(bx, by, bz))
    end
end

function element:broken(x, y, z)
    x, y, z = direction.get_front_block(x, y, z)

    signals.impulse(x, y, z, false)
end

setmetatable(element, element)

return element