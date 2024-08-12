local metadata = require "bitwise:util/metadata"
local and_e = require 'bitwise:logic/pattern'

local function func(a, b)
    return a == true and b == true
end

function on_broken(x, y, z)
    and_e:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    and_e:placed(x, y, z, func)

    and_e:update(x, y, z, func)
end

function on_update(x, y, z)
    and_e:update(x, y, z, func)
end