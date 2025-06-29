local timer = {}

---@class Timer
---@field duration number
---@field current number
---@field callback function
timer = {}

local timerMt = {
  __index = timer
}


---@param duration number
---@param callback function
---@return Timer
function timer.new(duration, callback)
  local new = setmetatable({
    duration = duration,
    current = 0,
    callback = callback
  }, timerMt)
  return new
end

---@param dt number
---@return boolean
function timer:update(dt)
  self.current = self.current + dt
  if self.current >= self.duration then
    self.callback()
    self.current = 0
    return true
  end
  return false
end

return timer
