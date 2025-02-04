local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local pattern = { __index = require 'bitwise:logic/element_hex' }

setmetatable(pattern, pattern)

function pattern:update(x, y, z, func)
    local fx, fy, fz = direction.get_front_block(x, y, z)
    local bx, by, bz = direction.get_front_block(x, y, z, -1)

    local sx, sy, sz = direction.get_side_block(x, y, z)
    local sx2, sy2, sz2 = direction.get_side_block(x, y, z, -1)

    local active1 = state_api.is_active_hex(sx, sy, sz)
    local active2 = state_api.is_active_hex(sx2, sy2, sz2)
    local active3 = state_api.is_active_hex(bx, by, bz)

    local active = func(active1, active2, active3, state_api.is_active_hex(x, y, z), {x, y, z})

    if state_api.is_active_hex(x, y, z) ~= active and active ~= nil then
        state_api.set_active(x, y, z, active)
    end

end

function pattern:placed(x, y, z, func)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    self:update(x, y, z, func)
end

return pattern