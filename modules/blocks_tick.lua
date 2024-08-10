local module = {}
local blocks = {}
local registeredFunctions = {}

function module.add_block(x, y, z)
    table.insert(blocks, {x, y, z})
end

function module.remove_block(x, y, z)
    for i, block in ipairs(blocks) do
        if block[1] == x and block[2] == y and block[3] == z then
            table.remove(blocks, i)
            break
        end
    end
end

function module.register(fn, ...)
    local ids = { ... }

    for i = 1, #ids do
        local id = ids[i]

        if not registeredFunctions[id] then registeredFunctions[id] = fn end 
    end
end

function module.tick()
    for i, pos in ipairs(blocks) do
        local x, y, z = pos[1], pos[2], pos[3]

        registeredFunctions[block.name(block.get(x, y, z))](x, y, z)
    end
end

function module.save()
    local path = pack.data_file("bitwise", "ticked_blocks.json")
    file.write(path, json.tostring(({blocks = blocks})))
end

function module.load()
    local path = pack.data_file("bitwise", "ticked_blocks.json")
    if file.exists(path) then
        local data = file.read(path)
        blocks = json.parse(data)['blocks']
    end
end

return module