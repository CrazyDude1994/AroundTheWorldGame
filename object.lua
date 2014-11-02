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
		local lerpX, lerpY
		if (self.position >= 0) and (self.position < 90) then
			lerpX = Lerp(0, 9.81, self.position / 90)
			lerpY = Lerp(-9.81, 0, self.position / 90)
		elseif (self.position >= 90) and (self.position < 180) then
			lerpX = Lerp(9.81, 0, (self.position - 90) / 90)
			lerpY = Lerp(0, 9.81, (self.position - 90) / 90)
		elseif (self.position >= 180) and (self.position < 270) then
			lerpX = Lerp(0, -9.81, (self.position - 180) / 90)
			lerpY = Lerp(9.81, 0, (self.position - 180) / 90)
		elseif (self.position >= 270) and (self.position < 360) then
			lerpX = Lerp(-9.81, 0, (self.position - 270) / 90)
			lerpY = Lerp(0, -9.81, (self.position - 270) / 90)
		end
		self.gX = lerpX
		self.gY = lerpY
		--print(self.gX, self.gY, self.position)
		self.physics.body:applyForce(self.gX * self.physics.body:getMass(), self.gY * self.physics.body:getMass())
		self.position = findRotation(self.planet.x, self.planet.y, self.physics.body:getX(), self.physics.body:getY())
	end

	function self.setPhysics(body, shape, fixture)
		self.physics.body = body
		self.physics.shape = shape
		self.physics.fixture = fixture
	end

	return self
end