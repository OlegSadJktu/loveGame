require "love"

function AddDebugInfo(a)
    if type(a) == 'number' then
        -- a = string.format("%.2f", a)
    end
    DEBUG_INFO = DEBUG_INFO .. tostring(a) .. '\n'
end


function ClearDebug()
    DEBUG_INFO = ''
end

---return deltas and angles
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
local function deltasAndAngle(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local angle = math.atan(dy / dx)
    if (dx < 0) then
        if dy < 0 then
            angle = angle - math.pi
        else
            angle = angle + math.pi
        end
    end
    return angle, dx, dy
end

function love.mousepressed()
    pew()
end

function pew()
    local mx, my = love.mouse.getPosition()
    -- heart x, y
    local hx, hy = OBJ.x_pos, OBJ.y_pos
    local angle = deltasAndAngle(hx, hy, mx, my)
    local coef = 2
    local count = 400
    local angles = {}
    local p = math.pi / coef
    for i = 0, count - 1 do
        local giga = p / count * (i + 1)
        local a, b = angle + giga , angle - giga
        table.insert(angles, a)
        table.insert(angles, b)
    end
    table.insert(angles, angle)
    -- local angles = {angle, angle - math.pi / coef, angle + math.pi / coef}
    for i = 1, #angles do
        table.insert(BULLETS, {x = hx, y =  hy, angle = angles[i], cos = math.cos(angles[i]), sin = math.sin(angles[i])})
    end

end

function love.load()
    Asset = love.graphics.newImage('test.png')
    Bullet = love.graphics.newImage('bullet.png')
    WIDTH, HEIGHT =  800, 600
    love.window.setMode(WIDTH, HEIGHT)
    BULLETS = {}
    DEBUG_FLAG = false
    DEBUG_INFO = ''
    if #arg > 1 then
        if arg[2] == '--debug' then
            DEBUG_FLAG = true
        end
    end
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
    ClearDebug()

    AddDebugInfo(love.timer.getFPS());
    -- pew()

    local x, y = love.mouse.getPosition()
    local dx, dy = x - OBJ.x_pos , y - OBJ.y_pos
    OBJ.y_speed = dy * 300 * dt
    OBJ.x_speed = dx * 300 * dt
    OBJ.angle = math.atan(OBJ.y_speed / OBJ.x_speed )
    if (OBJ.x_speed < 0) then
        OBJ.angle = OBJ.angle + math.pi
    end
    AddDebugInfo(#BULLETS)
    OBJ.x_pos = OBJ.x_pos + OBJ.x_speed * dt
    OBJ.y_pos = OBJ.y_pos + OBJ.y_speed * dt
    SPEED = 3000

    for i = 1, #BULLETS do
        local bul = BULLETS[i]
        if bul == nil then
            goto continue
        end
        bul.x = bul.x + (dt * SPEED * bul.cos)
        bul.y = bul.y + (dt * SPEED * bul.sin)
        if not InField(bul) then
            -- table.remove(BULLETS, i)
        end
        ::continue::
    end
end

function RevertSpeed(o)

    o.angle = o.angle + math.pi
end

function InField(o)

    if (0 < o.x and o.x < WIDTH) and (0 < o.y and o.y < HEIGHT) then
        return true
    end
    return false
end



function love.mousemoved(x, y, _, _, _)
    RECT_X, CURSOR_X = x, x
    RECT_Y, CURSOR_Y = y, y
end

function math.div(a, b)
    return math.floor(a / b)
end

function getXY(x, y)
    if math.div(x, WIDTH) % 2 == 1 then
        x = WIDTH - x % WIDTH
    else
        x = x % WIDTH
    end
    if math.div(y, HEIGHT)  % 2 == 1 then
        y = HEIGHT - y % HEIGHT
    else
        y = y % HEIGHT
    end
    return x, y
end



function love.draw()
    love.graphics.setColor(0,0,0)

    -- local angle = love.timer.getTime() * 2* math.pi / 2.5
    love.graphics.draw(Asset, OBJ.x_pos , OBJ.y_pos, OBJ.angle - math.pi / 2,5,5, 25/2,25/2)
    for i, bul in ipairs(BULLETS) do
        local x, y = getXY(bul.x, bul.y)
        love.graphics.draw(Bullet, x , y  , bul.angle + math.pi / 2, 2,2,
        Bullet:getWidth() / 2, Bullet:getHeight() / 2)
    end
    if DEBUG_FLAG then
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',0,0,100,100)
        love.graphics.setColor(0,0,0)
        love.graphics.print(DEBUG_INFO, 10,10)
    end
end

