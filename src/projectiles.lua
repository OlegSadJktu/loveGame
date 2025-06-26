---@class projectlies
---@field p projectile[]
local projectlies = {}


---@return projectlies
function projectlies.new()
    local projectiles = setmetatable({}, {__index = projectlies})
    projectiles.p = {}
    return projectiles
end

function projectlies:update(dt)
    for i, projectile in ipairs(self.p) do
        if projectile.lifeTime > 0 then
            projectile:update(dt)
        else
            table.remove(self.p, i)
        end
    end
end

function projectlies:draw()
    for _, projectile in ipairs(self.p) do
        projectile:draw()
    end
end

---@class projectile
---@field pos vector
---@field direction vector
---@field speed number
---@field tail number
---@field lifeTime number
local projectile = {}

function projectlies:add(pos, direction)
    table.insert(self.p, projectile.new(pos, direction))
end


function projectile.new(pos, direction)
    local obj = {}
    setmetatable(obj, {__index = projectile})
    obj.pos = pos
    obj.direction = direction
    obj.speed = 300
    obj.tail = 20
    obj.lifeTime = 1
    return obj
end
function projectile:draw()
    local tail = self.direction:negative():mul(self.tail)
    love.graphics.line(self.pos.X, self.pos.Y, self.pos.X + tail.X, self.pos.Y + tail.Y)
end
function projectile:update(dt)
    self.lifeTime = self.lifeTime - dt
    self.pos.X = self.pos.X + self.direction.X * dt * self.speed
    self.pos.Y = self.pos.Y + self.direction.Y * dt * self.speed
end

return projectlies