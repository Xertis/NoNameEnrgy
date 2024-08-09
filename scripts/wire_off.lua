local blocks_tick = require 'bitwise:blocks_tick'

blocks_tick.reg_func("bitwise:wire_off", function (x, y, z)
    block.set(x, y+1, z, 1, 1)
end)

function on_broken(x, y, z)
    blocks_tick.unreg(x, y, z)
end

function on_placed(x, y, z)
    blocks_tick.reg(x, y, z)
end
