local utils = require("src.utils")

---@class health
---@field health number
---@field maxHealth number
local health = {}

function health.new(h)
    local self = {}
    self.health = h or 100
    self.maxHealth = h or 100
    setmetatable(self, {__index = health})
    return self
end

function health:damage(amount)
    self.health = self.health - amount
    if self.health < 0 then
        self.health = 0
    end
end

function health:inPercentage()
    return self.health / self.maxHealth
end

function health:isDead()
    return self.health <= 0
end

function health:draw(x,y,w)
    love.graphics.setLineWidth(5)
    local startX = x - w / 2
    local endX = x + w / 2
    local healthWidth = w * self.health / self.maxHealth
    love.graphics.setColor(0, 0, 0)
    love.graphics.line( startX, y, endX, y)
    love.graphics.setColor(0, 1, 0)
    love.graphics.line( startX, y, startX + healthWidth, y)
end

return health