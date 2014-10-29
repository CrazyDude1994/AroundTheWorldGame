require "util"
require "square-diamond"

Planet = {}

function Planet.init(x, y, radius)
	local self = {}

	self.radius = radius
	self.x = x
	self.y = y
	self.hills = {}

	function self.draw()
		love.graphics.push()
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.translate(self.x, self.y)
		for i = 0, 358 do
			love.graphics.line(self.hills[i][1], self.hills[i][2], self.hills[i + 1][1], self.hills[i + 1][2])
		end
		love.graphics.line(self.hills[0][1], self.hills[0][2], self.hills[#self.hills][1], self.hills[#self.hills][2])
		love.graphics.pop()
	end

	function self.addHill(radius, height)
		local x, y = getXYFromRadian(radius, self.radius, height)
		self.hills[radius] = {x, y}
	end

	function self.randomizeShape(max, step, min)
		for i = 0, 359, step or 1 do
			self.addHill(i, love.math.random(min or 0, max))
		end
	end

	for i = 0, 359 do
		self.addHill(i, 0)
	end

	return self
end