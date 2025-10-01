local pipe = require("pipe")

local ground = {
	x = 0,
	y = 0,
	img = nil,
	sliding_rate = 180,
	active = true,
}

local win_w, win_h = 0, 0

function ground.load(ww, wh)
	win_w, win_h = ww, wh
	ground.img = love.graphics.newImage("assets/sprites/base.png")
	ground.y = wh - ground.img:getHeight()+18

	local img = love.graphics.newImage("/assets/sprites/pipe-green.png")
	local pipe1_start_x = win_w
	local pipe2_start_x = pipe1_start_x + win_w / 2 + img:getWidth() + 20

	ground.pipe1 = pipe:new(img, ww, wh, pipe1_start_x, ground.y, ground.sliding_rate, true)
	ground.pipe2 = pipe:new(img, ww, wh, pipe2_start_x, ground.y, ground.sliding_rate, false)
end

function ground.update(dt)
	if not ground.active then return end

	local x = ground.x - dt * ground.sliding_rate
	local max = win_w - ground.img:getWidth()

	-- TODO: max - 2 is not good solution, needs to check the ground.x, it cant have large offsets then max
	if -x <= max - 2 then
		ground.x = x
	else 
		ground.x = 0
	end

	ground.pipe1:update(dt)
	ground.pipe2:update(dt)
end

function ground.draw()
	love.graphics.draw(ground.img, ground.x, ground.y, 0, 1, 1)
	love.graphics.draw(ground.img, ground.x + ground.img:getWidth(), ground.y, 0, 1, 1)
	ground.pipe1:draw()
	ground.pipe2:draw()
end

function ground.stop()
	ground.active = false
	ground.pipe1:stop()
	ground.pipe2:stop()
end

function ground.check_ground_collision(y)
	return y >= ground.y
end

function ground.check_pipe_collisions(x, y)
	if not ground.pipe1.locked then
		return ground.pipe1:check_collision(x,y)
	end

	if not ground.pipe2.locked then
		return ground.pipe2:check_collision(x,y)
	end

	return false
end

return ground