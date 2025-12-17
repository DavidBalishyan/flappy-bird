local Bird = {}
Bird.__index = Bird

local birdImage

function Bird:new()
	local this = {}
	setmetatable(this, Bird)

	if not birdImage then
		birdImage = love.graphics.newImage("assets/skins/default.png")
	end

	-- Target world size
	this.width = 30
	this.height = 30

	-- Calculate scale factors
	this.scale_x = this.width / birdImage:getWidth()
	this.scale_y = this.height / birdImage:getHeight()

	this.x = VIRTUAL_WIDTH / 2 - this.width / 2
	this.y = VIRTUAL_HEIGHT / 2 - this.height / 2

	this.dy = 0
	this.gravity = 1500 -- Stronger gravity for taller world
	this.jump_strength = -500 -- Stronger jump

	return this
end

function Bird:update(dt)
	self.dy = self.dy + self.gravity * dt
	self.y = self.y + self.dy * dt
end

function Bird:jump()
	self.dy = self.jump_strength
end

function Bird:render()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(birdImage, self.x, self.y, 0, self.scale_x, self.scale_y)
end

setmetatable(Bird, {
	__call = function(_)
		return Bird:new()
	end,
})

return Bird
