local health = {}

function health.new(h)
    local self = {}
    self.health = h or 100
    setmetatable(self, {__index = health})
    return self
end

function health:update(dt)
end

function health:draw()
end

return health