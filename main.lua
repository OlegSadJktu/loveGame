require "love"

function love.load()
    RECT_X, RECT_Y, RECT_W, RECT_H = 20, 20, 20, 20;
    CURSOR_X, CURSOR_Y = 0, 0
    DELTA_X, DELTA_Y = 0, 0
    Asset = love.graphics.newImage('test.png')
    FRICTION_COEFF = 0.25
    -- love.window.setFullscreen(true)
    OBJ = {
        x_pos = 0,
        y_pos = 0,
        x_speed = 0,
        y_speed = 0,
        angle = 0,

    };
    love.graphics.setBackgroundColor(1,1,1)
end

function love.keypressed(key)
    if key == 'q' then
        love.window.close()
    end
end

function love.update(dt)
    local x, y = love.mouse.getPosition()
    local dx, dy = x - OBJ.x_pos , y - OBJ.y_pos
    OBJ.y_speed = dy * 3
    OBJ.x_speed = dx  * 3
    OBJ.angle = math.atan(OBJ.y_speed / OBJ.x_speed )
    if (OBJ.x_speed < 0) then
        OBJ.angle = OBJ.angle + math.pi
    end
    OBJ.x_pos = OBJ.x_pos + OBJ.x_speed * dt
    OBJ.y_pos = OBJ.y_pos + OBJ.y_speed * dt
end


function love.mousemoved(x, y, _, _, _)
    RECT_X, CURSOR_X = x, x
    RECT_Y, CURSOR_Y = y, y
end



function love.draw()
    -- love.graphics.setColor(1, 0.4, 0.4)
    -- love.graphics.print(CURSOR_X, 200, 300)
    -- love.graphics.print(CURSOR_Y, 300, 300)
    -- love.graphics.print(DELTA_X, 200, 400)
    -- love.graphics.print(DELTA_Y, 300, 400)
    -- love.graphics.print(MS_DELTA, 200, 500)
    -- love.graphics.setColor(0, 0.4, 0.4)
    -- love.graphics.print(arrayToString(ARRAY), 200, 0)
    -- love.graphics.rectangle("fill", RECT_X, RECT_Y, RECT_W, RECT_H)

    -- local angle = love.timer.getTime() * 2* math.pi / 2.5
    love.graphics.draw(Asset, OBJ.x_pos, OBJ.y_pos, OBJ.angle - math.pi / 2,1,1,25/2,25/2)
end

