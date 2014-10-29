function Lerp(a,b,k)
	return (a + (b - a)*k);
end

function getXYFromRadian(rotation, radius, offset)
	local posX = (radius + offset) * math.sin(math.rad(rotation))
	local posY = (radius + offset) * math.cos(math.rad(rotation))
	return posX, posY
end

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end