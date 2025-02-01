local metadata = require "bitwise:util/metadata"
local r_t = require 'bitwise:logic/pattern'

local function func(r, s, _, c)
    if (r and s) or r then return false
    elseif s then return true
    else return c end
end

function on_broken(x, y, z)
    r_t:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    r_t:placed(x, y, z, func)

    r_t:update(x, y, z, func)
end

function on_update(x, y, z)
    r_t:update(x, y, z, func)
end