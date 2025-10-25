local loveCallbacks = {
    'directorydropped',
    'draw',
    'filedropped',
    'focus',
    'gamepadaxis',
    'gamepadpressed',
    'gamepadreleased',
    'joystickaxis',
    'joystickhat',
    'joystickpressed',
    'joystickreleased',
    'joystickremoved',
    'keypressed',
    'keyreleased',
    'load',
    'lowmemory',
    'mousefocus',
    'mousemoved',
    'mousepressed',
    'mousereleased',
    'quit',
    'resize',
    'run',
    'textedited',
    'textinput',
    'threaderror',
    'touchmoved',
    'touchpressed',
    'touchreleased',
    'update',
    'visible',
    'wheelmoved',
    'joystickadded',
}

-- returns a list of all the items in t1 that aren't in t2
local function exclude(t1, t2)
    local set = {}
    for _, item in ipairs(t1) do set[item] = true end
    for _, item in ipairs(t2) do set[item] = nil end
    local t = {}
    for item, _ in ipairs(set) do
        table.insert(t, item)
    end
    return t
end

SceneManager = class {}

function SceneManager:init()
    self._scenes = { {} }
end

function SceneManager:emit(event, ...)
    local scene = self._scenes[#self._scenes]
    if scene[event] then
        scene[event](scene, ...)
    end
end

function SceneManager:enter(next, ...)
    local previous = self._scenes[#self._scenes]

    -- Cleanup previous scene entities if it has cleanup method
    if previous and previous.cleanup then
        previous:cleanup()
    end

    self:emit("leave", next, ...)
    self._scenes[#self._scenes] = next
    self:emit("enter", previous, ...)
end

function SceneManager:push(next, ...)
    local previous = self._scenes[#self._scenes]
    self:emit("pause", next, ...)
    self._scenes[#self._scenes + 1] = next
    self:emit("enter", previous, ...)
end

function SceneManager:pop(...)
    local previous = self._scenes[#self._scenes]
    local next = self._scenes[#self._scenes - 1]

    -- Cleanup popped scene entities
    if previous and previous.cleanup then
        previous:cleanup()
    end

    self:emit("leave", next, ...)
    self._scenes[#self._scenes] = nil
    self:emit("resume", previous, ...)
end

function SceneManager:hook(options)
    options = options or {}
    local callbacks = options.include or loveCallbacks
    if options.exclude then
        callbacks = exclude(callbacks, options.exlude)
    end
    for _, callbackName in ipairs(callbacks) do
        local oldCallback = love[callbackName]
        love[callbackName] = function(...)
            if oldCallback then oldCallback(...) end
            self:emit(callbackName, ...)
        end
    end
end

return SceneManager
