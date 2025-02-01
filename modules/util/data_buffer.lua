local bc = require "util/bit_converter"

local TYPES = {
    b = 1,
    B = 1,
    h = 2,
    H = 2,
    i = 4,
    I = 4,
    l = 8,
    L = 8,
    ['?'] = 1
}

local module =
{
	__call =
	function(module, ...)
		return module:new(...)
	end
}

function table.slice(arr, start, stop)
    local sliced = {}
    start = start or 1
    stop = stop or #arr

    for i = start, stop do
        table.insert(sliced, arr[i])
    end

    return sliced
end

local function __get_size__(pattern)
    local size = 0
    for i=2, #pattern do
        size = size + TYPES[pattern[i]]
    end

    return size
end

local function __slice__(pattern)
    local first_char = pattern:sub(1, 1)

    local parts = {}
    local temp = ""
    for i = 1, #pattern do
        local char = pattern:sub(i, i)
        if char == "S" or char == "D" or char == "F" then
            if temp ~= "" then
                table.insert(parts, temp)
                temp = ""
            end
            table.insert(parts, char)
        else
            temp = temp .. char
        end
    end
    if temp ~= "" then
        table.insert(parts, temp)
    end

    return first_char, parts
end

function module:new(bytes)
	bytes = bytes or { }


    local obj = {
        pos = 1,
        bytes = bytes
    }

    self.__index = self
    setmetatable(obj, self)

    return obj
end

function module:add(bytes)
	for i = 1, #bytes do
		self:put_byte(bytes[i])
	end
end

function module:pack(format, values)
    local fchar, formats = __slice__(format)
    local res = {}

    if formats[1] == '>' or formats[1] == '<' then
        table.remove(formats, 1)
    else
        formats[1] = formats[1]:sub(2)
    end

    local i = 1

    for _=1, #formats do
        local pattern = formats[_]
        local b = table.slice(values, i)

        if pattern == 'S' then
            local bstr = bc.string_to_bytes(b[1])
            self:add(bstr)
        elseif pattern == 'D' then
            self:add(bc.float_to_bytest(b[1], 'd'))
        elseif pattern == 'F' then
            self:add(bc.float_to_bytes(b[1], 'f'))
        else
            pattern = fchar .. pattern
            local x = byteutil.tpack(pattern, unpack(b))
            i = i + #pattern - 2
            self:add(x)
        end

        i = i + 1
	end

    return res
end

function module:unpack(format)
    local fchar, formats = __slice__(format)
    local res = {}

    if formats[1] == '>' or formats[1] == '<' then
        table.remove(formats, 1)
    else
        formats[1] = formats[1]:sub(2)
    end

    local i = self.pos

    for _=1, #formats do
        local pattern = formats[_]
        local b = table.slice(self.bytes, i)
        if pattern == 'S' then
            local len = byteutil.unpack('<H', {b[1], b[2]})
            i = i + len + 2
            table.insert(res, bc.bytes_to_string(b))
        elseif pattern == 'D' then
            i = i + 8
            table.insert(res, bc.bytes_to_float(b, 'd'))
        elseif pattern == 'F' then
            i = i + 4
            table.insert(res, bc.bytes_to_float(b, 'f'))
        else
            pattern = fchar .. pattern
            local x = {byteutil.unpack(pattern, b)}
            for _, val in ipairs(x) do
                table.insert(res, val)
            end

            i = i + __get_size__(pattern)
        end
	end

    self.pos = i

    return res
end

function module:put_byte(byte)
	if byte < 0 or byte > 255 then
		error("invalid byte")
	end

	table.insert(self.bytes, byte)
end

return module