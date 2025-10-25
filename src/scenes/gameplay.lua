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
    idText:setOffset(0, -50)

    -- Add health text below player
    local healthTextId, healthText = player:createComponent("Text", "Health: 100/100")
    healthText:setColor({ 0, 1, 0, 1 })
    healthText:setOffset(0, 50)
    player:createComponent("Collider", {
        size = vec2(50, 50),
    })

    local enemy = self.world:createEntity("enemy")
    enemy:createComponent("Sprite", "assets/duck.png")
    enemy.position = vec2(500, 300)
    enemy:createComponent("Collider", {
        size = vec2(50, 50),
    })

    local enemyTextId, enemyText = enemy:createComponent("Text", "Enemy")
    enemyText:setColor({ 1, 0.5, 0.5, 1 })
    enemyText:setOffset(0, -50)
end

function Gameplay:update(dt)
    self.world:update(dt)

    local player = self.world:getEntity("player")
    if player then
        local speed = 200

        if love.keyboard.isDown("left") then
            player.position.x = player.position.x - speed * dt
        end
        if love.keyboard.isDown("right") then
            player.position.x = player.position.x + speed * dt
        end
        if love.keyboard.isDown("up") then
            player.position.y = player.position.y - speed * dt
        end
        if love.keyboard.isDown("down") then
            player.position.y = player.position.y + speed * dt
        end

        player.position.x = math.max(25, math.min(775, player.position.x))
        player.position.y = math.max(25, math.min(575, player.position.y))
    end

    self.snapshotTimer = (self.snapshotTimer or 0) + dt
    if self.snapshotTimer > 5 then
        self.world:printSnapshot()
        self.snapshotTimer = 0
    end
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
