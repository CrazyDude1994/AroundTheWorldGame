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
		if #self.hills >= 4 then
			love.graphics.line(self.hills)
			love.graphics.line(self.hills[1], self.hills[2], self.hills[#self.hills - 1], self.hills[#self.hills])
		else
			love.graphics.circle("line", self.x, self.y, self.radius)
		end
		love.graphics.pop()
	end

	function self.addHill(radius, height)
		local x, y = getXYFromRadian(radius, self.radius, height)
		table.insert(self.hills, x)
		table.insert(self.hills, y)
	end

	function self.randomizeShape(max, step, min)
		for i = 0, 359, step or 1 do
			self.addHill(i, love.math.random(min or 0, max))
		end
	end

	return self
end