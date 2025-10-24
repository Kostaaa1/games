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
	lockMovement = false,
}

local tailSet = {}
local screenSize = 0
local image = {
	head = love.graphics.newImage("/assets/images/snake_head.png"),
	tail = love.graphics.newImage("/assets/images/snake_tail.png"),
	body = love.graphics.newImage("/assets/images/snake_body.png"),
	headDead = love.graphics.newImage("/assets/images/snake_head_dead.png"),
	headEyesClosed = love.graphics.newImage("/assets/images/snake_head_eyes_closed.png"),
	headMouthOpen = love.graphics.newImage("/assets/images/snake_head_mouth_open.png"),
	snakeHeadTongue = love.graphics.newImage("/assets/images/snake_head_tongue.png"),
}

---@param size number
function snake:load(size)
	screenSize = size

	local startX = size / 2
	local startY = size / 2
	self.size = size / 20

	snake:_insertHead({x = startX, y = startY})
	snake:_insertHead({x = startX + self.size, y = startY})
end

---@param dt number
function snake:update(dt)
	if self.dead then return end

	local head = self.tails[1]

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
end

function snake:draw()
	for index, value in ipairs(self.tails) do
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", value.x, value.y, self.size, self.size)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", value.x, value.y, self.size, self.size)

		-- if index == 1 then
		-- 	local w = image.head:getWidth()
		-- 	local h = image.head:getHeight()
		-- 	love.graphics.draw(image.head, value.x, value.y, 0, self.size / w, self.size / h)
		-- elseif index == #self.tails then
		-- 	local w = image.tail:getWidth()
		-- 	local h = image.tail:getHeight()
		-- 	love.graphics.draw(image.tail, value.x, -value.y, 0, self.size / w, self.size / h)
		-- else
		-- 	local w = image.body:getWidth()
		-- 	local h = image.body:getHeight()
		-- 	love.graphics.draw(image.body, value.x, value.y, 0, self.size / w, self.size / h)
		-- end
	end
end

---@param segmentType string
---@return number
function snake:_getRotation(segmentType)
	local isTail = segmentType == "tail"
	local direction = self.direction

	if isTail == true then
		if direction == "right" then
			direction = "left"
		elseif direction == "left" then
			direction = "right"
		elseif direction == "up" then
			direction = "down"
		elseif direction == "down" then
			direction = "up"
		end
	end

	if direction == "right" then
		return math.pi / 2
	elseif direction == "left" then
		return -math.pi / 2
	elseif direction == "up" then
		return 0
	elseif direction == "down" then
		return math.pi
	end

	return -1
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

---@param head { x: number, y: number }
function snake:_moveDown(head)
	if head.y > screenSize - self.size * 2 then
		self.dead = true
		return
	end

	local newHead = {x = head.x, y = head.y + self.size}
	snake:_move(newHead)
end

---@param head { x: number, y: number }
function snake:_moveUp(head)
	if head.y < self.size then
		self.dead = true
		return
	end

	local newHead = {x = head.x, y = head.y - self.size}
	snake:_move(newHead)
end

---@param head { x: number, y: number }
function snake:_moveLeft(head)
	if head.x < self.size then
		self.dead = true
		return
	end

	local newHead = {x = head.x - self.size, y = head.y}
	snake:_move(newHead)
end

---@param head { x: number, y: number }
function snake:_moveRight(head)
	if head.x > screenSize - self.size * 2 then
		self.dead = true
		return
	end

	local newHead = {x = head.x + self.size, y = head.y}
	snake:_move(newHead)
end

---@param head { x: number, y: number }
function snake:_insertHead(head)
	table.insert(self.tails, 1, head)
	tailSet[head.x..'-'..head.y] = true
end

function snake:_removeTail()
	local tail = table.remove(self.tails, #self.tails)
	tailSet[tail.x..'-'..tail.y] = false
end

---@param head { x: number, y: number }
function snake:_move(head)
	if snake:_checkTailCollision(head) == true then return end

	snake:_insertHead(head)
	snake:_removeTail()
end

---@param head { x: number, y: number }
---@return boolean
function snake:_checkTailCollision(head)
	if tailSet[head.x..'-'..head.y] == true then
		self.dead = true
		return true
	end
	return false
end

function snake:_newTail()
	local tail = self.tails[#self.tails]
	local secondTail = self.tails[#self.tails - 1]

	local newTail = {x = tail.x + self.size, y = tail.y}
	-- NOTE: maybe better approach? this is just checking in what direction it should add the tail. If the tail is in vertical line it should add next tail en vertical line too.
	if secondTail ~= nil then
		if tail.y > secondTail.y or secondTail.y > tail.y then
			newTail = {x = tail.x, y = tail.y + self.size}
		end
	end

	table.insert(self.tails, #self.tails+1, newTail)
	self.food:update(self.tails)
	self.score:update()
end

function snake:_eat()
	if self.dead then return end

	local head = self.tails[1]
	if head.x == self.food.pos and head.y == self.food.pos then
		snake:_newTail()
	end
end

-- function snake:_drawHead()
-- 	if self.direction == "right" then
-- 		love.graphics.draw(headImages.head, self.tails[1].x, self.tails[1].y, 0, 1, 1, self.size/2, self.size/2)
-- 	elseif self.direction == "left" then
-- 		love.graphics.draw(headImages.head, self.tails[1].x, self.tails[1].y, 0, 1, 1, self.size/2, self.size/2)
-- 	elseif self.direction == "up" then
-- 		love.graphics.draw(headImages.head, self.tails[1].x, self.tails[1].y, 0, 1, 1, self.size/2, self.size/2)
-- 	elseif self.direction == "down" then
-- 		love.graphics.draw(headImages.head, self.tails[1].x, self.tails[1].y, 0, 1, 1, self.size/2, self.size/2)
-- 	end
-- end

return snake