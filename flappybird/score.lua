local scores = {
	[0] = love.graphics.newImage("assets/sprites/0.png"),
	[1] = love.graphics.newImage("assets/sprites/1.png"),
	[2] = love.graphics.newImage("assets/sprites/2.png"),
	[3] = love.graphics.newImage("assets/sprites/3.png"),
	[4] = love.graphics.newImage("assets/sprites/4.png"),
	[5] = love.graphics.newImage("assets/sprites/5.png"),
	[6] = love.graphics.newImage("assets/sprites/6.png"),
	[7] = love.graphics.newImage("assets/sprites/7.png"),
	[8] = love.graphics.newImage("assets/sprites/8.png"),
	[9] = love.graphics.newImage("assets/sprites/9.png"),
}

local score = {
	value = 0,
	x = 0,
	y = 0,
	active = false,
}

function score:new(x, y)
	score.x = x
	score.y = y
end

function score:increment()
	self.value = self.value + 1
	return self.value
end

function score:setv(v)
	self.value = v
end

function score:draw()
	local s = tostring(self.value)

	local currentx = 0

	for i = 1, #s do
		local ch = s:sub(i, i)
		local img = scores[tonumber(ch)]
		local img_w = img:getWidth()

		local prevch = s:sub(i-1, i-1)

		-- TODO: DYNAMIC IMAGE SIZE
		if (ch ~= "1" and prevch == "1") or (ch == "1" and prevch == "1") then
			currentx = currentx + 16
		else
			currentx = currentx + 24
		end

		local newx = self.x + currentx
		love.graphics.draw(img, newx, self.y)
	end
end

return score