require "util"

Player = {}

function Player.init(planet, rotation)
	local self = {}

	self.rotation = rotation
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
		love.graphics.translate(planet.x, planet.y)
		love.graphics.translate(self.x, self.y)
		love.graphics.draw(self.sprites.front, 0, 0, -math.rad(self.rotation + 180))
		love.graphics.pop()
	end

	function self.updatePos()
		self.x, self.y = getXYFromRadian(self.rotation, planet.radius, 0)
	end

	return self

end