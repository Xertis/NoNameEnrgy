local signals = require "bitwise:logic/signals"
local metadata = require "bitwise:util/metadata"
local state_api = require "bitwise:logic/state_api"
local direction = require "bitwise:util/direction"

function on_broken(x, y, z)
    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    on_update(x, y, z)
end

function on_update(x, y, z)
    local fx, fy, fz = direction.get_front_block(x, y, z)

    local sx, sy, sz = direction.get_side_block(x, y, z)
    local sx2, sy2, sz2 = direction.get_side_block(x, y, z, -1)

    local active1 = state_api.is_active(sx, sy, sz)
    local active2 = state_api.is_active(sx2, sy2, sz2)

    local active = (active1 == true and active2 == false) or (active1 == false and active2 == true)

    if state_api.is_active(x, y, z) ~= active then
        state_api.set_active(x, y, z, active)
        signals.impulse(fx, fy, fz, active)
    end
end