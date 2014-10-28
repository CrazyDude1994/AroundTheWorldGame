function Lerp(a,b,k)
	return (a + (b - a)*k);
end

function getXYFromRadian(rotation, radius, offset)
	local posX = (radius + offset) * math.sin(math.rad(rotation))
	local posY = (radius + offset) * math.cos(math.rad(rotation))
	return posX, posY
end