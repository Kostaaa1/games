local bird = require("bird")
local background = require("background")
local ground = require("ground")
local score = require("score")

local game = {
	window = {
		title =  "Flappy bird",
		w = 480,
		h = 640,
	},
}

local function end_game()
	bird.stop()
	ground.stop()
end

local function check_bird_collision()
	local x = bird.x 
	local y = bird.y - bird.h

	if ground.check_ground_collision(y) then
		end_game()
	end

	if ground.check_pipe_collisions(x, y) then
		end_game()
	end
end

local function increment_score()
	local pipe1 = ground.pipe1
	local pipe2 = ground.pipe2

	if not pipe1.locked and pipe1.x <= bird.x then
		pipe2.locked = false
		pipe1.locked = true
		score:increment()
	end

	if not pipe2.locked and pipe2.x <= bird.x then
		pipe1.locked = false
		pipe2.locked = true
		score:increment()
	end
end

function love.load()
	love.window.setTitle(game.window.title)
	love.window.setMode(game.window.w, game.window.h)

	ground.load(game.window.w, game.window.h)
	background.load(game.window.w, game.window.h, "night")
	bird.load(game.window.w, game.window.h)
	score:new(game.window.w / 2, 80)
end

function love.update(dt)
	ground.update(dt)
	bird.update(dt)
	check_bird_collision()
	increment_score()
end

function love.draw()
	background.draw()
	bird.draw()
	ground.draw()
	score:draw()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end