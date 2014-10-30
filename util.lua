function Lerp(a,b,k)
	return (a + (b - a)*k);
end

function getXYFromRadian(rotation, radius, offset)
	local posX = (radius + offset) * math.sin(math.rad(rotation))
	local posY = (radius + offset) * math.cos(math.rad(rotation))
	return posX, posY
end

function getRelativePositionToHill(rotation, planet)
	local rotBefore, rotAfter = getBetweenRotations(rotation, planet)
	local hillBefore, hillAfter = getBetweenHills(rotation, planet)
	local t = 1 - math.abs(rotBefore - rotation)
	local x = hillBefore[1] * t + hillAfter[1] * (1 - t)
	local y = hillBefore[2] * t + hillAfter[2] * (1 - t)
	return x, y
end

function getBetweenRotations(rotation, planet)
	local rotBefore = math.floor(rotation)
	local rotAfter = math.ceil(rotation)
	if rotAfter == 360 then
		rotAfter = 0
	end
	return rotBefore, rotAfter
end

function getBetweenHills(rotation, planet)
	local rotBefore, rotAfter = getBetweenRotations(rotation, planet)
	local hillBefore = planet.hills[rotBefore]
	local hillAfter = planet.hills[rotAfter]
	return hillBefore, hillAfter
end

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end