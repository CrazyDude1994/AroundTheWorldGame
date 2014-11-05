require "libs/donut"
require "util"
require "planet"
require "camera"
require "player"
require "physics"
require "object"
require "ship"

io.stdout:setvbuf("no")

--Get screen size
local screenX, screenY = love.graphics.getWidth(), love.graphics.getHeight()

--Table of the world objects
local objects = {
	--Objects that need to be drawed. Must have Draw method
	drawable = {
		planet = Planet.init(0, 0, 10000, 20)
	},

	--Table of cameras
	cameras = {
		mainCamera = Camera.init(0, 0, 1, 1)
	},

	--Physics objects
	physics = {}
}

--Table of the variables that need to be debugged.
debugVars = {}

--Main drawing function
function love.draw()
	--World drawing
	--Set camera
	objects.cameras.mainCamera.set()
	--Draw all world objects
	for i, v in pairs(objects.drawable) do
		v.draw()
	end
	--Unset camera
	objects.cameras.mainCamera.unset()
	--UI Drawing
	--Debug drawring
	debug.draw()
end

--Main load function
function love.load()
	--Create player on start
	objects.drawable.thePlayer = Player.init(objects.drawable.planet, 0)
	--Create physics world
	objects.physics.world = Physics.init(32)
	objects.drawable.planet.initPhysicsShape(objects.physics.world.world)
	--Set camera position to look at player
	objects.cameras.mainCamera.setPosition(objects.drawable.thePlayer.x, objects.drawable.thePlayer.y)
	--Add trees to planet
	for i = 0, 359 * 2 do
		objects.drawable.planet.addEnvironment(i / 2 + 0.25, 0, "data/images/nature/tree_1.png")
	end
	--Enable debug
	debug = Donut.init(10, 10)
	debugVars.playerRotation = debug.add("Player position")
	debugVars.playerRelativeRotation = debug.add("Relative rotation")
	--TEST
	objects.drawable.ship = Ship.init(0, objects.drawable.planet, 40, "data/images/objects/test_ship/ship.png", objects.physics.world)
end

function love.update(dt)
	--Update debug information
	debug.update(debugVars.playerRotation, objects.drawable.thePlayer.position)

	--Weird solution. Should be changed
	objects.drawable.thePlayer.update(dt)

	--Update world physics
	objects.physics.world.update(dt)

	--Move camera controls
	if love.keyboard.isDown("up") then
		objects.drawable.ship.increaseThrottle(dt * 50)
	end
	if love.keyboard.isDown("down") then
		objects.drawable.ship.decreaseThrottle(dt * 50)
	end
	if love.keyboard.isDown("right") then
		objects.drawable.ship.turnRight(100)
	elseif love.keyboard.isDown("left") then
		objects.drawable.ship.turnLeft(100)
	else
		objects.drawable.ship.fix()
	end

	objects.cameras.mainCamera.setPosition(objects.drawable.ship.object.physics.body:getX(), objects.drawable.ship.object.physics.body:getY())
	objects.cameras.mainCamera.setRotation(-math.deg(objects.drawable.ship.object.physics.body:getAngle()))

	--Player movement controls
	if love.keyboard.isDown("a") then
		objects.drawable.thePlayer.moveClockWise(1 * dt)
		objects.cameras.mainCamera.setPosition(objects.drawable.thePlayer.x, objects.drawable.thePlayer.y)
		objects.cameras.mainCamera.setRotation(objects.drawable.thePlayer.position - 180)
	elseif love.keyboard.isDown("d") then
		objects.drawable.thePlayer.moveCounterClockWise(1 * dt)
		objects.cameras.mainCamera.setPosition(objects.drawable.thePlayer.x, objects.drawable.thePlayer.y)
		objects.cameras.mainCamera.setRotation(objects.drawable.thePlayer.position - 180)
	else
		objects.drawable.thePlayer.stop()
	end

	--Scale camera controls
	if love.keyboard.isDown("w") then
		objects.cameras.mainCamera.scale(1.1 * dt, 1.1 * dt)
	elseif love.keyboard.isDown("s") then
		objects.cameras.mainCamera.scale(-1.1 * dt, -1.1 * dt)
	end
end