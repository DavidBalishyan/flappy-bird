local Ground = {}
Ground.__index = Ground

function Ground:new()
    local this = {}
    setmetatable(this, Ground)

    this.image = nil -- Could wait for an image, but using rectangle for now
    this.height = 20 -- ground height
    this.y = VIRTUAL_HEIGHT - this.height
    this.x = 0
    this.speed = 140 -- Match pipe speed

    return this
end

function Ground:update(dt)
    self.x = self.x - self.speed * dt
    -- scroll wrap
    if self.x <= -VIRTUAL_WIDTH then
        self.x = self.x + VIRTUAL_WIDTH
    end
end

function Ground:render()
    love.graphics.setColor(0.6, 0.4, 0.2) -- Brown
    love.graphics.rectangle('fill', self.x, self.y, VIRTUAL_WIDTH * 2, self.height)

    -- Draw a grass line
    love.graphics.setColor(0.2, 0.8, 0.2) -- Green
    love.graphics.rectangle('fill', self.x, self.y, VIRTUAL_WIDTH * 2, 5)
    love.graphics.setColor(1, 1, 1)
end

setmetatable(Ground, { __call = function(_) return Ground:new() end })

return Ground
