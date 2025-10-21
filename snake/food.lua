local food = {
	size = 0,
	x = 0,
	y = 0,
}

local screenSize = 0

function food:load(winW)
	math.randomseed(os.time())
	screenSize = winW
	self.size = winW / 20
	food:update()
end

function food:update()
	local r = math.random(0, screenSize)
	food.x = r
	food.y = r
end

function food:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

return food