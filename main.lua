-- main.lua
-- Global modules
Bird = require("bird")
Pipe = require("pipe")
Ground = require("ground")

-- Game constants
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 1000

local gameState
local bird, pipes, ground
local spawnTimer
local score
local smallFont, largeFont

-- Background
local bgSky, bgClouds, bgCities
local skyScroll, cloudsScroll, citiesScroll = 0, 0, 0
local SKY_SPEED = 10
local CLOUDS_SPEED = 30
local CITIES_SPEED = 60
local BACKGROUND_LOOP_POINT = 2000 -- Image width

function love.load()
	math.randomseed(os.time())

	-- Game State
	gameState = "start" -- start, play, done

	-- Background
	bgSky = love.graphics.newImage('assets/background/sky.png')
	bgClouds = love.graphics.newImage('assets/background/clouds.png')
	bgCities = love.graphics.newImage('assets/background/cities.png')

	-- Objects
	bird = Bird()
	pipes = {}
	ground = Ground()

	-- Timers
	spawnTimer = 0

	-- Score
	score = 0

	-- Font
	smallFont = love.graphics.newFont(14)
	largeFont = love.graphics.newFont(28)
	love.graphics.setFont(smallFont)
end

-- TODO: make love.resize, so proper resizing works

function love.update(dt)
	-- Ground should scroll in start and play
	if gameState == "start" or gameState == "play" then
		ground:update(dt)

		skyScroll = (skyScroll + SKY_SPEED * dt) % BACKGROUND_LOOP_POINT
		cloudsScroll = (cloudsScroll + CLOUDS_SPEED * dt) % BACKGROUND_LOOP_POINT
		citiesScroll = (citiesScroll + CITIES_SPEED * dt) % BACKGROUND_LOOP_POINT
	end

	if gameState == "play" then
		-- Update Bird
		bird:update(dt)

		-- Update Pipes
		spawnTimer = spawnTimer + dt
		if spawnTimer > 2.5 then -- Slightly slower spawn
			table.insert(pipes, Pipe())
			spawnTimer = 0
		end

		for i, pipe in pairs(pipes) do
			pipe:update(dt)

			-- Collision detection
			if pipe:collides(bird) then
				gameState = "done"
				-- simple sound placeholder
			end

			-- Remove pipes past left edge
			if pipe.x < -pipe.width then
				table.remove(pipes, i)
			end

			-- Score logic (simplified)
			if not pipe.scored and pipe.x + pipe.width < bird.x then
				score = score + 1
				pipe.scored = true
			end
		end

		-- Ground collision
		if bird.y + bird.height > ground.y then
			gameState = "done"
			bird.y = ground.y - bird.height
		end

		-- Ceiling collision (optional, but good practice)
		if bird.y < 0 then
			bird.y = 0
			bird.dy = 0
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "space" or key == "return" then
		if gameState == "start" then
			gameState = "play"
			bird:jump() -- Jump immediately on start
		elseif gameState == "play" then
			bird:jump()
		elseif gameState == "done" then
			-- Reset game
			gameState = "start"
			bird = Bird()
			pipes = {}
			score = 0
			spawnTimer = 0
		end
	end
end

function love.draw()
	love.graphics.push()

	-- Background
	-- love.graphics.clear(0.2, 0.6, 1, 1) -- Removed simple color

	love.graphics.draw(bgSky, -skyScroll, 0)
	love.graphics.draw(bgSky, -skyScroll + BACKGROUND_LOOP_POINT, 0)

	love.graphics.draw(bgClouds, -cloudsScroll, 0)
	love.graphics.draw(bgClouds, -cloudsScroll + BACKGROUND_LOOP_POINT, 0)

	love.graphics.draw(bgCities, -citiesScroll, 0)
	love.graphics.draw(bgCities, -citiesScroll + BACKGROUND_LOOP_POINT, 0)

	-- Draw Pipes
	for k, pipe in pairs(pipes) do
		pipe:render()
	end

	-- Draw Ground
	ground:render()

	-- Draw Bird
	bird:render()

	-- UI
	if gameState == "start" then
		love.graphics.printf("Press Enter or Space to Start", 0, 100, VIRTUAL_WIDTH, "center")
	elseif gameState == "play" then
		love.graphics.print("Score: " .. tostring(score), 8, 8)
	elseif gameState == "done" then
		love.graphics.printf("Game Over", 0, 100, VIRTUAL_WIDTH, "center")
		love.graphics.printf("Score: " .. tostring(score), 0, 140, VIRTUAL_WIDTH, "center")
		love.graphics.printf("Press Enter or Space to Restart", 0, 180, VIRTUAL_WIDTH, "center")
	end

	love.graphics.pop()
end
