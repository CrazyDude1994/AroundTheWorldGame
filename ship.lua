require "util"
require "object"
require "physics"

Ship = {}

function Ship.init(position, planet, height, spriteName, world)
	
	local self = {}
	self.throttle = 0
	self.torque = 0
	self.particleImage = love.graphics.newImage("data/images/particles/fire/fire.png")
   	self.particleSystemOptions = {
		bufferSize = 3000,
		emissionRate = 1500,
		lifetime = -1,
		particleLife = 0,
		color = { 255, 255, 255, 255, 250, 100, 0, 123 },
		size = { 0, 1, 1 },
		speed = { 131, 300 },
		spread = math.rad(5)
	}
	self.particleSystem = love.graphics.newParticleSystem(self.particleImage, self.particleSystemOptions.bufferSize)
	self.particleSystem:setBufferSize(self.particleSystemOptions.bufferSize)
	self.particleSystem:setEmissionRate(self.particleSystemOptions.emissionRate)
	self.particleSystem:setParticleLifetime(0, self.particleSystemOptions.particleLife)
	self.particleSystem:setEmitterLifetime(self.particleSystemOptions.lifetime)
	self.particleSystem:setColors(unpack(self.particleSystemOptions.color))
	self.particleSystem:setSizes(unpack(self.particleSystemOptions.size))
	self.particleSystem:setSpeed(unpack(self.particleSystemOptions.speed))
	self.particleSystem:setSpread(math.rad(self.particleSystemOptions.spread))
	self.particleSystem:start()
	self.object = Object.init(position, planet, height, 180, world, spriteName, "rectangle")

	debugVars.torque = debug.add("Torque")
	debugVars.throttle = debug.add("Throttle")
	debugVars.velocity = debug.add("Velocity")

	function self.draw()
		self.object.draw()
		love.graphics.draw(self.particleSystem)
	end

	function self.update(dt)
		local faceX, faceY = self.object.physics.body:getWorldVector(0, -1)
		self.object.physics.body:applyForce(faceX * self.throttle, faceY * self.throttle)
		self.object.physics.body:applyTorque(self.torque)

		debug.update(debugVars.torque, self.torque)
		debug.update(debugVars.throttle, self.throttle)
		local x, y = self.object.physics.body:getLinearVelocity()
		debug.update(debugVars.velocity, "X :" .. x .. " Y:" .. y)
		self.particleSystem:setPosition(self.object.physics.body:getWorldPoint(0, 32))
		self.particleSystem:setDirection(math.rad(math.deg(self.object.physics.body:getAngle()) + 90))
		self.particleSystem:setParticleLifetime(0, (self.throttle / 450))
		self.particleSystem:setSpread(math.rad((180 - (180 * (self.throttle / 450)))))
		self.particleSystem:update(dt)
	end

	function self.increaseThrottle(throttle)
		self.throttle = self.throttle + throttle 
	end

	function self.decreaseThrottle(throttle)
		self.throttle = self.throttle - throttle
	end

	function self.turnLeft(power)
		self.torque = -power
	end

	function self.turnRight(power)
		self.torque = power
	end

	function self.fix()
		self.torque = 0
	end

	world.addObject(self)

	return self
end