
---@class gc
gc = {
  list = {}
}

---comment
---@return gc
function gc:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function gc:append(entity, storage, index)
  local wrapper = {
    ent = entity,
    st = storage,
    index = index,
  }
  table.insert(gc.list, wrapper)
end
function gc:clear()
  for i, wrapper in ipairs(gc.list) do
    local ent = wrapper.ent
    if ent.pos.X < 0 or ent.pos.X  > 1000 or ent.pos.Y < 0 or ent.pos.Y > 1000 then
      table.remove(wrapper.st, wrapper.index)
      table.remove(gc.list, i)
    end
  end
  
end

return gc