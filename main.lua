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

    -- Print world stats for debug
    world:printSnapshot()
end

function love.update(dt)
    if world then
        world:update(dt)
    end
end

function love.draw()
    love.graphics.print("Hello, Sailor!")
    if world then
        world:draw()
    end
end

function love.keypressed(key)
    local player = world:getEntity("player")
    if player then
        local sprite = player:getComponent("Sprite")
        if key == "space" then
            sprite.color = {math.random(), math.random(), math.random(), 1}
        end
    end
end