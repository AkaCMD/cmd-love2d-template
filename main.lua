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

function love.draw()
    love.graphics.print("Hello, Sailor!")
end