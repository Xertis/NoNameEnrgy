local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local invertor = { __index = require 'bitwise:logic/element' }

setmetatable(invertor, invertor)

function invertor:update(x, y, z)
    local bx, by, bz = direction.get_front_block(x, y, z, -1)
    local fx, fy, fz = direction.get_front_block(x, y, z)
    local active = not state_api.is_active(bx, by, bz)

    if state_api.is_active(x, y, z) ~= active then state_api.set_active(x, y, z, active) end

    signals.impulse(fx, fy, fz, active)
end

function invertor:placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    self:update(x, y, z)
end

return invertor