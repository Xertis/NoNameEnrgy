local signals = require "bitwise:logic/signals"
local state_api = require "bitwise:logic/state_api"
local metadata = require "bitwise:util/metadata"
local direction = require "bitwise:util/direction"

local t_t = { __index = require 'bitwise:logic/element' }

setmetatable(t_t, t_t)

function t_t:update(x, y, z)
    local inputActive = state_api.is_active(direction.get_front_block(x, y, z, -1))

    if inputActive and metadata.blocks.get_property(x, y, z, "previousInput") ~= inputActive then
      state_api.switch(x, y, z)
      local fx, fy, fz = direction.get_front_block(x, y, z)
      signals.impulse(fx, fy, fz, state_api.is_active(x, y, z))
    end

    metadata.blocks.set_property(x, y, z, "previousInput", inputActive)
end

function t_t:placed(x, y, z)
    metadata.blocks.set_property(x, y, z, "frontBlock", { block.get_Y(x, y, z) })
    self:update(x, y, z)
end

return t_t