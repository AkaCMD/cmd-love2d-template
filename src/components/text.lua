local Component = require("src.component")

---@class Text : Component
local Text = class { __includes = Component }

--- Create a new Text component
---@param text string|nil The text to display
---@param font love.Font|nil Font object (optional)
function Text:init(text, font)
    Component.init(self, "Text")

    -- Use provided font or current font
    self.font = font or love.graphics.getFont()
    self.text = text or ""

    -- Text properties
    self.color = { 1, 1, 1, 1 }
    self.halign = "center" -- "left", "center", "right"
    self.valign = "center" -- "top", "center", "bottom"
    self.offset = { x = 0, y = 0 }

    -- Cache dimensions
    self.width, self.height = self.font:getWidth(self.text), self.font:getHeight()
end

--- Set the text content
---@param text string
---@return Text
function Text:setText(text)
    self.text = text
    self.width, self.height = self.font:getWidth(text), self.font:getHeight()
    return self
end

--- Set font object
---@param font love.Font Font object
---@return Text
function Text:setFont(font)
    self.font = font
    self.width, self.height = self.font:getWidth(self.text), self.font:getHeight()
    return self
end

--- Set text color
---@param r number Red component (0-1) or table {r, g, b, a}
---@param g number|nil Green component (0-1)
---@param b number|nil Blue component (0-1)
---@param a number|nil Alpha component (0-1)
---@return Text
function Text:setColor(r, g, b, a)
    if type(r) == "table" then
        self.color = { r[1] or 1, r[2] or 1, r[3] or 1, r[4] or 1 }
    else
        self.color = { r or 1, g or 1, b or 1, a or 1 }
    end
    return self
end

--- Set horizontal alignment
---@param align string "left", "center", or "right"
---@return Text
function Text:setHAlign(align)
    self.halign = align
    return self
end

--- Set vertical alignment
---@param align string "top", "center", or "bottom"
---@return Text
function Text:setVAlign(align)
    self.valign = align
    return self
end

--- Set text offset from entity position
---@param x number X offset
---@param y number Y offset
---@return Text
function Text:setOffset(x, y)
    self.offset.x = x or 0
    self.offset.y = y or 0
    return self
end

--- Get text dimensions
---@return number width, number height
function Text:getDimensions()
    return self.width, self.height
end

--- Get text width
---@return number
function Text:getWidth()
    return self.width
end

--- Get text height
---@return number
function Text:getHeight()
    return self.height
end

--- Draw the text component (when attached to entity)
function Text:draw()
    local entity = self.entityRef
    if not entity or not self.text then return end

    local x = entity.position.x + self.offset.x
    local y = entity.position.y + self.offset.y

    self:drawAt(x, y)
end

--- Draw text at specific position (standalone usage)
---@param x number X position
---@param y number Y position
function Text:drawAt(x, y)
    if not self.text then return end

    -- Apply horizontal alignment
    if self.halign == "left" then
        -- nothing to do
    elseif self.halign == "right" then
        x = x - self.width
    elseif self.halign == "center" then
        x = x - self.width / 2
    end

    -- Apply vertical alignment
    if self.valign == "top" then
        -- nothing to do
    elseif self.valign == "bottom" then
        y = y - self.height
    elseif self.valign == "center" then
        y = y - self.height / 2
    end

    -- Draw text directly using love.graphics.print
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, math.floor(x), math.floor(y))
end

--- Update method (can be overridden for animated text, etc.)
---@param dt number Delta time
function Text:update(dt)
    -- Can be implemented for text animations
end

return Text
