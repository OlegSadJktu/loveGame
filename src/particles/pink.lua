--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
---@alias particleData {system: love.ParticleSystem, kickStartSteps: number, kickStartDt: number, emitAtStart: number, blendMode: string, shader: love.Shader, texturePath: string, texturePreset: string, shaderPath: string, shaderFilename: string, x: number, y: number}
---@type {x: number, y: number, [number]: particleData}
local particles = { x = -376, y = -130 }

local image1    = LG.newImage("assets/particles/lightDot.png")
image1:setFilter("linear", "linear")
local image2 = LG.newImage("assets/particles/circle.png")
image2:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 16)
ps:setColors(1, 1, 1, 1, 1, 1, 1, 1)
ps:setDirection(-1.030376791954)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(0)
ps:setInsertMode("bottom")
ps:setLinearAcceleration(-14.749563217163, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(90, 90)
ps:setParticleLifetime(0.87031614780426, 0.45875737071037)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.27715915441513)
ps:setSizeVariation(0.14057508111)
ps:setSpeed(71.063293457031, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
table.insert(particles,
	{ system = ps, kickStartSteps = 0, kickStartDt = 0, emitAtStart = 16, blendMode = "add", shader = nil, texturePath =
	"assets/particles/lightDot.png", texturePreset = "lightDot", shaderPath = "", shaderFilename = "", x = 0, y = 0 })

local ps = LG.newParticleSystem(image2, 15)
ps:setColors(0.69921875, 0.040969848632813, 0.040969848632813, 1)
ps:setDirection(0)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(0.059800539165735)
ps:setInsertMode("top")
ps:setLinearAcceleration(0.051036551594734, 0, 0, 0)
ps:setLinearDamping(0.86251771450043, 6.5410485267639)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.079045414924622, 0.64820504188538)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.0052213757298887, 0.16207575798035)
ps:setSizeVariation(0.089456871151924)
ps:setSpeed(114.83224487305, 516.10205078125)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(1.3164769411087)
ps:setTangentialAcceleration(0, 0.10207310318947)
table.insert(particles,
	{ system = ps, kickStartSteps = 1, kickStartDt = 0.059800539165735, emitAtStart = 15, blendMode = "alpha", shader = nil, texturePath =
	"assets/particles/circle.png", texturePreset = "circle", shaderPath = "", shaderFilename = "", x = 0, y = 0 })

return particles
