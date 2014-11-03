require "util"
require "object"

Ship = {}

function Ship.init(position, planet, spriteName, world)
	
	local self = {}

	local self.object = Object.init(position, planet)
	self.object.loadSprite()

end