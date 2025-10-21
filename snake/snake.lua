local snake = {
	tails = {
		{x = 0, y = 0},
	},
	size = 0,
	color = "red",
}

local screenW, screenH = 0, 0
local direction = "up"
local size = 0

	-- self.tails[1] = {x = 72, y = 320}
	-- self.tails[2] = {x = 48, y = 320}
	-- self.tails[3] = {x = 36, y = 320}
	-- self.tails[4] = {x = 24, y = 320}
	-- self.tails[5] = {x = 12, y = 320}
--------------------------------------------
--- RIGHT - remove tail from table, create new tail with head.x + size and insert it at position 1
	-- self.tails[1] = {x = 72, y = 320}
	-- self.tails[2] = {x = 48, y = 320}
	-- self.tails[3] = {x = 36, y = 320}
	-- self.tails[4] = {x = 24, y = 320}
	-- self.tails[5] = {x = 12, y = 320}
--------------------------------------------
--- LEFT - remove head from table, create new tail with tail.x - size and insert it at position #self.tails
	-- self.tails[1] = {x = 72, y = 320}
	-- self.tails[2] = {x = 48, y = 320}
	-- self.tails[3] = {x = 36, y = 320}
	-- self.tails[4] = {x = 24, y = 320}
	-- self.tails[5] = {x = 12, y = 320}

---@param window_w number
---@param window_h number
function snake:load(window_w, window_h)
	screenW, screenH = window_w, window_h
	size = window_w / 20

	local startX = window_w / 2
	local startY = window_h / 2
	startX = size * 5

	-- self.tails[1] = {x = startX, y = startY}
	-- self.tails[2] = {x = startX-size, y = startY}
	-- self.tails[3] = {x = startX-size*2, y = startY}
	-- self.tails[4] = {x = startX-size*3, y = startY}
	-- self.tails[5] = {x = startX-size*4, y = startY}

	self.tails[1] = {x = startX, y = startY}
	self.tails[2] = {x = startX, y = startY-size}
	self.tails[3] = {x = startX, y = startY-size*2}
	self.tails[4] = {x = startX, y = startY-size*3}
	self.tails[5] = {x = startX, y = startY-size*4}
end

---@param dt number
function snake:update(dt)
	if direction == "left" then
		snake:moveLeft()
	elseif direction == "right" then
		snake:moveRight()
	elseif direction == "up" then
		snake:moveUp()
	elseif direction == "down" then
		snake:moveDown()
	end

	for index, value in ipairs(self.tails) do
		print("DIRECTION: ", direction, "INDEX: ", index, value.x, value.y)
	end
end

function snake:draw()
	for index, value in ipairs(self.tails) do
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", value.x, value.y, size, size)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", value.x, value.y, size, size)
	end
end

-- function snake:moveUp()
-- 	table.remove(self.tails)
-- 	local head = self.tails[1]
-- 	table.insert(self.tails, 1, {x = head.x, y = head.y - size})
-- end

-- function snake:moveDown()
-- 	table.remove(self.tails, 1)
-- 	local tail = self.tails[#self.tails]
-- 	table.insert(self.tails, #self.tails+1, {x = tail.x, y = tail.y + size})
-- end

function snake:moveDown()
end

function snake:moveUp()
	local tail = table.remove(self.tails, 1)
	local head = self.tails[#self.tails]
	table.insert(self.tails, #self.tails+1, {x = tail.x, y = head.y - size})
end

function snake:moveLeft()
	table.remove(self.tails, 1)
	local tail = self.tails[#self.tails]
	table.insert(self.tails, #self.tails+1, {x = tail.x - size, y = tail.y})
end

-- [ ] - [ ] 
-- [ ]
-- [ ]
-- [ ]
-- [ ]

function snake:moveRight()
	table.remove(self.tails)
	local head = self.tails[1]
	table.insert(self.tails, 1, {x = head.x + size, y = head.y})
end

---@param dir string
function snake:setDirection(dir)
	if (dir == "right" and direction ~= "left")
		or (dir == "left" and direction ~= "right")
		or (dir == "up" and direction ~= "down")
		or (dir == "down" and direction ~= "up")
	then
		direction = dir
	end
end

return snake