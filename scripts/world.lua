local blocks_tick = require 'bitwise:blocks_tick'

function on_world_tick(tps)
    blocks_tick.tick()
end