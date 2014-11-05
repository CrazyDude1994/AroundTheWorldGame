require "util"
require "object"
require "physics"

Ship = {}

function Ship.init(position, planet, height, spriteName, world)
	
	local self = {}
	self.throttle = 0
	self.torque = 0
	self.object = Object.init(position, planet, height, 180, world, spriteName, "rectangle")

	debugVars.torque = debug.add("Torque")
	debugVars.throttle = debug.add("Throttle")
	debugVars.velocity = debug.add("Velocity")

	function self.draw()
		self.object.draw()
	end

	function self.update(dt)
		local faceX, faceY = self.object.physics.body:getWorldVector(0, -1)
		self.object.physics.body:applyForce(faceX * self.throttle, faceY * self.throttle)
		self.object.physics.body:applyTorque(self.torque)

		debug.update(debugVars.torque, self.torque)
		debug.update(debugVars.throttle, self.throttle)
		local x, y = self.object.physics.body:getLinearVelocity()
		debug.update(debugVars.velocity, "X :" .. x .. " Y:" .. y)
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