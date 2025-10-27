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
	locked = false,
	food = nil,
	score = nil,
	screenSize = 0,
}
local tailSet = {}
local image = {
	head = love.graphics.newImage("/assets/images/snake_head.png"),
	tail = love.graphics.newImage("/assets/images/snake_tail.png"),
	body = love.graphics.newImage("/assets/images/snake_body.png"),
	headDead = love.graphics.newImage("/assets/images/snake_head_dead.png"),
	headEyesClosed = love.graphics.newImage("/assets/images/snake_head_eyes_closed.png"),
	headMouthOpen = love.graphics.newImage("/assets/images/snake_head_mouth_open.png"),
	snakeHeadTongue = love.graphics.newImage("/assets/images/snake_head_tongue.png"),
}

---@param tailSize number
---@param screenSize number
function snake:load(tailSize, screenSize)
	local startX = screenSize / 2
	local startY = screenSize / 2
	self.size = screenSize / 20
	self.screenSize = screenSize

	snake:_insertHead({x = startX, y = startY})
	snake:_insertHead({x = startX + self.size, y = startY})
end

---@param dt number
function snake:update(dt)
	if self.dead then return end

	local head = self.tails[1]
	local value = self.size

	if self.direction == "left" then
		snake:_moveLeft(value, head)
	elseif self.direction == "right" then
		snake:_moveRight(value, head)
	elseif self.direction == "up" then
		snake:_moveUp(value, head)
	elseif self.direction == "down" then
		snake:_moveDown(value, head)
	end

	snake:_eat()
	self.locked = false
end

function snake:draw()
	for index, tail in ipairs(self.tails) do
		local position = nil
		local img = nil

		if index == 1 then
			position = self:_getImagePosition(index, image.head)
			img = image.head
		elseif index == #self.tails then
			position = self:_getImagePosition(index, image.tail)
			img = image.tail
		else
			position = self:_getImagePosition(index, image.body)
			img = image.body
		end

		if position ~= nil and img ~= nil then
			love.graphics.draw(
				img,
				tail.x, tail.y,
				position.r,
				position.sx, position.sy,
				position.ox, position.oy
			)
		end
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

function snake:_flipDirection(direction)
	if direction == "right" then
		return "left"
	elseif direction == "left" then
		return "right"
	elseif direction == "up" then
		return "down"
	elseif direction == "down" then
		return "up"
	end

	return direction
end

---@param tail { x: number, y: number }
---@param prevTail { x: number, y: number }
---@return string
function snake:_detectDirection(tail, prevTail)
	if prevTail.x < tail.x then
		return "right"
	elseif prevTail.x > tail.x then
		return "left"
	elseif prevTail.y > tail.y then
		return "up"
	elseif prevTail.y < tail.y then
		return "down"
	end

	return self.direction
end

---@param tailID number
---@param img love.Image
---@return {r: number, sx: number, sy: number, ox: number, oy: number}
function snake:_getImagePosition(tailID, img, isTail)
	local direction = self.direction
	local w = img:getWidth()
	local h = img:getHeight()

	local tail = self.tails[tailID]
	local prevTail = self.tails[tailID - 1]

	local out = {
		r = 0,
		sx = self.size / w,
		sy = self.size / h,
		ox = 0,
		oy = 0,
	}

	if prevTail ~= nil then
		direction = self:_detectDirection(tail, prevTail)
	end

	if direction == "right" then
		out.r = math.pi / 2
		out.ox = 0
		out.oy = h
	elseif direction == "left" then
		out.r = -math.pi / 2
		out.ox = w
		out.oy = 0
	elseif direction == "up" then
		out.r = 0
		out.ox = 0
		out.oy = 0
	elseif direction == "down" then
		out.r = math.pi
		out.ox = w
		out.oy = h
	end

	return out
end

---@param direction string
function snake:setDirection(direction)
	if self.locked or self.dead == true then return end

	if (direction == "right" and self.direction ~= "left")
		or (direction == "left" and self.direction ~= "right")
		or (direction == "up" and self.direction ~= "down")
		or (direction == "down" and self.direction ~= "up")
	then
		self.locked = true
		self.direction = direction
	end
end

---@param head { x: number, y: number }
---@param value number
function snake:_moveDown(value, head)
	if head.y > self.screenSize - self.size * 2 then
		self.dead = true
		return
	end
	local newHead = {x = head.x, y = head.y + value}
	self:_move(newHead)
end

---@param value number
---@param head { x: number, y: number }
function snake:_moveUp(value, head)
	if head.y < self.size then
		self.dead = true
		return
	end
	local newHead = {x = head.x, y = head.y - value}
	self:_move(newHead)
end

---@param value number
---@param head { x: number, y: number }
function snake:_moveLeft(value, head)
	if head.x < self.size then
		self.dead = true
		return
	end
	local newHead = {x = head.x - value, y = head.y}
	self:_move(newHead)
end

---@param value number
---@param head { x: number, y: number }
function snake:_moveRight(value, head)
	if head.x > self.screenSize - self.size * 2 then
		self.dead = true
		return
	end
	local newHead = {x = head.x + value, y = head.y}
	self:_move(newHead)
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
	if self:_checkTailCollision(head) == true then return end
	self:_insertHead(head)
	self:_removeTail()
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

function snake:_eat()
	if self.dead then return end

	local head = self.tails[1]

	if head.x == self.food.pos and head.y == self.food.pos then
		local tail = self.tails[#self.tails]
		local beforeTail = self.tails[#self.tails - 1]

		local newTail = { x = tail.x + self.size, y = tail.y }

		if beforeTail.x > tail.x then
			newTail = { x = tail.x - self.size, y = tail.y }
		elseif beforeTail.y > tail.y then
			newTail = { x = tail.x, y = tail.y - self.size }
		elseif beforeTail.y < tail.y then
			newTail = { x = tail.x, y = tail.y + self.size }
		end

		table.insert(self.tails, #self.tails+1, newTail)
		self.food:update(self.tails)
		self.score:update()
	end
end

return snake