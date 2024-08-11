local blocks_tick = require 'bitwise:util/blocks_tick'
local signals = require "bitwise:logic/signals"
local metadata = require "bitwise:util/metadata"
local state_api = require "bitwise:logic/state_api"
local direction = require "bitwise:util/direction"
local source = { __index = require 'bitwise:logic/element'}
setmetatable(source, source)

function on_broken(x, y, z)
    blocks_tick.remove_block(x, y, z)

    source:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    source:placed(x, y, z)

    local fx, fy, fz = direction.get_front_block(x, y, z)
    signals.impulse(fx, fy, fz, state_api.is_active(x, y, z))

    blocks_tick.add_block(x, y, z)
end

function on_interact(x, y, z)
    state_api.switch(x, y, z)

    local fx, fy, fz = direction.get_front_block(x, y, z)
    signals.impulse(fx, fy, fz, state_api.is_active(x, y, z))
    return true
end

blocks_tick.register(function(x, y, z) source:tick(x, y, z) end, "bitwise:source_on", "bitwise:source_off")