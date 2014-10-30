local screenX, screenY = love.graphics.getWidth(), love.graphics.getHeight()

Camera = {}

function Camera.init(x, y, scaleX, scaleY, angle)

	local self = {}

	self.x = x or 0
	self.y = y or 0
	if angle then
		self.rotation = angle
	else
		self.rotation = 0
	end
	self.scaleX = scaleX or 1
	self.scaleY = scaleY or 1

	function self.setPosition(x, y)
		self.x = x
		self.y = y
		self.update()
	end

	function self.move(x, y)
		self.x = self.x + x or 0
		self.y = self.y + y or 0
		self.update()
	end

	function self.rotate(angle)
		self.rotation = self.rotation + math.rad(angle)
		self.update()
	end

	function self.setRotation(angle)
		self.rotation = math.rad(angle)
	end

	function self.getRotation()
		return self.rotation
	end

	function self.getPosition()
		return self.x, self.y
	end

	function self.setScale(scaleX, scaleY)
		self.scaleX = scaleX or 1
		self.scaleY = scaleY or 1
		self.update()
	end

	function self.scale(scaleX, scaleY)
		self.scaleX = self.scaleX + scaleX
		self.scaleY = self.scaleY + scaleY
		self.update()
	end

	function self.getScale()
		return self.scaleX, self.scaleY
	end

	function self.set()
		love.graphics.push()
		self.update()
	end

	function self.unset()
		love.graphics.pop()
	end

	function self.update()
		love.graphics.setBackgroundColor(255, 255, 255, 255)
		love.graphics.translate(-self.x + (screenX / 2), -self.y + (screenY / 2))
		love.graphics.translate(self.x, self.y)
		love.graphics.scale(self.scaleX, self.scaleY)
		love.graphics.rotate(self.rotation)
		love.graphics.translate(-self.x, -self.y)
	end

	return self
end