local Bird = {}
Bird.__index = Bird

function Bird:new()
    local this = {}
    setmetatable(this, Bird)

    this.width = 30
    this.height = 30

    this.x = VIRTUAL_WIDTH / 2 - this.width / 2
    this.y = VIRTUAL_HEIGHT / 2 - this.height / 2

    this.dy = 0
    this.gravity = 1000       -- Much stronger gravity
    this.jump_strength = -350 -- Stronger jump to counteract gravity

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
    love.graphics.setColor(1, 1, 0) -- Yellow
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1) -- Reset
end

setmetatable(Bird, { __call = function(_) return Bird:new() end })

return Bird
