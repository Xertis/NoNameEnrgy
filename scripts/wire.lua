local blocks_tick = require 'bitwise:blocks_tick'
local arrow = require 'bitwise:logic/arrow'

on_broken = arrow.broken

on_placed = arrow.placed

on_tick = arrow.tick

blocks_tick.register("bitwise:wire_off", "bitwise:wire_on")