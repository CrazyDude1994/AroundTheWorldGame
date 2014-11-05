function generateHeightMap(vector, left, right, len, r)
	if (right - left < 2) then
		return
	end

	local hl = vector[left] or 0
	local hr = vector[right] or 0

	local h = (hl + hr) / 2 + love.math.random(-r * len, r * len)
	local index = math.floor(left + (right - left) / 2)
	vector[index] = h

	generateHeightMap(vector, left, index, len / 2, r)
	generateHeightMap(vector, index, right, len / 2, r)
end