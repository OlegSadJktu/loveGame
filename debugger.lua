debugger = {info = ''}

---Add info in debugger
---@param info string
function debugger:addInfo(info)
    self.info = self.info .. '\n' .. info
end

---Return info
---@return string
function debugger.getInfo()
    return debugger.info
end

---Clear all info
function debugger.clearInfo()
    debugger.info = ''
end
