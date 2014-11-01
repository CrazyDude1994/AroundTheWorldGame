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
		self.gX = 0
		self.gY = 0
	end

	function self.setPhysics(body, shape, fixture)
		self.physics.body = body
		self.physics.shape = shape
		self.physics.fixture = fixture
	end

	return self
end