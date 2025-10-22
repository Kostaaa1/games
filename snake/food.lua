---@class food
---@field x number
---@field y number
---@field img love.Image
local food = {
	size = 0,
	x = 0,
	y = 0,
	img = love.graphics.newImage("/assets/apple.png"),
}

local screenSize = 0

---@param winW number 
---@param size number
function food:load(winW, size)
	math.randomseed(os.time())
	screenSize = winW
	self.size = size
	food:update()
end

-- Bad solution, what if it spawns on the snake tail. it should always spawn at empty
function food:update()
	local r = math.random(0, screenSize)
	local pos = math.floor(r / self.size) * self.size
	food.x = pos
	food.y = pos
end

function food:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.size/2, self.size/2)
end

return food