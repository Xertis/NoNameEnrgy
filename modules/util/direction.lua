local metadata = require "bitwise:util/metadata"
local direction = { }

function direction.get_front_block(x, y, z,  mul)
    mul = mul or 1

    local rx, ry, rz = 0, 0, 0

    if block.get(x, y, z) == 0 then
        local front = metadata.blocks.get_property(x, y, z, "frontBlock")

        if front then rx, ry, rz = unpack(front) end
    else
        rx, ry, rz = block.get_Y(x, y, z)
    end

    return x + rx * mul, y + ry * mul, z + rz * mul
end

function direction.get_side_block(x, y, z,  mul)
    mul = mul or 1

    local rx, ry, rz = block.get_X(x, y, z)

    return x + rx * mul, y + ry * mul, z + rz * mul
end

return direction