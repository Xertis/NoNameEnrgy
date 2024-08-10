local blocks_tick = require 'bitwise:blocks_tick'
local arrow = require 'bitwise:logic/arrow'

blocks_tick.reg_func("bitwise:wire_off", function (x, y, z)
    block.set(x, y+1, z, 1, 1)
end)

on_broken = arrow.broken

on_placed = arrow.placed

on_tick = arrow.tick

blocks_tick.register("bitwise:wire_off", "bitwise:wire_on")