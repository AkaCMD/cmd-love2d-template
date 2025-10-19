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
sceneManager = require("src.scene_manager")()

function love.load()
    sceneManager:hook()
    sceneManager:enter(require("src.scenes.gameplay"))
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
end
