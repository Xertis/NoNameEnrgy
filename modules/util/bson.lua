local dbuf = require 'core:data_buffer'
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
            buf:put_byte(TYPES.number)
            buf:put_number(item)
        else
            buf:put_byte(TYPES.float)
            buf:put_double(item)
        end
    elseif type(item) == 'string' then
        buf:put_byte(TYPES.string)
        buf:put_string(item)
    elseif type(item) == 'table' then
        buf:put_byte(TYPES.table)
        sys.save_table(buf, item)
    else
        buf:put_byte(TYPES.bool)
        buf:put_bool(item)
    end
end

function sys.get_item(buf)
    local type_item = buf:get_byte()
    if type_item == TYPES.number then
        return buf:get_number()
    elseif type_item == TYPES.float then
        return buf:get_double()
    elseif type_item == TYPES.string then
        return buf:get_string()
    elseif type_item == TYPES.table then
        return sys.load_table(buf) 
    else
        return buf:get_bool()
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
    local len = buf:get_uint32()
    local res = {}
    for i=1, len do
        local type_item = buf:get_byte()
        if type_item == TYPES.hashmap then
            local key = buf:get_string()
            res[key] = sys.get_item(buf)
        else
            res[i] = sys.get_item(buf)
        end
    end
    return res
end

function sys.save_table(buf, tbl)
    buf:put_uint32(sys.get_full_len(tbl))
    for i, b in pairs(tbl) do
        if type(i) == 'string' then
            buf:put_byte(TYPES.hashmap)
            buf:put_string(i)
            sys.put_item(buf, b)
        else
            buf:put_byte(TYPES.array)
            sys.put_item(buf, b)
        end
    end
end

function bson.encode(buf, arr)
    buf:put_byte(VERSION)
    buf:put_byte(TYPES.table)
    sys.save_table(buf, arr)
end

function bson.decode(buf)
    local version = buf:get_byte()
    buf:get_byte()
    return sys.load_table(buf)
end

function bson.read_file(path)
    return bson.decode(dbuf(file.read_bytes(path)))
end

function bson.write_file(path, arr)
    local buf = dbuf()

    bson.encode(buf, arr)

    file.write_bytes(path, buf:get_bytes())
end

return bson