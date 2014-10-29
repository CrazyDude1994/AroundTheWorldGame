require "util"

Player = {}

function Player.init(planet, rotation)
	local self = {}

	self.position = rotation
	self.relativeRotation = 0
	self.sprites = {}
	self.state = 0
	self.planet = planet
	self.x, self.y = getXYFromRadian(rotation, planet.radius, 0)

	self.sprites.left = love.graphics.newImage("thePlayer_left.png")
	self.sprites.front = love.graphics.newImage("thePlayer_front.png")
	self.sprites.left = love.graphics.newImage("thePlayer_left.png")

	function self.draw()
		love.graphics.push()
		love.graphics.setColor(255, 255, 255, 255)
		--love.graphics.translate(planet.x, planet.y)
		love.graphics.translate(self.x, self.y)
		love.graphics.draw(self.sprites.front, 0, 0, math.rad(self.relativeRotation - 90), 1, 1, 16, 32)
		love.graphics.pop()
	end

	function self.updatePos()
		local rotBefore = math.floor(self.position)
		local rotAfter = math.ceil(self.position)
		if rotAfter == 360 then
			rotAfter = 0
		end
		local hillBefore = self.planet.hills[rotBefore]
		local hillAfter = self.planet.hills[rotAfter]
		local t = 1 - math.abs(rotBefore - self.position)
		self.x = hillBefore[1] * t + hillAfter[1] * (1 - t)
		self.y = hillBefore[2] * t + hillAfter[2] * (1 - t)
		self.relativeRotation = findRotation(hillBefore[1], hillBefore[2], hillAfter[1], hillAfter[2])
		debug.update(debugVars.playerRelativeRotation, self.relativeRotation)
	end

	function self.moveClockWise(distance)
		self.position = self.position + distance
		if self.position > 360 then
			self.position = self.position - 360
		end
		self.updatePos()
	end

	function self.moveCounterClockWise(distance)
		self.position = self.position - distance
		if self.position < 0 then
			self.position = 360 + self.position
		end
		self.updatePos()
	end

	return self

end