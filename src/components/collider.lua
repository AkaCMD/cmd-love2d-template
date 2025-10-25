local Component = require("src.component")

---@class Collider : Component
local Collider = class { __includes = Component }

function Collider:init(offset, size)
    Component.init(self, "Collider")
    self.offset = vec2(0, 0)
    self.size = vec2(32, 32)
end

---@return table {x, y, w, h}
function Collider:getAABB()
    local entity = self:getEntity()
    local pos = entity.position + self.offset

    return {
        x = pos.x - self.size.x / 2,
        y = pos.y - self.size.y / 2,
        w = self.size.x,
        h = self.size.y
    }
end

function Collider:draw()
    local entity = self:getEntity()
    local aabb = self:getAABB()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("line", aabb.x, aabb.y, aabb.w, aabb.h)
    love.graphics.setColor(1, 1, 1, 1)
end

return Collider
