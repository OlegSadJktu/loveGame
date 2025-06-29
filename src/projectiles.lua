local vector = require("src.math.vector")

---@class Projectlies
---@field p projectile[]
local projectlies = {
}



---@return Projectlies
function projectlies.new()
    local projectiles = setmetatable({}, { __index = projectlies })
    projectiles.p = {}
    return projectiles
end

function projectlies:update(dt)
    for i, projectile in ipairs(self.p) do
        if projectile.lifeTime > 0 then
            projectile:update(dt)
        else
            projectile:destroy()
            table.remove(self.p, i)
        end
    end
end

function projectlies:draw()
    for _, projectile in ipairs(self.p) do
        projectile:draw()
    end
end

---@param event event
function projectlies:receive(event)
    if event.type == "hit" then
        for i, projectile in ipairs(self.p) do
            if projectile == event.data then
                table.remove(self.p, i)
                projectile:destroy()
            end
        end
    end
end

---@class projectile
---@field speed number
---@field tail number
---@field lifeTime number
---@field body love.Body
---@field hitbox love.CircleShape
---@field fixture love.Fixture
---@field type string
local projectile = {
    type = "projectile"
}

---@param world World
---@param pos vector
---@param direction vector
function projectlies:add(world, pos, direction)
    table.insert(self.p, projectile.new(world, pos, direction))
end

---@param world World
---@param pos vector
---@param direction vector
function projectile.new(world, pos, direction)
    local obj = {}
    setmetatable(obj, { __index = projectile })
    obj.body = love.physics.newBody(world.physics, pos.X, pos.Y, "dynamic")
    obj.body:setMass(0.5)
    obj.hitbox = love.physics.newCircleShape(6)
    obj.fixture = love.physics.newFixture(obj.body, obj.hitbox)
    obj.fixture:setUserData(obj)
    obj.speed = 1500
    obj.body:setLinearVelocity(direction.X * obj.speed, direction.Y * obj.speed)
    obj.body:setLinearDamping(1)
    obj.body:setBullet(true)
    obj.tail = 20
    obj.lifeTime = 6
    return obj
end

function projectile:draw()
    local x, y = self.body:getPosition()
    local tailVector = vector:new(self.body:getLinearVelocity()):mul(0.05):trim(self.tail)
    local tailX, tailY = tailVector.X, tailVector.Y
    love.graphics.line(x, y, x - tailX, y - tailY)
end

function projectile:update(dt)
    self.lifeTime = self.lifeTime - dt
end

function projectile:destroy()
    self.body:destroy()
end

return { projectlies, projectile }
