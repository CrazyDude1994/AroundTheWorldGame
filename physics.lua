Physics = {}

function Physics.init(pixelFactor)
	
	local self = {}

	love.physics.setMeter(pixelFactor)
	self.world = love.physics.newWorld(0, 0, true)
	self.objects = {}

	function self.update(dt)
		for i, v in pairs(self.objects) do
			v.update(dt)
			v.physics.body:applyForce(v.gX, v.gY)
		end
		self.world:update(dt)
	end

	function self.addObject(object)
		table.insert(self.objects, object)
	end

	return self
end