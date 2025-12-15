function love.conf(t)
    t.window.title = "Flapper Bird"
    t.window.width = 480
    t.window.height = 800
    t.window.resizable = true
    t.modules.joystick = false
    t.modules.physics = false -- We'll do simple AABB, no box2d needed
end
