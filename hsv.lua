-- Modified from https://gist.github.com/GigsD4X/8513963

local hsv = {}

function hsv.ToRGB(hue, sat, val)
	-- Returns the RGB equivalent of the given HSV-defined color
	-- (adapted from some code found around the web)
	
	-- If it's achromatic, just return the value
	if sat == 0 then
		return val, val, val
	end
	
	-- Get the hue sector
	hue = hue % 360
	local sector = math.floor(hue / 60)
	local offset = (hue / 60) - sector
	
	local p = val * (1 - sat)
	local q = val * (1 - sat * offset)
	local t = val * (1 - sat * (1 - offset))
	
	if sector == 0 then
		return val, t, p
	elseif sector == 1 then
		return q, val, p
	elseif sector == 2 then
		return p, val, t
	elseif sector == 3 then
		return p, q, val
	elseif sector == 4 then
		return t, p, val
	elseif sector == 5 then
		return val, p, q
	end
end

function hsv.FromRGB(red, green, blue)
	-- Returns the HSV equivalent of the given RGB-defined color
	-- (adapted from some code found around the web)
	
	local hue, sat, val
	
	local min = math.min(red, green, blue)
	local max = math.max(red, green, blue)
	
	val = max
	
	local delta = max - min
	
	-- If the color is purely black
	if max == 0 then
		sat = 0
		hue = -1
		return hue, sat, val
	end
	
	sat = delta / max

	if red == max then
		hue = (green - blue) / delta
	elseif green == max then
		hue = 2 + (blue - red) / delta
	else
		hue = 4 + (red - green) / delta
	end
	
	hue = hue * 60
	if hue < 0 then
		hue = hue + 360
	end
	
	return hue == hue and hue or 0, sat, val
end

return hsv