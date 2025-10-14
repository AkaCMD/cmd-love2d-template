local class = require("lib.hump.class")
local vec2 = require("lib.hump.vector")
local lume = require("lib.lume")
require("component")

---@class Entity
local Entity = class{}

-- Entity Flags
Entity.IS_DEAD      = bit.lshift(1, 0)  -- 1 << 0
Entity.IS_FLIPPED   = bit.lshift(1, 1)  -- 1 << 1

function Entity:init(id)
    self.id = id or lume.uuid()
    self.pos = vec2(0, 0)
    self.colliderSize = vec2(1, 1)
    self.spriteSize = vec2(1, 1)
    self.flags = 0
    self.components = {}
    self._componentList = {}
end

--- Add a component to the entity
---@param component Component component instance to add
---@return Component The added component for method chaining
function Entity:AddComponent(component)
    local componentType = component.type
    if componentType then
        -- Store
    else
    end
    component.entityRef = self
    return component
end

function Entity:RemoveComponent()
end

function Entity:SetFlag(flag)
    self.flags = self.flags | flag
end

function Entity:UnsetFlag(flag)
    self.flags = self.flags & (~flag)
end

function Entity:HasFlag(flag)
    return (self.flags & flag) ~= 0
end

function Entity:ToggleFlag(flag)
    self.flags = self.flags ~ flag
end

return Entity