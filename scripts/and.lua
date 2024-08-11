local metadata = require "bitwise:util/metadata"
local and_e = require 'bitwise:logic/and'

function on_broken(x, y, z)
    and_e:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    and_e:placed(x, y, z)
end

function on_update(x, y, z)
    and_e:update(x, y, z)
end