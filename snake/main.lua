local snake = require("snake")
local food = require("food")
local score = require("score")

local game = {
	window = {
		title = "Snake",
		screenSize = 640
	}
}

function love.load()
	love.window.setTitle(game.window.title)

	local screenSize = game.window.screenSize
	love.window.setMode(screenSize, screenSize)

	score:load(screenSize)
	snake:load(screenSize)
	food:load(snake.size, screenSize)
	snake:setFood(food)
	snake:setScore(score)
end

local loop_cooldown = 0
local max_loop_cooldown = 0.6
local lockedDirection = false

function love.update(dt)
	loop_cooldown = loop_cooldown + dt
	if loop_cooldown >= max_loop_cooldown then
		loop_cooldown = 0
		lockedDirection = false
		snake:update(dt)
	end
end

function love.draw()
	food:draw()
	snake:draw()
	score:draw()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif not lockedDirection then
		if key == "w" or key == "up" then
			snake:setDirection("up")
		elseif key == "a" or key == "left" then
			snake:setDirection("left")
		elseif key == "s" or key == "down" then
			snake:setDirection("down")
		elseif key == "d" or key == "right" then
			snake:setDirection("right")
		end
		lockedDirection = true
	end
end