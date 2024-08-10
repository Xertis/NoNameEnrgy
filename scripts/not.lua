local metadata = require "bitwise:util/metadata"
local invertor = require 'bitwise:logic/invertor'

function on_broken(x, y, z)
    invertor:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    invertor:placed(x, y, z)
end

function on_update(x, y, z) invertor:update(x, y, z) end