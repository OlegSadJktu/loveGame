---@class circle_hitbox
---@field pos vector
---@field radius number
circle_hitbox = { }

---@param x number
---@param y number
---@param radius number
---@return circle_hitbox
function circle_hitbox:new(x, y, radius)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.pos = vector:new(x, y)
    obj.radius = radius
    return obj
end

---@param other vector | circle_hitbox
---@return boolean
function circle_hitbox:collides(other)
  if other.radius then
    local a = other
    local distance = (self.pos.x - a.pos.x)^2 + (self.pos.y - a.pos.y)^2
    return distance <= (self.radius + a.radius)^2
  end
  local a = other
  return (self.pos.x - a.x)^2 + (self.pos.y - a.y)^2 <= (self.radius)^2
end