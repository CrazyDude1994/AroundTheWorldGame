require "util"

Object = {}

function Object.init(position, planet, height, world, imageDir, shapeType)

	local self = {}
	self.planet = planet
	self.sprites = {main = nil}
	self.physics = {body = nil, shape = nil, fixture = nil}

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
		love.graphics.rotate(self.physics.body:getAngle())
		local scaleX, scaleY = ((self.physics.shape:getRadius() / self.sprites.main:getWidth()) * 2), ((self.physics.shape:getRadius() / self.sprites.main:getHeight()) * 2)
		local midX, midY = (self.sprites.main:getWidth() / 2), (self.sprites.main:getHeight() / 2)
		love.graphics.draw(self.sprites.main, 0, 0, 0, scaleX, scaleY, midX, midY)
		love.graphics.pop()
	end

	function self.update(dt)
		if self.planet then
			local pX, pY = self.planet.physics.body:getWorldCenter()
			local x, y = self.physics.body:getWorldCenter()
			local vX = pX - x
			local vY = pY - y
			local length = math.sqrt(math.pow(vX, 2) + math.pow(vY, 2))
			local dX = (vX / length)
			local dY = (vY / length)
			gX = dX * 9.81 * self.physics.body:getMass() * love.physics.getMeter()
			gY = dY * 9.81 * self.physics.body:getMass() * love.physics.getMeter()
			self.physics.body:applyForce(gX, gY, x, y)
		end
	end

	self.loadSprite(imageDir, "main")

	local x, y = getXYFromRadian(position, planet.radius, height)
	local body = love.physics.newBody(world.world, x, y, "dynamic")
	local shape
	if shapeType == "rectangle" then
		shape = love.physics.newRectangleShape(self.sprites.main:getWidth() / 32, self.sprites.main:getHeight() / love.physics.getMeter())
	elseif shapeType == "circle" then
		shape = love.physics.newCircleShape(10)
	end
	local fixture = love.physics.newFixture(body, shape, 1) -- Attach fixture to body and give it a density of 1.

	self.physics = {body = body, shape = shape, fixture = fixture}

	return self
end