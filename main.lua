io.stdout:setvbuf("no")
-- press f5 in VSCode to debug
if arg[2] == "debug" then
    require("lldebugger").start()
end

local loveErrorHandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return loveErrorHandler(msg)
    end
end

--- Import libs
vec2 = require("lib.hump.vector")
lume = require("lib.lume")
class = require("lib.hump.class")


function love.load()
    local World = require("src.world")
    world = World()

    local player = world:createEntity("player")
    player:createComponent("Sprite", "assets/duck.png")
    player.position = vec2(300, 300)

    -- Create text entity (attached to entity)
    local textEntity = world:createEntity("text")
    textEntity:createComponent("Text", "Hello from Text Component!")
    textEntity.position = vec2(100, 50)

    -- Create standalone text (not attached to entity)
    local Text = require("src.components.Text")
    standaloneText = Text("Standalone Text!")
    standaloneText:setColor(1, 0.5, 0) -- Orange color
    standaloneText:setHAlign("left")

    -- Print world stats for debug
    world:printSnapshot()
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.print("Hello, Sailor!")
    world:draw()

    -- Draw standalone text
    if standaloneText then
        standaloneText:drawAt(200, 150)
    end
end

function love.keypressed(key)
    local player = world:getEntity("player")
    if player then
        local sprite = player:getComponent("Sprite")
        if key == "space" then
            sprite.color = { math.random(), math.random(), math.random(), 1 }
        end
    end
end
