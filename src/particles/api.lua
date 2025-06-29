local particles = require("src.particles.pink")
local vector = require("src.math.vector")

local particleApi = {}

---@param system love.ParticleSystem
---@param x number
---@param y number
---@param count? number
---@param angle? number | vector
function particleApi:emit(system, x, y, count, angle)
    local obj = {}
    count = count or 1
    system:start()
    system:setPosition(x, y)
    if angle then
        if getmetatable(angle) == vector then
            angle = angle:toAngle()
        end
        system:setDirection(angle)
    end
    system:emit(count)
    return obj
end

return particleApi
