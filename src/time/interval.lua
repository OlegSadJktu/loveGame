---@class Interval
---@field duration number
---@field current number
---@field callback function
local interval = {}

function interval.new(duration, callback)
  local self = {}
  self.duration = duration
  self.current = 0
  self.callback = callback
  setmetatable(self, {__index = interval})
  return self
end

function interval:update(dt)
  self.current = self.current + dt
  if self.current >= self.duration then
    self.callback()
    self.current = self.current - self.duration
  end
end

return interval