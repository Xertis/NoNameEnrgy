local blocks_tick = require 'bitwise:blocks_tick'
local arrow = require 'bitwise:logic/arrow'

function on_broken(x, y, z)
    blocks_tick.remove_block(x, y, z)

    arrow.broken(x, y, z)
end

function on_placed(x, y, z)
    arrow.placed(x, y, z)

    blocks_tick.add_block(x, y, z)
end

blocks_tick.register(arrow.tick, "bitwise:wire_off", "bitwise:wire_on")