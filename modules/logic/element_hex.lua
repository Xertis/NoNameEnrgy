local signals = require "bitwise:logic/signals"
local direction = require "bitwise:util/direction"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"

local element = { }

function element:tick(x, y, z)
    local impulseType = metadata.blocks.get_property(x, y, z, "impulse")

    if impulseType ~= nil then
        signals.impulse_hex(x, y, z, impulseType, false, "ОН" .. tostring(z))
    end
end

function element:placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    if not signals.can_disable(x, y, z, true) then
        local active = signals.signals_hex_max(x, y, z)
        metadata.blocks.set_property(x, y, z, "impulse", active)
        signals.impulse_hex(x, y, z, active, false, 'ИЛИ ОН')
    end
end

function element:broken(x, y, z)
    x, y, z = direction.get_front_block(x, y, z)

    signals.impulse_hex(x, y, z, 0)
end

setmetatable(element, element)

return element