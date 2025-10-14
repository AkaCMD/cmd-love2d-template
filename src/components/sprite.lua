local Component = require("src.component")

local Sprite = class{__includes = Component}

function Sprite:init(imagePath, width, height)
    Component.init(self, "Sprite")
    self.image = love.graphics.newImage(imagePath)
    self.width = width or self.image:getWidth()
    self.height = height or self.image:getHeight()
    self.color = {1, 1, 1, 1}
end

function Sprite:draw()
    local entity = self:getEntity()
    if entity then
        love.graphics.setColor(self.color)
        love.graphics.draw(
            self.image,
            entity.position.x, entity.position.y,
            entity.rotation,
            entity.scale.x, entity.scale.y,
            self.width / 2, self.height / 2
        )
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Sprite