package.path = package.path .. ";../?.lua"

---@class vector
vector = {}
function vector:new(x, y)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.X, obj.Y = x, y
    return obj
end
function vector:normalize()
    local length = math.sqrt(self.X*self.X + self.Y*self.Y)
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


return vector