local collisions = {}

---@generic T1, T2
---@param f1 love.Fixture
---@param f2 love.Fixture
---@param type1 T1
---@param type2 T2
---@return boolean, T1, T2, boolean
function collisions.isMetas(f1, f2, type1, type2)
  if type1.type == nil or type2.type == nil then
    error("type1.type or type2.type is nil")
  end
  local data1, data2 = f1:getUserData(), f2:getUserData()
  if data1.type == type1.type and data2.type == type2.type then
    return true, data1, data2, true
  elseif data1.type == type2.type and data2.type == type1.type then
    return true, data2, data1, false
  end
  return false, nil, nil, false
end

return collisions
