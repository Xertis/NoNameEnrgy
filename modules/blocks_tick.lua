local module = {}
local reg_blocks = {}
local tickFunctions = {}

function module.reg(x, y, z)
    table.insert(reg_blocks, {x, y, z})
end

function module.unreg(x, y, z)
    for i, block in ipairs(reg_blocks) do
        if block[1] == x and block[2] == y and block[3] == z then
            table.remove(reg_blocks, i)
            break
        end
    end
end

function module.reg_func(id, func)
   tickFunctions[id] = func
end

function module.tick()
    for i, pos in ipairs(reg_blocks) do
        local x, y, z = pos[1], pos[2], pos[3]
        local func = tickFunctions[block.name(block.get(x, y, z))]
        if func ~= nil then func(x, y, z) else module.unreg(x, y, z) end
    end
end

return module