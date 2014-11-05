require "util"
require "midpoint-displacement"

Planet = {}

function Planet.init(x, y, radius, roughness)
	local self = {}

	self.radius = radius --Planet radius
	self.x = x --Planet X position in world coordinates
	self.y = y --Planet Y position in world coordinates
	--Format: key = rotation, value - {x, y}
	self.hills = {} --Planet hills information
	self.vertices = {}
	--Format: value = {x, y, rotation, image}
	self.environment = {} --Planet environment information

	self.physics = {} --Planet physics information

	--Function for drawing planet
	function self.draw()
		--Push matrix
		love.graphics.push()
		love.graphics.setColor(0, 0, 0, 255)
		--Move drawing context to planet position
		love.graphics.translate(self.x, self.y)
		love.graphics.polygon("line", self.vertices)
		love.graphics.setColor(255, 255, 255, 255)
		--Draw planet environment
		for i, v in pairs(self.environment) do
			love.graphics.draw(v.image, v.x, v.y, math.rad(v.rotation - 90), 1, 1, 16, 32)
		end
		--Pop matrix back
		love.graphics.pop()
	end

	--Function that adds environment to the planet
	function self.addEnvironment(rotation, height, sprite)
		--Try to load image
		local image = love.graphics.newImage(sprite)
		if image then
			--Get X,Y position from rotation
			local x, y = getRelativePositionToHill(rotation, self)
			--Get hills that are after and before rotation
			local hillBefore, hillAfter = getBetweenHills(rotation, self)
			--Get relative rotation of environment to the planet hill
			local rotation = findRotation(hillBefore.x, hillBefore.y, hillAfter.x, hillAfter.y)
			table.insert(self.environment, 
				{x = x, y = y, rotation = rotation, image = image})
		end
	end

	--Updates vertices
	function self.updateVertices()
		for i, v in pairs(self.hills) do
			table.insert(self.vertices, v.x)
			table.insert(self.vertices, v.y)
		end
	end

	--Inits planet physics (body, fixture, shape). Should be called after shape has been made
	function self.initPhysicsShape(world)
		self.physics.body = love.physics.newBody(world, self.x, self.y, "static")
		local vertices = {}
		for i, v in pairs(self.hills) do
			table.insert(vertices, v.x)
			table.insert(vertices, v.y)
		end
		self.physics.shape = love.physics.newChainShape(true, unpack(vertices))
		self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
	end

	--Function that adds hill to the planet
	function self.addHill(rotation, height)
		local x, y = getXYFromRadian(rotation, self.radius, height)
		self.hills[rotation] = {x = x, y = y}
	end

	--Randomize shape. For testing purposes only. Should be depricated and changed to mid-replacement algorithm
	function self.randomizeShape(roughness)
		local hills = {}
		for i = 0, 359 do
			hills[i] = 0
		end
		generateHeightMap(hills, 0, 359, 360, roughness or 0)
		for i = 0, 359 do
			self.addHill(i, hills[i])
		end
		self.updateVertices()
	end

	self.randomizeShape(roughness)

	return self
end