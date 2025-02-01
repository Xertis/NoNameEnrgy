local dbuf = require 'util/data_buffer'
local bson = {}
local sys = {}

VERSION = 1

local TYPES = {
    array = 0,
    hashmap = 1,
    number = 2,
    float = 3,
    string = 4,
    table = 5,
    bool = 6
}

function sys.put_item(buf, item)
    if type(item) == 'number' then
        if item % 1 == 0 then
            buf:pack("<Bl", {TYPES.number, item})
        else
            buf:pack("<BD", {TYPES.float, item})
        end
    elseif type(item) == 'string' then
        buf:pack("<BS", {TYPES.string, item})
    elseif type(item) == 'table' then
        buf:pack("<B", {TYPES.table})
        sys.save_table(buf, item)
    else
        buf:pack("<B?", {TYPES.bool, item})
    end
end

function sys.get_item(buf)
    local type_item = buf:unpack("<B")[1]
    if type_item == TYPES.number then
        return buf:unpack("<l")[1]
    elseif type_item == TYPES.float then
        return buf:unpack("<D")[1]
    elseif type_item == TYPES.string then
        return buf:unpack("<S")[1]
    elseif type_item == TYPES.table then
        return sys.load_table(buf)
    else
        return buf:unpack("<?")[1]
    end
end

function sys.get_full_len(tbl)
    local len = 0
    for i, b in pairs(tbl) do
        len = len + 1
    end
    return len
end

function sys.load_table(buf)
    local len = buf:unpack("<I")[1]
    local res = {}
    for i=1, len do
        local type_item = buf:unpack("<B")[1]
        if type_item == TYPES.hashmap then
            local key = buf:unpack("<S")[1]
            res[key] = sys.get_item(buf)
        else
            res[i] = sys.get_item(buf)
        end
    end
    return res
end

function sys.save_table(buf, tbl)
    buf:pack("<I", {sys.get_full_len(tbl)})
    for i, b in pairs(tbl) do
        if type(i) == 'string' then
            buf:pack("<BS", {TYPES.hashmap, i})
            sys.put_item(buf, b)
        else
            buf:pack("<B", {TYPES.array})
            sys.put_item(buf, b)
        end
    end
end

function bson.encode(buf, arr)
    buf:pack("<BB", {VERSION, TYPES.table})
    sys.save_table(buf, arr)
end

function bson.decode(buf)
    local version = buf:unpack("<BB")[1]
    return sys.load_table(buf)
end

function bson.read_file(path)
    local x = bson.decode(dbuf:new(file.read_bytes(path)))
    return x
end

function bson.write_file(path, arr)
    local buf = dbuf:new()

    bson.encode(buf, arr)

    file.write_bytes(path, buf.bytes)
end

return bson