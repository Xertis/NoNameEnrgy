local metadata = require "bitwise:util/metadata"
local instant = require 'bitwise:logic/pattern'

local function func(a, b, c)
    return (a or b or c)
end

function on_broken(x, y, z)
    instant:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    instant:placed(x, y, z, func)

    instant:update(x, y, z, func)
end

function on_update(x, y, z)
    instant:update(x, y, z, func)
end