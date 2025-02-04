local metadata = require "bitwise:util/metadata"
local hex_coder = require 'bitwise:logic/pattern_hex'
local direction = require "bitwise:util/direction"
local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"

local hexadecimal = json.parse(file.read("bitwise:data/hexadecimal.json"))[1]

local function __get_neighbours_active__(x, y, z)
    local hex_coder_id = block.index("bitwise:hex_coder")
    local sum = ""
    while not string.starts_with(block.name(block.get(direction.get_side_block(x, y, z, -1))), "bitwise:wire_hex") do
        x, y, z = direction.get_side_block(x, y, z, -1)

        if block.get(x, y, z) ~= hex_coder_id then
            return nil
        end
    end

    local sx, sy, sz = x, y, z

    while block.get(x, y, z) == hex_coder_id do
        local bx, by, bz = direction.get_front_block(x, y, z, -1)
        local active = state_api.is_active(bx, by, bz) and "1" or "0"
        sum = active .. sum
        x, y, z = direction.get_side_block(x, y, z)
    end

    return sum, sx, sy, sz
end

local function func(_, _, _, _, pos)

    local x, y, z = unpack(pos)

    local key = nil
    key, x, y, z =__get_neighbours_active__(x, y, z)
    if key == nil then return end
    local active = hexadecimal[key] or 0

    metadata.blocks.set_property(x, y, z, "impulse", active)

    local sx, sy, sz = direction.get_side_block(x, y, z, -1)
    if state_api.is_active(sx, sy, sz) ~= active then
        signals.impulse_hex(sx, sy, sz, active, true)
    end
end

function on_broken(x, y, z)
    hex_coder:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    hex_coder:placed(x, y, z, func)

    hex_coder:update(x, y, z, func)
end

function on_update(x, y, z)
    hex_coder:update(x, y, z, func)
end