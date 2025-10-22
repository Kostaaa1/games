---@class snake
---@field size number
---@field food food
---@field score score
---@field tails table<number, {x: number, y: number}>
---@field direction string
---@field dead boolean
local snake = {
	size = 0,
	direction = "right",
	tails = {},
	dead = false,
	food = nil,
	score = nil,
}

local tailSet = {}
local screenSize = 0

---@param size number
function snake:load(size)
	screenSize = size

	local startX = size / 2
	local startY = size / 2
	self.size = size / 20

	self.tails[1] = {x = startX, y = startY}
	-- self.tails[2] = {x = startX-self.size, y = startY}
	-- self.tails[3] = {x = startX-self.size*2, y = startY}
	-- self.tails[4] = {x = startX-self.size*3, y = startY}
	-- self.tails[5] = {x = startX-self.size*4, y = startY}

	-- self.tails[1] = {x = startX, y = startY}
	-- self.tails[2] = {x = startX, y = startY+self.size}
	-- self.tails[3] = {x = startX, y = startY+self.size*2}
	-- self.tails[4] = {x = startX, y = startY+self.size*3}
	-- self.tails[5] = {x = startX, y = startY+self.size*4}
end

---@param dt number
function snake:update(dt)
	if self.dead then return end

	local head = self:_move()

	if self.direction == "left" then
		snake:_moveLeft(head)
	elseif self.direction == "right" then
		snake:_moveRight(head)
	elseif self.direction == "up" then
		snake:_moveUp(head)
	elseif self.direction == "down" then
		snake:_moveDown(head)
	end

	snake:_eat()
	snake:_check_collision()
end

function snake:draw()
	for index, value in ipairs(self.tails) do
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", value.x, value.y, self.size, self.size)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", value.x, value.y, self.size, self.size)
	end
end

---@param food food
function snake:setFood(food)
	self.food = food
end

---@param score score
function snake:setScore(score)
	self.score = score
end

---@param direction string
function snake:setDirection(direction)
	if (direction == "right" and self.direction ~= "left")
		or (direction == "left" and self.direction ~= "right")
		or (direction == "up" and self.direction ~= "down")
		or (direction == "down" and self.direction ~= "up")
	then
		self.direction = direction
	end
end

function snake:_check_collision()
	local head = self.tails[1]

	local x = head.x + self.size
	local y = head.y + self.size

	-- window collision
	if x == screenSize or x == 0 or y == screenSize or y + self.size == 0 then
		self.dead = true
	end

	-- TODO: tail collision
end

function snake:_eat()
	local head = self.tails[1]

	if head.x == self.food.x and head.y == self.food.y then
		local tail = self.tails[#self.tails]
		local secondTail = self.tails[#self.tails - 1]

		local newTail = {x = tail.x + self.size, y = tail.y}
		if secondTail ~= nil then
			if tail.y > secondTail.y or secondTail.y > tail.y then
				newTail = {x = tail.x, y = tail.y + self.size}
			end
		end

		table.insert(self.tails, #self.tails+1, newTail)

		self.food:update()
		self.score:update()
	end
end

function snake:_move()
	local head = self.tails[1]
	table.remove(self.tails)
	return head
end

---@param head { x: number, y: number }
function snake:_moveDown(head)
	local newHead = {x = head.x, y = head.y + self.size}
	table.insert(self.tails, 1, newHead)
end

---@param head { x: number, y: number }
function snake:_moveUp(head)
	local newHead = {x = head.x, y = head.y - self.size}
	table.insert(self.tails, 1, newHead)
end

---@param head { x: number, y: number }
function snake:_moveLeft(head)
	local newHead = {x = head.x - self.size, y = head.y}
	table.insert(self.tails, 1, newHead)
end

---@param head { x: number, y: number }
function snake:_moveRight(head)
	local newHead = {x = head.x - self.size, y = head.y}
	table.insert(self.tails, 1, {x = head.x + self.size, y = head.y})
end

return snake