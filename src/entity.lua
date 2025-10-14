require("src.component")

---@class Entity
local Entity = class{}

-- Entity Flags
Entity.IS_DEAD      = bit.lshift(1, 0)  -- 1 << 0
Entity.IS_FLIPPED   = bit.lshift(1, 1)  -- 1 << 1
Entity.IS_VISIBLE   = bit.lshift(1, 2)
Entity.IS_ACTIVE    = bit.lshift(1, 3)

function Entity:init(id)
    self.id = id or lume.uuid()
    self.position = vec2(0, 0)
    self.velocity = vec2(0, 0)
    self.scale = vec2(1, 1)
    self.rotation = 0
    self.colliderSize = vec2(1, 1)
    self.spriteSize = vec2(1, 1)
    self.flags = bit.bor(Entity.IS_VISIBLE, Entity.IS_ACTIVE)
    self.components = {}
    self._componentList = {}
end

--- Add a component to the entity
---@param component Component component instance to add
---@return Entity Return self, for method chaining
function Entity:addComponent(component)
    local componentType = component.type
    if componentType then
        -- Store by type for easy retrieval
        self.components[componentType] = component
        table.insert(self._componentList, component)

        if component.onAdd then
            component:onAdd()
        end
    end
    component.entityRef = self
    return self
end

--- Create and add component
---@param componentType string
---@param ... any Parameters to create the component
---@return Entity
function Entity:createComponent(componentType, ...)
    local success, componentClass = pcall(require, "src." .. componentType:lower())
    if not success then
        success, componentClass = pcall(require, componentType)
        if not success then
            error("Component class not found: " .. componentType)
        end
    end
    
    local component = componentClass(...)
    return self:addComponent(component)
end


--- Removes a component of the specified type from the entity
-- @param componentType The type (string) of the component to remove
function Entity:removeComponent(componentType)
    local component = self.components[componentType]
    if component then
        self.components[componentType] = nil
        for i, comp in ipairs(self._componentList) do
            if comp == component then
                table.remove(self._componentList, i)
                break
            end
        end
        -- Clear the back-reference
        component.entityRef = nil
    end
end

function Entity:getComponent(componentType)
    return self.components[componentType]
end

function Entity:hasComponent(componentType)
    return self.components[componentType] ~= nil
end


function Entity:setFlag(flag)
    self.flags = bit.bor(self.flags, flag)
end

function Entity:unsetFlag(flag)
    self.flags = bit.band(self.flags, bit.bnot(flag))
end

function Entity:hasFlag(flag)
    return bit.band(self.flags, flag) ~= 0
end

function Entity:toggleFlag(flag)
    self.flags = bit.bxor(self.flags, flag)
end

-- Convenience methods for common flags
function Entity:setActive(active)
    if active then
        self:setFlag(Entity.IS_ACTIVE)
    else
        self:unsetFlag(Entity.IS_ACTIVE)
    end
end

function Entity:setVisible(visible)
    if visible then
        self:setFlag(Entity.IS_VISIBLE)
    else
        self:unsetFlag(Entity.IS_VISIBLE)
    end
end

function Entity:kill()
    self:setFlag(Entity.IS_DEAD)
end

--- Updates all components of the entity that have an update method
-- @param dt Delta time
function Entity:update(dt)
    if not self:hasFlag(Entity.IS_ACTIVE) then return end

    for _, component in ipairs(self._componentList) do
        if component.update then
            component:update(dt)
        end
    end
end


--- Draws all components of the entity that have a draw method
function Entity:draw()
    if not self:hasFlag(Entity.IS_VISIBLE) then return end

    for _, component in ipairs(self._componentList) do
        if component.draw then
            component:draw()
        end
    end
end


return Entity
