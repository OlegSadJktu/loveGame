local vector = require("src.math.vector")
local gamera = require("src.gamera")
local info = require("src.info")
local PARTICLES = require("src.particles.pink")
local pt, pj = unpack(require("src.projectiles"))
local mc = require("src.main_char")
local daun = require("src.daun")
local papi = require("src.particles.api")
local collisions = require("src.collisions")
local particles = require("src.particles.pink")
local interval = require("src.time.interval")
local timer = require("src.time.timer")

---@class World
---@field objects table
---@field player main_char
---@field dauns Daun[]
---@field projectile Projectlies
---@field camera Gamera
---@field background love.Image
---@field physics love.World
---@field debug Info
---@field particles table
---@field interval [any]
local world = {}

local worldmt = {
	__index = world
}

---@return World
function world.default()
	local new = setmetatable({
		objects = {},
		projectile = pt.new(),
		camera = gamera.new(0, 0, 2000, 2000, 1),
		background = love.graphics.newImage("assets/background.jpg"),
		physics = love.physics.newWorld(0, 0, true),
		particles = particles,
		debug = info:new(),
	}, worldmt)
	new.player = mc:new(new)
	new.dauns = {}
	new.physics:setCallbacks(function(a, b, col)
		new:beginContact(a, b, col)
	end, function(a, b, col)
		new:endContact(a, b, col)
	end)

	new.interval = {}
	table.insert(new.interval, interval.new(1, function()
		table.insert(new.dauns, daun.new(new, 300, 300))
	end))

	return new
end

---@param a love.Fixture
---@param b love.Fixture
---@param col love.Contact
function world:beginContact(a, b, col)
	local d1, d2 = a:getUserData(), b:getUserData()
	local ok, daunData, projectileData, isSameType = collisions.isMetas(
		a, b,
		daun, pj
	)
	self.debug:add("isMetas", tostring(ok))
	if ok then
		if daunData.type == projectileData.type then
			error("daun and projectile are the same type")
		end
		local data = self.particles[2]
		local x, y = col:getPositions()
		data.system:start()
		local v = vector:new(col:getNormal())
		if not isSameType then
			v = v:negative()
		end
		papi:emit(data.system, x, y, 10, v)
		col:setEnabled(true)
		self.projectile:receive({ type = "hit", data = projectileData })
		local velocity = vector:new(projectileData.body:getLinearVelocity()):mul(0.03):length()
		daunData:receive({ type = "hit", data = { amount = velocity } })
	end
end

function world:endContact(a, b, collision)
end

---@param duration number
---@param callback function
function world:addTimer(duration, callback)
	table.insert(self.interval, timer.new(duration, callback))
end

function world:update(dt)
	if love.keyboard.isDown("space") then
		dt = dt * 0.25
	elseif love.keyboard.isDown("lshift") then
		IS_RUNNING = true
	else
		IS_RUNNING = false
	end

	self.debug:add("fps", love.timer.getFPS())
	for i, int in ipairs(self.interval) do
		local done = int:update(dt)
		if done then
			table.remove(self.interval, i)
		end
	end

	local worldX, worldY = love.graphics.getDimensions()
	local curX, curY = love.mouse.getPosition()
	curX, curY = curX - worldX / 2, curY - worldY / 2

	local mouseVector = vector:new(curX, curY)
	mouseVector = mouseVector:mul(0.5)
	self.camera:setPosition(self.player.X + mouseVector.X, self.player.Y + mouseVector.Y)


	self.player:update(dt)
	self.projectile:update(dt)
	local particleData = self.particles[1]

	if IS_RUNNING then
		particleData.system:start()
		papi:emit(particleData.system, self.player.X, self.player.Y, 10)
	end
	self.physics:update(dt)

	for _, particleData in ipairs(self.particles) do
		particleData.system:update(dt)
	end

	for _, daun in ipairs(self.dauns) do
		daun:update(dt)
	end
end

local function drawParticles()
	local blendMode = love.graphics.getBlendMode()
	for _, particleData in ipairs(PARTICLES) do
		love.graphics.setBlendMode(particleData.blendMode)
		love.graphics.setShader(particleData.shader) -- The .shader field is always nil in this example, so this line actually does nothing.
		love.graphics.draw(particleData.system, particleData.x, particleData.y)
	end
	love.graphics.setBlendMode(blendMode)
end

function world:draw()
	self.camera:draw(function(l, t, w, h)
		for i = 0, (l + w) / self.background:getWidth() do
			for j = 0, (t + h) / self.background:getHeight() do
				love.graphics.draw(self.background, i * self.background:getWidth(), j * self.background:getHeight())
			end
		end

		self.player:draw()
		self.projectile:draw()
		for _, daun in ipairs(self.dauns) do
			daun:draw()
		end
		love.graphics.setColor(1, 1, 1, 1)
		drawParticles()
		-- self:drawBodies()
	end)

	self.debug:draw()
end

function world:drawBodies()
	local bodies = self.physics:getBodies()
	for _, body in ipairs(bodies) do
		love.graphics.setColor(1, 0, 0)
		local x, y = body:getPosition()
		love.graphics.circle("line", x, y, 5)
	end
end

function world:wheelmoved(_, key)
	local scale = self.camera:getScale()
	local newScale = scale * (1 + key * 0.1)
	self.camera:setScale(newScale)
	self.debug:add("scale", scale)
end

function world:mousepressed(x, y, _)
	local pdata = self.particles[2]
	x, y = self.camera:toWorld(x, y)
	pdata.system:start()
	papi:emit(pdata.system, x, y, 10)
end

return world
