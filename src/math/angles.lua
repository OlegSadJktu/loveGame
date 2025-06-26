
---@param degrees number
---@return number
function ToRadians(degrees)
    return degrees * (math.pi / 180)
end

---@param radians number
---@return number
function ToDegrees(radians)
    return radians * (180 / math.pi)
end