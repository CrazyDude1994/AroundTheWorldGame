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
	love.graphics.setDefaultFilter("nearest", "nearest")
	self.sprites.left = love.graphics.newImage("data/images/player/thePlayer_left.png")
	self.sprites.right = love.graphics.newImage("data/images/player/thePlayer_right.png")

	function self.draw()
		love.graphics.push()
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.translate(self.x, self.y)
		if self.state == -1 then
			love.graphics.draw(self.sprites.left, 0, 0, math.rad(self.relativeRotation - 90), 1, 1, 16, 32)
		elseif self.state == 1 then
		    love.graphics.draw(self.sprites.right, 0, 0, math.rad(self.relativeRotation - 90), 1, 1, 16, 32)
		end
		love.graphics.pop()
	end

	function self.updatePos()
		self.x, self.y = getRelativePositionToHill(self.position, self.planet)
		local hillBefore, hillAfter = getBetweenHills(self.position, self.planet)
		self.relativeRotation = findRotation(hillBefore[1], hillBefore[2], hillAfter[1], hillAfter[2])
		debug.update(debugVars.playerRelativeRotation, self.relativeRotation)
	end

	function self.moveClockWise(distance)
		self.state = -1
		self.position = self.position + distance
		if self.position > 360 then
			self.position = self.position - 360
		end
		self.updatePos()
	end

	function self.moveCounterClockWise(distance)
		self.state = 1
		self.position = self.position - distance
		if self.position < 0 then
			self.position = 360 + self.position
		end
		self.updatePos()
	end

	return self

end