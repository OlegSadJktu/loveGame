local vector = require("src.math.vector")
local directions = require("src.directions")

---@class main_char
---@field ImageData love.Image
---@field X number
---@field Y number
---@field reloadTime number
---@field lastFire number
---@field maxSpeed number
---@field direction vector
---@field deceleration number
---@field acceleration number
local main_char = {}

---@return main_char
function main_char:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.ImageData = love.graphics.newImage("assets/test.png")
    obj.X, obj.Y = 0, 0
    obj.reloadTime = 1/3
    obj.lastFire = 0
    obj.maxSpeed = 900
    obj.direction = vector:new(0, 0)
    obj.deceleration = 1500
    obj.acceleration = 400
    return obj
end
function main_char:update(dt)
    local forceVector = vector:new(0,0)
    for direction, vector in pairs(directions) do
        if love.keyboard.isDown(direction) then
            forceVector = forceVector:add(vector)
        end
    end
    self.direction = self.direction:subLength(self.direction:length() * 0.9 * dt)
    self.direction = self.direction:subLength(0)
    if not forceVector:isZero() then
        local newDir = self.direction:add(forceVector:normalize():mul(self.acceleration* dt))
        newDir = newDir:add(vector:new(0, 0))
        self.direction = newDir
    end
    self.X = self.X + self.direction.X * dt
    self.Y = self.Y + self.direction.Y * dt

    DEBUG:add("mc", self)

    self.lastFire = self.lastFire + dt
    local x, y = love.mouse.getPosition()
    local mouseVector = vector:new(GAME_CAMERA:toWorld(x,y))


    if self.lastFire > self.reloadTime then
        self.lastFire = self.lastFire - self.reloadTime
        PROJECTILES:add(vector:new(self.X, self.Y), mouseVector:sub(vector:new(self.X, self.Y)):normalize())
    end
end
function main_char:draw()
    love.graphics.draw(self.ImageData, self.X, self.Y,0,1,1, 25/2, 25/2)
end

return main_char