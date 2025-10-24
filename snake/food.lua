---@class food
---@field pos number
---@field img love.Image
local food = {
	size = 0,
	pos = 0,
	img = love.graphics.newImage("/assets/apple.png"),
}

local screenSize = 0

---@param size number
---@param boundary number
function food:load(size, boundary)
	math.randomseed(os.time())
	self.size = size
	screenSize = boundary
	self:update()
end

---@param tailSet table<number, {x: number, y: number}>
function food:update(tailSet)
	local pos = self:_generatePosition()
	if tailSet == nil then
		self.pos = pos
		return
	end

	local validPos = false

	while not validPos do
		validPos = true
		for _, tail in ipairs(tailSet) do
			if pos == tail.x and pos == tail.y then
				validPos = false
				pos = self:_generatePosition()
				break
			end
		end
	end

	self.pos = pos
end

function food:_generatePosition()
	local r = math.random(0, screenSize)
	return math.floor(r / self.size) * self.size
end

-- ---@param tailSet table<number, {x: number, y: number}>
-- function food:update(tailSet)
-- 	local pos = self:_generatePosition()
-- 	food.pos = pos
-- end

function food:draw()
	love.graphics.draw(self.img, self.pos, self.pos, 0, 1, 1, self.size/2, self.size/2)
end

return food