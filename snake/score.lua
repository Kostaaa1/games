---@class score
---@field value number
local score = {
	value = 0,
}

local screenSize = 0

function score:load(winW)
	screenSize = winW
end

function score:update()
	self.value = self.value + 5
end

function score:draw()
	love.graphics.setColor(1, 1, 1)
	local str = "Score: " .. self.value
    love.graphics.print(str, screenSize - #str - 100, 20, 0, 1.4, 1.4)
    love.graphics.rectangle("fill", screenSize - #str - 100, 20, 0, 1.4, 1.4)
end

return score