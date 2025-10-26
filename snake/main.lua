local snake = require("snake")
local food = require("food")
local score = require("score")
local gameT = require("game")

local game = {
	tailImg = love.graphics.newImage("/assets/images/grass.jpg"),
	window = {
		title = "Snake",
		screenSize = 640
	}
}

function love.load()
	love.window.setTitle(game.window.title)
	local screenW = game.window.screenSize
	local tailSize  = screenW / 20
	love.window.setMode(screenW, screenW)

	score:load(screenW)
	snake:load(tailSize, screenW)
	food:load(tailSize, screenW)
	snake:setFood(food)
	snake:setScore(score)
end

local loop_cooldown = 0
local max_loop_cooldown = 0.1

function love.update(dt)
	loop_cooldown = loop_cooldown + dt
	if loop_cooldown >= max_loop_cooldown then
		loop_cooldown = 0
		snake:update(dt)
	end
end

function love.draw()
	gameT:draw()
	food:draw()
	score:draw()
	snake:draw()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "w" or key == "up" then
		snake:setDirection("up")
	elseif key == "a" or key == "left" then
		snake:setDirection("left")
	elseif key == "s" or key == "down" then
		snake:setDirection("down")
	elseif key == "d" or key == "right" then
		snake:setDirection("right")
	end
end