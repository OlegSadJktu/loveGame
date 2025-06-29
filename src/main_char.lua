local vector = require("src.math.vector")
local directions = require("src.directions")

---@class main_char
---@field ImageData love.Image
---@field X number
---@field Y number
---@field reloadTime number
---@field lastFire number
---@field maxSpeed number
---@field maxBoost number
---@field direction vector
---@field deceleration number
---@field world World
local main_char = {
    type = "player"
}

local main_charmt = {
    __index = main_char
}

---@param world World
---@return main_char
function main_char:new(world)
    local obj = {}
    setmetatable(obj, main_charmt)
    obj.ImageData = love.graphics.newImage("assets/test.png")
    obj.X, obj.Y = 0, 0
    obj.reloadTime = 1 / 3
    obj.lastFire = 0
    obj.maxSpeed = 300
    obj.maxBoost = 500
    obj.direction = vector:new(0, 0)
    obj.deceleration = 800
    obj.world = world
    return obj
end

function main_char:update(dt)
    if love.keyboard.isDown("lshift") then
        self.maxSpeed = self.maxBoost
    else
        self.maxSpeed = self.maxSpeed
    end
    local forceVector = vector:new(0, 0)
    for direction, vector in pairs(directions) do
        if love.keyboard.isDown(direction) then
            forceVector = forceVector:add(vector)
        end
    end
    if not forceVector:isZero() then
        local newDir = forceVector:normalize():mul(self.maxSpeed)
        newDir = newDir:add(vector:new(0, 0))
        self.direction = newDir
    else
        self.direction = self.direction:subLength(self.deceleration * dt)
    end
    self.X = self.X + self.direction.X * dt
    self.Y = self.Y + self.direction.Y * dt


    self.lastFire = self.lastFire + dt
    local x, y = love.mouse.getPosition()
    local mouseVector = vector:new(self.world.camera:toWorld(x, y))


    if self.lastFire > self.reloadTime then
        self.lastFire = self.lastFire - self.reloadTime
        self.world.projectile:add(self.world, vector:new(self.X, self.Y),
            mouseVector:sub(vector:new(self.X, self.Y)):normalize())
    end
end

function main_char:draw()
    love.graphics.draw(self.ImageData, self.X, self.Y, 0, 1, 1, 25 / 2, 25 / 2)
end

return main_char
