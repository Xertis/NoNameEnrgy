local blocks_tick = require 'bitwise:util/blocks_tick'
local metadata = require "bitwise:util/metadata"
local t = 0
function on_world_tick(tps)
    if t == 0 then
        blocks_tick.tick()
        t = 0
    else
        t = t + 1
    end
end

function on_world_save()
    metadata.save()
    blocks_tick.save()
end

function on_world_open()
    metadata.load()
    blocks_tick.load()
end