local background = {
	current = "",
	win_w = nil,
	win_h = nil,
}

local images = {
	day = love.graphics.newImage("assets/sprites/background-day.png"),
	night = love.graphics.newImage("assets/sprites/background-night.png"),
}

function background.set(color)
	local img = images[color]
	if not img then
		error("invalid color: " .. tostring(color))
	else 
		background.current = color
	end
end

function background.get_current()
	return images[background.current]
end

function background.load(w, h, color)
	background.set(color)
	background.win_w, background.win_h = w, h
	-- TODO: add logic for background switching. maybe this could be done with threads to change the background images based on time that has passed
end

function background.draw()
	local img = background.get_current()
	local sx = background.win_w / img:getWidth()
	local sy = background.win_h / img:getHeight()
	love.graphics.draw(img, 0, 0, 0, sx, sy + 0.1)
end

return background