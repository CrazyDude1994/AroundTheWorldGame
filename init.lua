GAME_VERSION = 0.001

function init()
	--Set window properties
	love.window.setMode(1280, 720, {
		vsync = False,
		})
	love.window.setTitle("AroundTheWorld v" .. GAME_VERSION)

	--Set background color and other graphics default properties
	love.graphics.setBackgroundColor(255, 255, 255, 255)
end