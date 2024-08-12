local blocks_tick = require 'bitwise:util/blocks_tick'
local metadata = require "bitwise:util/metadata"

function on_world_tick(tps)
    blocks_tick.tick()
end

function on_world_save()
    metadata.save()
    blocks_tick.save()
end

function on_world_open()
    metadata.load()
    blocks_tick.load()
end