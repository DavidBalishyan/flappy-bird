local Pipe = {}
Pipe.__index = Pipe

function Pipe:new()
    local this = {}
    setmetatable(this, Pipe)

    this.x = VIRTUAL_WIDTH
    this.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 100) -- Gap Y position
    this.width = 50
    this.gapHeight = 150
    this.speed = 140 -- Faster scrolling

    this.scored = false

    return this
end

function Pipe:update(dt)
    self.x = self.x - self.speed * dt
end

function Pipe:render()
    love.graphics.setColor(0, 1, 0) -- Green

    -- Top Pipe
    -- pipe extends from y - gapHeight/2 upwards?
    -- Let's define the random Y as the center of the gap
    local gapTop = self.y - self.gapHeight / 2
    local gapBottom = self.y + self.gapHeight / 2

    -- Draw Top Pipe (from top of screen to gapTop)
    love.graphics.rectangle('fill', self.x, 0, self.width, gapTop)

    -- Draw Bottom Pipe (from gapBottom to bottom of screen)
    love.graphics.rectangle('fill', self.x, gapBottom, self.width, VIRTUAL_HEIGHT - gapBottom)

    love.graphics.setColor(1, 1, 1)
end

function Pipe:collides(bird)
    -- AABB collision simplified
    local gapTop = self.y - self.gapHeight / 2
    local gapBottom = self.y + self.gapHeight / 2

    -- Check horizontal overlap
    if bird.x + bird.width > self.x and bird.x < self.x + self.width then
        -- Check vertical overlap (collision if NOT in gap)
        if bird.y < gapTop or bird.y + bird.height > gapBottom then
            return true
        end
    end

    return false
end

setmetatable(Pipe, { __call = function(_) return Pipe:new() end })

return Pipe
