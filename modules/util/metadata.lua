local metadata = { blocks = { }, global = { } }

local data =
{
	blocks = { },
	global = { }
}

local function toKey(x, y, z)
	return x..","..y..","..z
end

function metadata.blocks.get_metadata(x, y, z)
	return data.blocks[toKey(x, y, z)]
end

function metadata.blocks.set_metadata(x, y, z, meta)
	data.blocks[toKey(x, y, z)] = meta
end

function metadata.blocks.get_property(x, y, z, property)
	local meta = data.blocks[toKey(x, y, z)]

	if meta ~= nil then
		return meta[property]
	else
		return nil
	end
end

function metadata.blocks.set_property(x, y, z, property, value)
	local key = toKey(x, y, z)
	local meta = data.blocks[key]

	if meta == nil then
		meta = { }
		data.blocks[key] = meta
	end

	meta[property] = value
end

function metadata.global.get_metadata(key)
	return data.global[key]
end

function metadata.global.set_metadata(key, meta)
	data.global[key] = meta
end

function metadata.global.get_property(key, property)
	local meta = data.global[key]

	if meta ~= nil then
		return meta[property]
	else
		return nil
	end
end

function metadata.global.set_property(key, property, value)
	local meta = data.global[key]

	if meta == nil then
		meta = { }
		data.global[key] = meta
	end

	meta[property] = value
end

function metadata.blocks.has_metadata(x, y, z)
	return metadata.blocks.get_metadata(x, y, z) ~= nil
end

function metadata.global.has_metadata(key)
	return metadata.global.get_metadata(key) ~= nil
end

function metadata.blocks.delete_metadata(x, y, z)
	metadata.blocks.set_metadata(x, y, z, nil)
end

function metadata.global.delete_metadata(key)
	metadata.global.set_metadata(key, nil)
end

function metadata.blocks.move_metadata(x1, y1, z1, x2, y2, z2)
	local meta = metadata.blocks.get_metadata(x1, y1, z1)
	metadata.blocks.delete_metadata(x1, y1, z1)
	metadata.blocks.set_metadata(x2, y2, z2, meta)
end

function metadata.global.move_metadata(key1, key2)
	local meta = metadata.global.get_metadata(key1)
	metadata.global.delete_metadata(key1)
	metadata.global.set_metadata(key2, meta)
end

function metadata.load()
	if not file.exists(metadata.get_save_file()) then
		return
	end

	data = json.parse(file.read(metadata.get_save_file()))
end

function metadata.save()
	file.write(metadata.get_save_file(), json.tostring(data))
end

function metadata.get_save_file()
	return pack.data_file("bitwise", "metadata.json")
end

return metadata