
---@class Animation
---@field spritesheet spritesheet
---@field x number
---@field y number
---@field duration number
---@field pos number
---@field elapsed number
---@field frame number
local animation = {}

---@param spriteSheet spritesheet
function animation.new(spriteSheet, pos, duration)
  local new = {}
  new.spritesheet = spriteSheet
  new.duration = duration
  new.pos = pos
  new.elapsed = 0
  new.frame = 1
  setmetatable(new, {__index = animation})
  return new
end

function animation:update(dt)
  self.elapsed = self.elapsed + dt
  if self.elapsed >= self.duration then
    self.elapsed = 0
    self.frame = self.frame + 1
  end
end

function animation:setPos(pos)
  self.pos = pos
end

function animation:draw(x, y, r)
  local currentFrame = self.spritesheet[self.pos][self.frame % #self.spritesheet[self.pos] + 1]
  love.graphics.draw(
    self.spritesheet.image,
    currentFrame, x, y, r, 1, 1,
    self.spritesheet.spriteSize.width / 2,
    self.spritesheet.spriteSize.height / 2
  )
end

return animation