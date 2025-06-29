local sprites = require("src.spritesheets.sprites")
local animation = require("src.spritesheets.animation")
local health = require("src.health")
local utils = require("src.utils")

local daunSpritesheet = sprites:getDaun()

---@class Daun
---@field body love.Body
---@field hitbox love.CircleShape
---@field fixture love.Fixture
---@field animation Animation
---@field spritesheet spritesheet
---@field health health
---@field world World
local daun = {
  type = "daun"
}

---@param world World
---@param x number
---@param y number
---@return Daun
function daun.new(world, x, y)
  local new = {}
  new.animation = animation.new(daunSpritesheet, 1, 0.5)
  new.body = love.physics.newBody(world.physics, x, y, "dynamic")
  new.body:setLinearDamping(0.3)
  new.hitbox = love.physics.newCircleShape(25)
  new.fixture = love.physics.newFixture(new.body, new.hitbox)
  new.fixture:setDensity(200)
  new.body:resetMassData()
  new.fixture:setUserData(new)
  new.spritesheet = daunSpritesheet
  new.health = health.new(100)
  new.world = world
  setmetatable(new, { __index = daun })
  return new
end

function daun:draw()
  local x, y = self.body:getPosition()
  love.graphics.setColor(1, 1, 1)
  self.animation:draw(
    x,
    y,
    self.body:getAngle()
  )
  love.graphics.setLineWidth(1)
  love.graphics.circle("line", x, y, self.hitbox:getRadius())
  self.health:draw(x, y + self.hitbox:getRadius() + 5, 30)
end

---@param event event
function daun:receive(event)
  if event.type ~= "hit" then
    return
  end
  self.health:damage(event.data.amount)
  local healthPercentage = self.health:inPercentage()
  if healthPercentage <= 0 then
    self.animation:setPos(3)
    self.world:addTimer(1, function()
      for i, daun in ipairs(self.world.dauns) do
        if daun == self then
          table.remove(self.world.dauns, i)
          daun.body:destroy()
          break
        end
      end
    end)
  elseif healthPercentage < 0.25 then
    self.animation:setPos(3)
  elseif healthPercentage < 0.5 then
    self.animation:setPos(2)
  else
    self.animation:setPos(1)
  end
end

function daun:update(dt)
  self.animation:update(dt)
end

return daun
