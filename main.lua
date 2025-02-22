require("love")
require("math.vector")
require("garbage_collector")

local directions = {
    w = vector:new(0, -1),
    s = vector:new(0, 1),
    a = vector:new(-1, 0),
    d = vector:new(1, 0),
}

MAIN_CHAR = {}
function MAIN_CHAR:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.ImageData = love.graphics.newImage("test.png")
    obj.X, obj.Y = 0, 0
    obj.fireRate = 3
    obj.lastFire = 0
    obj.maxSpeed = 900
    obj.direction = vector:new(0, 0)
    obj.deceleration = 1500
    obj.acceleration = 400
    return obj
end
function MAIN_CHAR:update()
    local dt = love.timer.getDelta()
    local forceVector = vector:new(0,0)
    for direction, vector in pairs(directions) do
        if love.keyboard.isDown(direction) then
            forceVector = forceVector:add(vector)
        end
    end
        self.direction = self.direction:subLength(self.direction:length() * 0.9 * dt)
    if not forceVector:isZero() then
        local newDir = self.direction:add(forceVector:normalize():mul(self.acceleration* dt))
        -- if newDir:length() > self.maxSpeed then
        --     newDir = newDir:withLength(self.maxSpeed)
        -- end
        self.direction = newDir
    end
    self.X = self.X + self.direction.X * dt
    self.Y = self.Y + self.direction.Y * dt

    local range = 1 / self.fireRate
    local x, y = love.mouse.getPosition()
    local mouseVector = vector:new(x,y)
    if love.timer.getTime() - self.lastFire > range then
        self.lastFire = love.timer.getTime()
        local projectile = PROJECTILE:new(vector:new(self.X, self.Y), mouseVector:sub(vector:new(self.X, self.Y)):normalize())
        table.insert(PROJECTILES, projectile)
    end
end
function MAIN_CHAR:draw()
    love.graphics.draw(self.ImageData, self.X, self.Y,0,1,1, 25/2, 25/2)
end

PROJECTILE = {}
function PROJECTILE:new(pos, direction)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.pos = pos
    obj.direction = direction
    obj.speed = 1000
    obj.tail = 20
    return obj
end
function PROJECTILE:draw()
    local tail = self.direction:negative():mul(self.tail)
    love.graphics.line(self.pos.X, self.pos.Y, self.pos.X + tail.X, self.pos.Y + tail.Y)
end
function PROJECTILE:update()
    local dt = love.timer.getDelta()
    self.pos.X = self.pos.X + self.direction.X * dt * self.speed
    self.pos.Y = self.pos.Y + self.direction.Y * dt * self.speed
end


function love.load()
    MC = MAIN_CHAR:new()
    PROJECTILES = {}

    ImageData = love.graphics.newImage("test.png")

    RECT_X, RECT_Y, RECT_W, RECT_H = 20, 20, 20, 20;
    CURSOR_X, CURSOR_Y = 0, 0
    DELTA_X, DELTA_Y = 0, 0
    ARRAY = {}
    SPEED = 0
end

function love.update(dt)
    MC:update()
    for i, projectile in ipairs(PROJECTILES) do
        projectile:update()
    end
    -- for i, dot in ipairs(ARRAY) do
    --     dot[3] = dot[3] + 9.8 * dt
    --     dot[2] = dot[2] + dot[3] * dt
    --     if dot[2] > love.graphics.getHeight() then
    --         table.remove(ARRAY, i)
    --         -- ARRAY.remove(i)
    --     end
    -- end
    SPEED = SPEED + 9.8 * dt
    RECT_Y = RECT_Y + SPEED * dt
end

function love.mousepressed(x, y, _)
    local insertedArray = {x, y, 0, love.timer.getTime()}
    ARRAY[#ARRAY + 1] = insertedArray
end

function love.mousemoved(x, y, dx, dy, isTouch)
    if isTouch then
        RECT_W = dx
        RECT_H = dy
    end
    RECT_W, RECT_H = RECT_W + dx, RECT_H + dy
    RECT_X, CURSOR_X = x, x
    RECT_Y, CURSOR_Y = y, y
    DELTA_X, DELTA_Y = dx, dy
end


function love.draw()
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.print("Cursor X: " .. CURSOR_X, 0, 0)
    love.graphics.print("Cursor Y: " .. CURSOR_Y, 0, 10)
    love.graphics.print("Delta X: " .. DELTA_X, 0, 20)
    love.graphics.print("Delta Y: " .. DELTA_Y, 0, 30)
    love.graphics.print("getPosition: " .. string.format("%0.2f %0.2f",  MC.X , MC.Y), 0, 40)
    love.graphics.print("speed: " .. string.format("%0.2f %0.2f", MC.direction.X, MC.direction.Y), 0 ,50)
    love.graphics.print("projectiles: ".. #PROJECTILES, 0 ,60)
    -- for _, arr in ipairs(ARRAY) do
    --     local angle = (love.timer.getTime() - arr[4]) * 2 * math.pi / 2.5
    --     love.graphics.draw(ImageData,  arr[1], arr[2], angle, 1, 1, 25 / 2, 25 / 2)
    -- end
    -- love.graphics.setColor(0, 0.4, 0.4)
    -- love.graphics.print(arrayToString(ARRAY), 200, 0)
    MC:draw()
    love.graphics.setColor(1,1,1,1)
    for i, projectile in ipairs(PROJECTILES) do
        projectile:draw()
    end
    -- love.graphics.rectangle("fill", RECT_X, RECT_Y, RECT_W, RECT_H)
end

