local gravity_base = 9.8
local gravity_max = gravity_base * 120

local bird_max_jump_r = -0.4
local bird_max_fall_r = 1.5

local images = {
	mid = love.graphics.newImage("/assets/sprites/yellowbird-midflap.png"),
	up = love.graphics.newImage("/assets/sprites/yellowbird-upflap.png"),
	down = love.graphics.newImage("/assets/sprites/yellowbird-downflap.png"),
	active = nil,
}

local bird = {
	sx = 1.7,
	sy = 1.7,
	h = 0,
	w = 0,
	r = 0,
	x = 0,
	y = 0,
	gravity = gravity_base,
	jump_strength = 400,
	mass = 500,
	active = true,
	img = nil,
}

function bird.load(ww, wh)
	bird.img = images.mid

	local active_h = bird.img:getHeight()
	local active_w = bird.img:getWidth()

	bird.h = active_h / bird.sy
	bird.w = active_w / bird.sx
	bird.x = (ww - active_w) / 2 - 100
	bird.y = wh / 2 + active_h
end

function bird.fall(dt)
	bird.y = bird.y + bird.gravity * dt
	if bird.gravity < gravity_max then
		bird.gravity = bird.gravity + dt * bird.mass
	end
end

function bird.jump(dt)
	bird.active = true
	bird.y = bird.y - bird.jump_strength * dt
	bird.gravity = gravity_base
	-- bird.r = bird_max_jump_r
end

function bird.update(dt)
	if not bird.active then return end
	bird.fall(dt)
	if love.keyboard.isDown("space") then
		bird.jump(dt)
	end
end

function bird.wing_flap()
end

function bird.draw()
	love.graphics.draw(bird.img, bird.x, bird.y, bird.r, bird.sx, bird.sy, bird.img:getWidth(), 0)
end

function bird.stop()
	bird.active = false
end

return bird