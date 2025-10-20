local World = require("src.world")

---@class Scene
local Scene = class {}

function Scene:init()
    self.world = World()
end

--- Called when scene is entered
function Scene:enter(previous, ...)
    -- Override in subclasses
end

--- Called when scene is left
function Scene:leave(next, ...)
    -- Override in subclasses
end

--- Called when scene is paused (pushed over)
function Scene:pause(next, ...)
    -- Override in subclasses
end

--- Called when scene is resumed (popped back to)
function Scene:resume(previous, ...)
    -- Override in subclasses
end

--- Update scene
function Scene:update(dt)
    self.world:update(dt)
end

--- Draw scene
function Scene:draw()
    self.world:draw()
end

--- Cleanup scene resources
function Scene:cleanup()
    self.world:clear()
    self.world = nil
end

return Scene
