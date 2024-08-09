local blocks_tick = require 'bitwise:blocks_tick'

function on_world_tick(tps)
    blocks_tick.tick()
end

function on_world_save()
    blocks_tick.save()
end

function on_world_open()
    blocks_tick.load()
end