local metadata = require "bitwise:util/metadata"
local t_t = require 'bitwise:logic/t_trigger'

function on_broken(x, y, z)
    t_t:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    t_t:placed(x, y, z)

    t_t:update(x, y, z)
end

function on_update(x, y, z)
    t_t:update(x, y, z)
end