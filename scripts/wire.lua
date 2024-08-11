local blocks_tick = require 'bitwise:util/blocks_tick'
local signals = require "bitwise:logic/signals"
local metadata = require "bitwise:util/metadata"
local state_api = require "bitwise:logic/state_api"
local wire = { __index = require 'bitwise:logic/element' }

setmetatable(wire, wire)

function on_broken(x, y, z)
    blocks_tick.remove_block(x, y, z)

    wire:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    wire:placed(x, y, z)

    blocks_tick.add_block(x, y, z)
end

blocks_tick.register(function(x, y, z) wire:tick(x, y, z) end, "bitwise:wire_off", "bitwise:wire_on")