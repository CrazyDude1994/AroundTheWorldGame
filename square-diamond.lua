function generateHeightMap(min, max)
	local result = {}
	local step = 1
	for i = 1, 360 do
		table.insert(result, 0)
	end
	result[1] = love.math.random(min, max)
	result[#result] = love.math.random(min, max)
	local i, step = 1
	while (i < 360) do
		
		step = step * 2
		i = i + step
	end
end