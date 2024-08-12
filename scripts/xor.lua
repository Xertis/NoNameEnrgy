local metadata = require "bitwise:util/metadata"
local xor = require 'bitwise:logic/pattern'

local function func(a, b)
    return ((a == true and b == false) or (a == false and b == true))
end

function on_broken(x, y, z)
    xor:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    xor:placed(x, y, z, func)

    xor:update(x, y, z, func)
end

function on_update(x, y, z)
    xor:update(x, y, z, func)
end