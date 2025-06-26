local vector = require("src.math.vector")

local directions = {
    w = vector:new(0, -1),
    s = vector:new(0, 1),
    a = vector:new(-1, 0),
    d = vector:new(1, 0),
}

return directions