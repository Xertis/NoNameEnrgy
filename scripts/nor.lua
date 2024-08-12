local metadata = require "bitwise:util/metadata"
local nor = require 'bitwise:logic/pattern'

local function func(a, b)
    return not (a or b)
end

function on_broken(x, y, z)
    nor:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    nor:placed(x, y, z, func)

    nor:update(x, y, z, func)
end

function on_update(x, y, z)
    nor:update(x, y, z, func)
end