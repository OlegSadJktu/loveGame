require "love"

function love.load()
    RECT_X, RECT_Y, RECT_W, RECT_H = 20, 20, 20, 20;
    CURSOR_X, CURSOR_Y = 0, 0
    DELTA_X, DELTA_Y = 0, 0
    ARRAY = {}
    SPEED = 0
    MS_DELTA = 0
end

function love.update(dt)
    for i, dot in ipairs(ARRAY) do
        dot[3] = dot[3] + 9.8 * dt
        dot[2] = dot[2] + dot[3] * dt
        if dot[2] > love.graphics.getHeight() then
            table.remove(ARRAY, i)
            -- ARRAY.remove(i)
        end
    end
    SPEED = SPEED + 9.8 * dt
    RECT_Y = RECT_Y + SPEED * dt
    MS_DELTA = dt
end

function love.mousepressed(x, y, button)
    local insertedArray = {x, y, 0}
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


local function arrayToString(array)
    local str = ""
    for i, dot in ipairs(array) do
        str = str .. dot[1] .. "x" .. dot[2] .. ";\n"
    end
    str = str .. tostring(#ARRAY)
    return str
end

function love.draw()
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.print(CURSOR_X, 200, 300)
    love.graphics.print(CURSOR_Y, 300, 300)
    love.graphics.print(DELTA_X, 200, 400)
    love.graphics.print(DELTA_Y, 300, 400)
    love.graphics.print(MS_DELTA, 200, 500)
    for i, arr in ipairs(ARRAY) do
        love.graphics.rectangle("fill", arr[1], arr[2], 5, 5)
    end
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.print(arrayToString(ARRAY), 200, 0)
    -- love.graphics.rectangle("fill", RECT_X, RECT_Y, RECT_W, RECT_H)
end

