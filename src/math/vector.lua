---@class vector
---@field X number
---@field Y number
local vector = {}

---@return vector
function vector:new(x, y)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.X, obj.Y = x, y
    return obj
end
function vector:normalize()
    local length = math.sqrt(self.X*self.X + self.Y*self.Y)
    if length == 0 then
        return vector:new(0, 0)
    end
    local normalized = vector:new(self.X/length, self.Y/length)
    return normalized
end
function vector:negative()
    return vector:new(-self.X, -self.Y)
end
function vector:mul(scalar)
    return vector:new(self.X * scalar, self.Y * scalar)
end
function vector:sub(vector)
    return vector:new(self.X - vector.X, self.Y - vector.Y)
end
function vector:subLength(length)
    return self:withLength(self:length() - length)
end
function vector:add(vector)
    return vector:new(self.X + vector.X, self.Y + vector.Y)
end
function vector:isZero()
    return self.X == 0 and self.Y == 0
end
function vector:length()
    return math.sqrt(self.X*self.X + self.Y*self.Y)
end
function vector:trim(length)
    local currentLength = self:length()
    if currentLength <= length then
        return self
    end
    return self:withLength(length)
end
function vector:withLength(length)
    if length < 0 then
        return vector:new(0, 0)
    end

    if self:isZero() then
        return vector:new(length, 0)
    end
    local selfLength = self:length()
    local ratio = length / selfLength
    return vector:new(self.X * ratio, self.Y * ratio)
end
function vector:toAngle()
    return math.atan2(self.Y, self.X)
end

return vector