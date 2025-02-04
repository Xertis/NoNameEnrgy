local blocks_tick = require 'bitwise:util/blocks_tick'
local signals = require "bitwise:logic/signals"
local metadata = require "bitwise:util/metadata"
local state_api = require "bitwise:logic/state_api"
local wire_hex = { __index = require 'bitwise:logic/element_hex' }

setmetatable(wire_hex, wire_hex)

function on_broken(x, y, z)
    blocks_tick.remove_block(x, y, z)

    wire_hex:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    wire_hex:placed(x, y, z)

    blocks_tick.add_block(x, y, z)
end

function on_update(x, y, z)
    --wire_hex:placed(x, y, z)
end

blocks_tick.register(
    function(x, y, z) wire_hex:tick(x, y, z) end,
    "bitwise:wire_hex_0",
    "bitwise:wire_hex_1",
    "bitwise:wire_hex_2",
    "bitwise:wire_hex_3",
    "bitwise:wire_hex_4",
    "bitwise:wire_hex_5",
    "bitwise:wire_hex_6",
    "bitwise:wire_hex_7",
    "bitwise:wire_hex_8",
    "bitwise:wire_hex_9",
    "bitwise:wire_hex_10",
    "bitwise:wire_hex_11",
    "bitwise:wire_hex_12",
    "bitwise:wire_hex_13",
    "bitwise:wire_hex_14",
    "bitwise:wire_hex_15"
)