require("love")
local vector = require("src.math.vector")
local gamera = require("src.gamera")
local info = require("src.info")
local particles = require("src.particles.pink")
local pt = require("src.projectiles")
local mc = require("src.main_char")





function love.load()
    DEBUG = info:new()
    MC = mc:new()
    PROJECTILES = pt:new()

    RECT_X, RECT_Y, RECT_W, RECT_H = 20, 20, 20, 20;
    CURSOR_X, CURSOR_Y = 0, 0
    DELTA_X, DELTA_Y = 0, 0
    ARRAY = {}
    SPEED = 0
    GAME_CAMERA = gamera.new(
    0,0, 2000, 2000
    )
    BACKGROUND = love.graphics.newImage("assets/background.jpg")
end

function love.update(dt)
    if love.keyboard.isDown("space") then
        dt = dt *0.25
    elseif love.keyboard.isDown("lshift") then
        dt = dt * 2
        IS_RUNNING = true
    else
        IS_RUNNING = false
    end

    local worldX, worldY = love.graphics.getDimensions()
    local curX, curY = love.mouse.getPosition()
    curX, curY = curX - worldX/2, curY - worldY/2

    local mouseVector = vector:new(curX,curY)
    mouseVector = mouseVector:mul(0.5)
    GAME_CAMERA:setPosition(MC.X + mouseVector.X, MC.Y + mouseVector.Y)

    DEBUG:add("projectiles", #PROJECTILES.p)

    MC:update(dt)
    -- GAME_CAMERA:setPosition(MC.X, MC.Y)
    PROJECTILES:update(dt)
    local particleData = particles[1]
    if IS_RUNNING then
        particleData.system:start()
    else
        particleData.system:pause()
    end
    particleData.system:update(dt)
    particleData.system:setPosition(MC.X, MC.Y)

    SPEED = SPEED + 9.8 * dt
    RECT_Y = RECT_Y + SPEED * dt
end

function love.wheelmoved(_, key)
    local scale = GAME_CAMERA:getScale()
    GAME_CAMERA:setScale(scale * (1 + key * 0.1))
    DEBUG:add("scale", scale)
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


local function drawParticles()
    for _, particleData in ipairs(particles) do
		love.graphics.setBlendMode(particleData.blendMode)
		love.graphics.setShader(particleData.shader) -- The .shader field is always nil in this example, so this line actually does nothing.
		love.graphics.draw(particleData.system, particleData.x, particleData.y)
	end
end

function love.draw()
    -- for _, arr in ipairs(ARRAY) do
    --     local angle = (love.timer.getTime() - arr[4]) * 2 * math.pi / 2.5
    --     love.graphics.draw(ImageData,  arr[1], arr[2], angle, 1, 1, 25 / 2, 25 / 2)
    -- end
    -- love.graphics.setColor(0, 0.4, 0.4)
    -- love.graphics.print(arrayToString(ARRAY), 200, 0)
    GAME_CAMERA:draw(function(l,t,w,h)
        for i = 0, (l + w) / BACKGROUND:getWidth() do
            for j = 0, (t + h) / BACKGROUND:getHeight() do
                love.graphics.draw(BACKGROUND, i * BACKGROUND:getWidth(), j * BACKGROUND:getHeight())
            end
        end

        MC:draw()
        love.graphics.setColor(1,1,1,1)
        PROJECTILES:draw()
        drawParticles()
    end)

    DEBUG:draw()
    -- love.graphics.rectangle("fill", RECT_X, RECT_Y, RECT_W, RECT_H)
end

