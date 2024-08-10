local state_api = require "bitwise:logic/state_api"

local arrow = { }

function arrow.tick(x, y, z)
    state_api.switch(x, y, z)
end

function arrow.placed(x, y, z)

end

function arrow.broken(x, y, z)

end

return arrow