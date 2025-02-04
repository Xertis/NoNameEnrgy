local metadata = require "bitwise:util/metadata"
local hex_decoder = require 'bitwise:logic/pattern_hex'
local direction = require "bitwise:util/direction"
local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"

local hexadecimal = json.parse(file.read("bitwise:data/hexadecimal.json"))[2]

local function __get_last__(x, y, z)
    local hex_decoder_id = block.index("bitwise:hex_decoder")
    while not string.starts_with(block.name(block.get(direction.get_side_block(x, y, z, -1))), "bitwise:wire_hex") do
        x, y, z = direction.get_side_block(x, y, z, -1)

        if block.get(x, y, z) ~= hex_decoder_id then
            return nil
        end
    end

    return x, y, z
end

local function func(_, _, _, _, pos)
    local hex_decoder_id = block.index("bitwise:hex_decoder")

    local x, y, z = unpack(pos)

    x, y, z = __get_last__(x, y, z)

    if x == nil then
        return
    end

    local sx, sy, sz = direction.get_side_block(x, y, z, -1)

    local hex = hexadecimal[state_api.is_active_hex(sx, sy, sz)+1]

    local i = 1

    while block.get(x, y, z) == hex_decoder_id and i < 5 do
        local active = tonumber(hex[#hex - i + 1])
        active = active == 1

        metadata.blocks.set_property(x, y, z, "impulse", active)
        local bx, by, bz = direction.get_front_block(x, y, z, -1)

        if state_api.is_active(bx, by, bz) ~= active then
            signals.impulse(bx, by, bz, active, true)
        end
        x, y, z = direction.get_side_block(x, y, z)
        i = i + 1
    end
end

function on_broken(x, y, z)
    hex_decoder:broken(x, y, z)

    metadata.blocks.delete_metadata(x, y, z)
end

function on_placed(x, y, z)
    hex_decoder:placed(x, y, z, func)

    hex_decoder:update(x, y, z, func)
end

function on_update(x, y, z)
    hex_decoder:update(x, y, z, func)
end