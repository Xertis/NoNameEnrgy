local metadata = require "bitwise:util/metadata"
local d_t = require 'bitwise:logic/pattern'

local function func(data, write, _, prev)
    if not write then return prev
    else return data end
end

function on_broken(x, y, z)
    d_t:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    d_t:placed(x, y, z, func)

    d_t:update(x, y, z, func)
end

function on_update(x, y, z)
    d_t:update(x, y, z, func)
end