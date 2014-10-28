require "donut"
require "util"
require "planet"
require "init"
require "camera"
require "player"

io.stdout:setvbuf("no")

local screenX, screenY = love.graphics.getWidth(), love.graphics.getHeight()

local objects = {
	drawable = {
		planet = Planet.init(100, 100, 100)
	},

	cameras = {
		mainCamera = Camera.init(0, 0, 1, 1)
	}

	--world = love.physics.newWorld(0, yg, sleep)
}


function love.draw()
	objects.cameras.mainCamera.set()
	for i, v in pairs(objects.drawable) do
		v.draw()
	end
	objects.cameras.mainCamera.unset()
end

function love.load()
	init()
	objects.drawable.thePlayer = Player.init(objects.drawable.planet, 0)
	objects.drawable.planet.randomizeShape(10, 1)
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
	if love.keyboard.isDown("w") then
		objects.cameras.mainCamera.scale(2 * dt, 2 * dt)
	elseif love.keyboard.isDown("s") then
		objects.cameras.mainCamera.scale(-2 * dt, -2 * dt)
	end
end