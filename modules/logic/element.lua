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

    if not signals.can_disable(x, y, z) then
        signals.impulse(x, y, z, true)
    end
end

function element:broken(x, y, z)
    x, y, z = direction.get_front_block(x, y, z)

    signals.impulse(x, y, z, false)
end

setmetatable(element, element)

return element