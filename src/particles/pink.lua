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
---@type {x: number, y: number, [number]: {system: love.ParticleSystem, kickStartSteps: number, kickStartDt: number, emitAtStart: number, blendMode: string, shader: love.Shader, texturePath: string, texturePreset: string, shaderPath: string, shaderFilename: string, x: number, y: number}}
local particles = {x=-55, y=6}

local image1 = LG.newImage("src/particles/lightDot.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 56)
ps:setColors(1, 1, 1, 1, 1, 1, 1, 1)
ps:setDirection(-1.030376791954)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(24.165685653687)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(90, 90)
ps:setParticleLifetime(0.87031614780426, 2.2000000476837)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.1970270127058)
ps:setSizeVariation(0.14057508111)
ps:setSpeed(71.063293457031, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="add", shader=nil, texturePath="src/particles/lightDot.png", texturePreset="lightDot", shaderPath="", shaderFilename="", x=0, y=0})

return particles
