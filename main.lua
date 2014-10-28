require "donut"
require "util"
require "planet"
require "camera"
require "player"

io.stdout:setvbuf("no")

local screenX, screenY = love.graphics.getWidth(), love.graphics.getHeight()

local objects = {
	drawable = {
		planet = Planet.init(0, 0, 1000)
	},

	cameras = {
		mainCamera = Camera.init(0, 0, 1, 1)
	}

	--world = love.physics.newWorld(0, yg, sleep)
}

function love.draw()
	--World drawing
	objects.cameras.mainCamera.set()
	for i, v in pairs(objects.drawable) do
		v.draw()
	end
	objects.cameras.mainCamera.unset()
	--UI Drawing
	--todo
end

function love.load()
	objects.drawable.thePlayer = Player.init(objects.drawable.planet, 0)
	objects.cameras.mainCamera.setPosition(objects.drawable.thePlayer.x, objects.drawable.thePlayer.y)
	objects.drawable.planet.randomizeShape(100, 10)
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		objects.cameras.mainCamera.move(0, -100 * dt)
	end
	if love.keyboard.isDown("left") then
		objects.cameras.mainCamera.move(-100 * dt, 0)
	end
	if love.keyboard.isDown("down") then
		objects.cameras.mainCamera.move(0, 100 * dt)
	end
	if love.keyboard.isDown("right") then
		objects.cameras.mainCamera.move(100 * dt, 0)
	end

	if love.keyboard.isDown("a") then
		objects.drawable.thePlayer.moveClockWise(3 * dt)
	elseif love.keyboard.isDown("d") then
		objects.drawable.thePlayer.moveCounterClockWise(3 * dt)
	end

	if love.keyboard.isDown("w") then
		objects.cameras.mainCamera.scale(2 * dt, 2 * dt)
	elseif love.keyboard.isDown("s") then
		objects.cameras.mainCamera.scale(-2 * dt, -2 * dt)
	end
end