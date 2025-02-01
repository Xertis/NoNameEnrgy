local metadata = require "bitwise:util/metadata"
local instant = require 'bitwise:logic/instant'

function on_broken(x, y, z)
    instant:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    instant:placed(x, y, z)
end

function on_update(x, y, z) instant:update(x, y, z) end