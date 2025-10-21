local snake = require("snake")
local food = require("food")

local game = {
	window = {
		title = "Snake",
		w = 640,
		h = 640
	}
}

function love.load()
	love.window.setTitle(game.window.title)

	local ww , wh = game.window.w, game.window.h
	love.window.setMode(ww, wh)

	snake:load(ww, wh)
	food:load(ww)
end

local loop_cooldown = 0
local max_loop_cooldown = 0.5

function love.update(dt)
	loop_cooldown = loop_cooldown + dt
	if loop_cooldown >= max_loop_cooldown then
		loop_cooldown = 0
		snake:update(dt)
	end
end

function love.draw()
	food:draw()
	snake:draw()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "w" then
		snake:setDirection("up")
	elseif key == "a" then
		snake:setDirection("left")
	elseif key == "s" then
		snake:setDirection("down")
	elseif key == "d" then
		snake:setDirection("right")
	end
end
