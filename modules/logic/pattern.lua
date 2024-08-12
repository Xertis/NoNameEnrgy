local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local pattern = { __index = require 'bitwise:logic/element' }

setmetatable(pattern, pattern)

function pattern:update(x, y, z, func)
    local fx, fy, fz = direction.get_front_block(x, y, z)

    local sx, sy, sz = direction.get_side_block(x, y, z)
    local sx2, sy2, sz2 = direction.get_side_block(x, y, z, -1)

    local active1 = state_api.is_active(sx, sy, sz)
    local active2 = state_api.is_active(sx2, sy2, sz2)

    local active = func(active1, active2)

    if state_api.is_active(x, y, z) ~= active then
        state_api.set_active(x, y, z, active)
        signals.impulse(fx, fy, fz, active)
    end

end

function pattern:placed(x, y, z, func)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    self:update(x, y, z, func)
end

return pattern