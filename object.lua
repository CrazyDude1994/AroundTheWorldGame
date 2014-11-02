require "util"

Object = {}

function Object.init(position, planet)

	local self = {}
	self.position = position
	self.planet = planet
	self.sprites = {}
	self.physics = {body = nil, shape = nil, fixture = nil}
	self.gX = 0
	self.gY = -9.81 * 32

	function self.loadSprite(filename, name)
		local image = love.graphics.newImage(filename)
		if image then
			self.sprites[name] = image
		end
	end

	function self.draw()
		love.graphics.push()
		love.graphics.setColor(255, 100, 50, 255)
		love.graphics.translate(self.physics.body:getX(), self.physics.body:getY())
		love.graphics.circle("line", 0, 0, self.physics.shape:getRadius())
		love.graphics.pop()
	end

	function self.update(dt)
		local pX, pY = self.planet.physics.body:getWorldCenter()
		local x, y = self.physics.body:getWorldCenter()
		local vX = pX - x
		local vY = pY - y
		local length = math.sqrt(math.pow(vX, 2) + math.pow(vY, 2))
		local dX = (vX / length)
		local dY = (vY / length)
		self.gX = dX * 9.81 * self.physics.body:getMass()
		self.gY = dY * 9.81 * self.physics.body:getMass()
		self.physics.body:applyForce(self.gX, self.gY, x, y)
	end

	function self.setPhysics(body, shape, fixture)
		self.physics.body = body
		self.physics.shape = shape
		self.physics.fixture = fixture
	end

	return self
end