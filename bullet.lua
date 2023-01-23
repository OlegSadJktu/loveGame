SimpleBullet = {
    x = 0,
    y = 0,
    angle = 0
}

function SimpleBullet:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end
