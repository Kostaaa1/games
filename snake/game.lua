local screenSize = 640

local game = {
	tailImg = love.graphics.newImage("/assets/images/grass.jpg"),
	screenSize = screenSize,
	tailSize = screenSize / 20,
}

function game:draw()
	local w = game.tailImg:getWidth()
	local h = game.tailImg:getHeight()

	for row = 0, screenSize, 32 do
		for col = 0, screenSize, 32 do
			love.graphics.draw(game.tailImg, row, col, 0, self.tailSize / w, self.tailSize / h)
		end
	end
end

return game