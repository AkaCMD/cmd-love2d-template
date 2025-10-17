local Component = require("src.component")

---@class Text
local Text = class { __includes = Component }

--- Create a new text component
---@param text string The text to display
---@param font love.Font The font to use (optional, defaults to current font)
---@param color table Color table {r, g, b, a} (optional, defaults to white)
---@param align string Horizontal alignment: "left", "center", "right" (optional, defaults to "center")
---@param valign string Vertical alignment: "top", "center", "bottom" (optional, defaults to "center")
function Text:init(text, font, color, align, valign)
    Component.init(self, "Text")

    self.font = font or love.graphics.getFont()
    self.text = love.graphics.newText(self.font, text or "")
    self.color = color or { 1, 1, 1, 1 }
    self.halign = align or "center"
    self.valign = valign or "center"
    self.offset = { x = 0, y = 0 }

    -- Calculate dimensions
    self:updateDimensions()
end

--- Update the text content
---@param newText string The new text to display
function Text:set(newText)
    self.text:set(newText)
    self:updateDimensions()
    return self
end

--- Update the font
---@param newFont love.Font The new font to use
function Text:setFont(newFont)
    self.font = newFont
    self.text:setFont(newFont)
    self:updateDimensions()
    return self
end

--- Update the color
---@param newColor table Color table {r, g, b, a}
function Text:setColor(newColor)
    self.color = newColor
    return self
end

--- Update the horizontal alignment
---@param newAlign string "left", "center", or "right"
function Text:setHAlign(newAlign)
    self.halign = newAlign
    return self
end

--- Update the vertical alignment
---@param newAlign string "top", "center", or "bottom"
function Text:setVAlign(newAlign)
    self.valign = newAlign
    return self
end

--- Set offset from entity position
---@param x number X offset
---@param y number Y offset
function Text:setOffset(x, y)
    self.offset.x = x or 0
    self.offset.y = y or 0
    return self
end

--- Update text dimensions based on current text and font
function Text:updateDimensions()
    self.width, self.height = self.text:getDimensions()
end

--- Get the current text
---@return string
function Text:get()
    return self.text or ""
end

--- Get text dimensions
---@return number width, number height
function Text:getDimensions()
    return self.width, self.height
end

--- Draw the text component
function Text:draw()
    local entity = self:getEntity()
    if not entity then return end

    local x = entity.position.x + self.offset.x
    local y = entity.position.y + self.offset.y

    -- Apply horizontal alignment
    if self.halign == "left" then
        -- Nothing to do
    elseif self.halign == "right" then
        x = x - self.width
    elseif self.halign == "center" then
        x = x - self.width / 2
    end

    -- Apply vertical alignment
    if self.valign == "top" then
        -- Nothing to do
    elseif self.valign == "bottom" then
        y = y - self.height
    elseif self.valign == "center" then
        y = y - self.height / 2
    end

    -- Draw the text
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, math.floor(x), math.floor(y))
    love.graphics.setColor(1, 1, 1, 1)
end

return Text
