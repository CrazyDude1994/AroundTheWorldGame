require "util"
require "libs/AnAL"

Player = {}

function Player.init(planet, rotation)
	local self = {}

	self.position = rotation
	self.relativeRotation = 0
	self.sprites = {}
	self.sprites.animations = {}
	self.animations = {}
	--Player state, -1 = left, 1 = right, 0 = null
	self.state = -1
	self.lastState = -1
	self.planet = planet
	self.x, self.y = getXYFromRadian(rotation, planet.radius, 0)
	love.graphics.setDefaultFilter("nearest", "nearest")
	self.sprites.idle = love.graphics.newImage("data/images/player/thePlayer_right.png")

	function self.draw()
		love.graphics.push()
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.translate(self.x, self.y)
		if self.state == 0 then
			love.graphics.draw(self.sprites.idle, 0, 0, math.rad(self.relativeRotation - 90), self.lastState, 1, 16, 32)
		else
			self.animations.walk:draw(0, 0, math.rad(self.relativeRotation - 90), self.state, 1, 16, 32)
		end
		love.graphics.pop()
	end

	function self.updatePos()
		self.x, self.y = getRelativePositionToHill(self.position, self.planet)
		local hillBefore, hillAfter = getBetweenHills(self.position, self.planet)
		self.relativeRotation = findRotation(hillBefore.x, hillBefore.y, hillAfter.x, hillAfter.y)
		debug.update(debugVars.playerRelativeRotation, self.relativeRotation)
	end

	function self.moveClockWise(distance)
		self.state = -1
		self.lastState = -1
		self.position = self.position + distance
		if self.position > 360 then
			self.position = self.position - 360
		end
		self.updatePos()
	end

	function self.moveCounterClockWise(distance)
		self.state = 1
		self.lastState = 1
		self.position = self.position - distance
		if self.position < 0 then
			self.position = 360 + self.position
		end
		self.updatePos()
	end

	function self.stop()
		self.state = 0
	end

	function self.update(dt)
		self.animations.walk:update(dt)
	end

	function self.loadAnimation(name, image, height, width, duration, onLoop)
		local image = love.graphics.newImage(image)
		if image then
			self.sprites.animations[name] = image
			local animation = newAnimation(image, width, height, 0.1, 9)
			self.animations[name] = animation
		end
	end

	self.loadAnimation("walk", "data/images/player/thePlayer_walk.png", 32, 32, 0.1)

	return self

end