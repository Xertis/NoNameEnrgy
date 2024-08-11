local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local and_e = { __index = require 'bitwise:logic/element' }

setmetatable(and_e, and_e)

function and_e:update(x, y, z)
    local fx, fy, fz = direction.get_front_block(x, y, z)

    local sx, sy, sz = direction.get_side_block(x, y, z)
    local sx2, sy2, sz2 = direction.get_side_block(x, y, z, -1)

    local active1 = state_api.is_active(sx, sy, sz)
    local active2 = state_api.is_active(sx2, sy2, sz2)

    local active = false
    if active1 == true and active2 == true then
        active = true
    end
    
    if state_api.is_active(x, y, z) ~= active then
        state_api.set_active(x, y, z, active)
        signals.impulse(fx, fy, fz, active)
    end
    print(active1, active2)

end

function and_e:placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    self:update(x, y, z)
end

return and_e