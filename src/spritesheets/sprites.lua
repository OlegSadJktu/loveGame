
---@class Spritesheets
---@field daun spritesheet
local sprites = {}

---@alias spritesheet {spriteSize: {width: number, height: number}, image: love.Image, [number]: {[number]: love.Quad}}

---@param imageName string
---@param xNum number
---@param yNum number
---@return spritesheet
local function newSpritesheet(imageName, xNum, yNum)
  local image = love.graphics.newImage(imageName)

  if image:getHeight() % yNum ~= 0 then
      error("Image height is not divisible by yNum")
  end

  if image:getWidth() % xNum ~= 0 then
      error("Image width is not divisible by xNum")
  end
  local spriteWidth, spriteHeight = image:getWidth() / xNum, image:getHeight() / yNum

  local spritesheet = {}
  spritesheet.spriteSize = {width = spriteWidth, height = spriteHeight}
  spritesheet.image = image
  for y = 0, yNum - 1 do
    spritesheet[y+1] = {}
    for x = 0, xNum - 1 do
      spritesheet[y+1][x+1] = love.graphics.newQuad(
        x * spriteWidth, y * spriteHeight,
        spriteWidth, spriteHeight,
        image:getDimensions()
      )
    end
  end
  return spritesheet
end

---@return spritesheet
function sprites:getDaun()
  local daun = newSpritesheet("assets/daun.png", 2, 3)
  return daun
end

function sprites:daun2()
  local daun2 = newSpritesheet("daun2.png", 1, 1)
  return daun2
end

return sprites