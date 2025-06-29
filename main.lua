require("love")
local world = require("src.world")


function love.load()
    W = world.default()
end

function love.update(dt)
    W:update(dt)
end

function love.wheelmoved(_, key)
    W:wheelmoved(_, key)
end

function love.mousepressed(x, y, _)
    W:mousepressed(x, y, _)
end

function love.draw()
    W:draw()
end
