local World = require("src.world")

---@class Gameplay
local Gameplay = {}

function Gameplay:enter()
    self.world = World()

    -- Create player with multiple text components
    local player = self.world:createEntity("player")
    player:createComponent("Sprite", "assets/duck.png")
    player.position = vec2(300, 300)

    -- Add ID text above player
    local idTextId, idText = player:createComponent("Text", "Player ID: CMD")
    idText:setColor({ 1, 1, 1, 1 })
    idText:setOffset(0, -50) -- Above the player

    -- Add health text below player
    local healthTextId, healthText = player:createComponent("Text", "Health: 100/100")
    healthText:setColor({ 0, 1, 0, 1 })
    healthText:setOffset(0, 50) -- Below the player

    -- Print world stats for debug
    self.world:printSnapshot()
end

function Gameplay:update(dt)
    self.world:update(dt)
end

function Gameplay:draw()
    self.world:draw()
end

function Gameplay:keypressed(key)
    local player = self.world:getEntity("player")
    if player then
        local sprite = player:getComponent("Sprite")
        if key == "space" then
            sprite.color = { math.random(), math.random(), math.random(), 1 }
        end
    end

    if key == "escape" then
        sceneManager:push(require("src.scenes.pause"))
    end
end

return Gameplay
