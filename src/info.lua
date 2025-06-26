local love = require("love")
local utils = require("src.utils")

---@class debug
---@field font love.Font
---@field messages {[string]: string}
local info = {}

---@return debug
function info.new()
  local self = {}
  self.font = love.graphics.newFont(12)
  self.messages = {}
  setmetatable(self, {__index = info})
  return self
end


function info:add(messageName, ...)
  self.messages[messageName] = utils.serializeTable({...}, messageName, false, 0)
end

function info:draw()
  local f = love.graphics.getFont()
  love.graphics.setFont(self.font)
  love.graphics.setColor(1, 1, 1, 1)
  local i = 0
  for messageName, message in pairs(self.messages) do
    love.graphics.print(messageName .. ": " .. message, 0, i * 12)
    i = i + 1
  end

  love.graphics.setFont(f)
end

return info