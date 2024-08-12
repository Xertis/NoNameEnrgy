local metadata = require "bitwise:util/metadata"
local nand = require 'bitwise:logic/pattern'

local function func(a, b)
    return not (a == true and b == true)
end

function on_broken(x, y, z)
    nand:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    nand:placed(x, y, z, func)

    on_update(x, y, z)
end

function on_update(x, y, z)
    nand:update(x, y, z, func)
end