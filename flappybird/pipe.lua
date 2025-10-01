local pipe = {}
pipe.__index = pipe

local min_sy = 0.2
local max_sy = 0.75

local max_space_between = 130
local ww, wh = 0, 0

function pipe:new(img, win_w, win_h, start_x, start_y, sliding_rate, print)
	local sx = 1.7
	-- local sy = 0.3

	ww, wh = win_w, win_h
	math.randomseed(os.time())

	return setmetatable({
		img = img,
		start_y = start_y,
		end_y = 0,
		x = start_x,
		y = start_y,
		sx = sx,
		sy = pipe:generate_randon_sy(),
		sliding_rate = sliding_rate,
		locked = false,
		active = true,
		print = print
	}, pipe)
end

function pipe:generate_randon_sy()
	return min_sy + math.random() * max_sy
end

function pipe:update(dt)
	if not self.active then return end

	self.x = self.x - dt * self.sliding_rate
	local scaled_img_w = self.img:getWidth() * self.sx

	if self.x <= -scaled_img_w then
		self.sy = pipe:generate_randon_sy()
		self.x = ww + scaled_img_w
	end

	-- if self.print then
	-- 	print(self.x, self.y)
	-- end
end

function pipe:draw_top()
	-- local x = self.x + self.img:getWidth() * self.sx
	-- local y = self.img:getHeight() * self.sy
	-- local r = math.pi
	-- love.graphics.draw(self.img, x, y, r, self.sx, self.sy)
	-- INSTEAD OF ROTATING USE -sy TO MIRROR THE IMAGE VERTICALLY (flipping it upside down)
	love.graphics.rectangle("fill", self.x, 0, 10, 10)
	love.graphics.draw(self.img, self.x, 0, 0, self.sx, -self.sy, 0, self.img:getHeight())
end

function pipe:draw_bottom()
	local sy = self.sy
	local img_h = self.img:getHeight() * sy

	local distance_between_pipes = self.start_y - img_h*2

	local new_h = 0
	if distance_between_pipes >= max_space_between then
		local increment_h = distance_between_pipes - max_space_between
		new_h = img_h + increment_h
	else
		local decrement_h = max_space_between - distance_between_pipes
		new_h = img_h - decrement_h
	end

	if new_h > 0 then
		sy = new_h / self.img:getHeight()
		img_h = self.img:getHeight() * sy
	end

	love.graphics.draw(self.img, self.x, self.start_y - img_h, 0, self.sx, sy)
end

function pipe:draw()
	self:draw_top()
	self:draw_bottom()
end

function pipe:stop()
	self.active = false
end

function pipe:check_collision(x, y)
	local px1 = self.x
	local py1 = self.img:getHeight() * self.sy

	print("x:", x, " y:", y, " pipe x:", px1, " pipe:", py1)

	if x >= px1 and y <= py1 then
		return true
	end

	return false
end

return pipe