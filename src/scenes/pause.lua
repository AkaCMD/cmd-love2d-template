local World = require("src.world")

---@class Pause
local Pause = {}

function Pause:enter()
    self.world = World()

    -- Create pause text entity
    local pauseEntity = self.world:createEntity("pause_text")
    pauseEntity.position = vec2(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    -- Create pause text component
    local pauseTextId, pauseText = pauseEntity:createComponent("Text", "PAUSED")
    pauseText:setFont(love.graphics.newFont(32))
        :setColor({ 1, 1, 1, 1 })
        :setHAlign("center")
        :setVAlign("center")
end

function Pause:draw()
    self.world:draw()
end

function Pause:keypressed(key)
    if key == "escape" then
        self.world:clear()
        self.world = nil
        sceneManager:pop()
    end
end

return Pause
