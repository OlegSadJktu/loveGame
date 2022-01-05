require "love"

function love.load()
    RECT_X, RECT_Y, RECT_W, RECT_H = 20, 20, 60, 20;
    CURSOR_X, CURSOR_Y = 0, 0
    DELTA_X, DELTA_Y = 0, 0
    ARRAY = {}
end

function love.update(dt)
end

function love.mousepressed(x, y, button)
    local insertedArray = {x, y}
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


function arrayToString(array)
    local str = ""
    for i, pair in ipairs(array) do
        str = str .. pair[1] .. "x" .. pair[2] .. ";"
    end
    return str
end

function love.draw()
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.print(CURSOR_X, 200, 300)
    love.graphics.print(CURSOR_Y, 300, 300)
    love.graphics.print(DELTA_X, 200, 400)
    love.graphics.print(DELTA_Y, 300, 400)
    love.graphics.print(arrayToString(ARRAY), 200, 500)
    for i, arr in ipairs(ARRAY) do
        love.graphics.rectangle("fill", arr[1], arr[2], 5, 5)
    end
    love.graphics.setColor(0, 0.4, 0.4)
end

