local Component   = require("src.component")

---@class Entity
local Entity      = class {}

-- Entity Flags
Entity.IS_DEAD    = bit.lshift(1, 0) -- 1 << 0
Entity.IS_FLIPPED = bit.lshift(1, 1) -- 1 << 1
Entity.IS_VISIBLE = bit.lshift(1, 2)
Entity.IS_ACTIVE  = bit.lshift(1, 3)

function Entity:init(id)
    self.id = id or lume.uuid()
    self.position = vec2(0, 0)
    self.velocity = vec2(0, 0)
    self.scale = vec2(1, 1)
    self.rotation = 0
    self.colliderSize = vec2(1, 1)
    self.spriteSize = vec2(1, 1)
    self.flags = bit.bor(Entity.IS_VISIBLE, Entity.IS_ACTIVE)
    self.components = {}      -- Stores components by type -> {id1 = comp1, id2 = comp2, ...}
    self._componentList = {}  -- Flat list of all components for iteration
    self._nextComponentId = 1 -- Auto-incrementing component ID
end

--- Add a component to the entity
---@param component Component component instance to add
---@param componentId string|number Optional custom ID for the component, auto-generated if not provided
---@return string|number componentId, Component component Returns the component ID and the component itself
function Entity:addComponent(component, componentId)
    local componentType = component.type
    if not componentType then
        error("Component must have a type")
    end

    -- Generate component ID if not provided
    componentId = componentId or tostring(self._nextComponentId)
    self._nextComponentId = self._nextComponentId + 1

    -- Initialize component type table if it doesn't exist
    if not self.components[componentType] then
        self.components[componentType] = {}
    end

    -- Store by type and ID
    self.components[componentType][componentId] = component
    table.insert(self._componentList, {
        id = componentId,
        type = componentType,
        component = component
    })

    -- Set back-reference and call onAdd
    component.entityRef = self
    if component.onAdd then
        component:onAdd()
    end

    return componentId, component
end

--- Create and add component
---@param componentType string
---@param ... any Parameters to create the component
---@return string|number componentId, Component component Returns the component ID and the component itself
function Entity:createComponent(componentType, ...)
    local component = Component.create(componentType, ...)
    local componentId, component = self:addComponent(component)
    return componentId, component
end

--- Removes a component from the entity
---@param componentType string The type of the component to remove
---@param componentId string|number The ID of the component to remove (optional, removes first if not specified)
---@return boolean success Returns true if component was removed
function Entity:removeComponent(componentType, componentId)
    local componentTable = self.components[componentType]
    if not componentTable then return false end

    -- If no specific ID provided, remove the first component of this type
    if not componentId then
        for id, component in pairs(componentTable) do
            componentId = id
            break
        end
    end

    local component = componentTable[componentId]
    if not component then return false end

    -- Remove from components table
    componentTable[componentId] = nil

    -- Remove from component list
    for i, compData in ipairs(self._componentList) do
        if compData.type == componentType and compData.id == componentId then
            table.remove(self._componentList, i)
            break
        end
    end

    -- Clean up empty component type tables
    if next(componentTable) == nil then
        self.components[componentType] = nil
    end

    -- Clear the back-reference and call onRemove
    component.entityRef = nil
    if component.onRemove then
        component:onRemove()
    end

    return true
end

--- Get a specific component by type and ID
---@param componentType string The type of the component
---@param componentId string|number The ID of the component (optional, returns first if not specified)
---@return Component|nil component Returns the component if found
function Entity:getComponent(componentType, componentId)
    local componentTable = self.components[componentType]
    if not componentTable then return nil end

    if componentId then
        return componentTable[componentId]
    else
        -- Return first component of this type
        for _, component in pairs(componentTable) do
            return component
        end
    end

    return nil
end

--- Get all components of a specific type
---@param componentType string The type of components to get
---@return table components Returns a table of components {id1 = comp1, id2 = comp2, ...}
function Entity:getComponents(componentType)
    return self.components[componentType] or {}
end

--- Check if entity has a component of specific type
---@param componentType string The type of component to check for
---@param componentId string|number The ID of the component (optional, checks for any if not specified)
---@return boolean hasComponent Returns true if component exists
function Entity:hasComponent(componentType, componentId)
    local componentTable = self.components[componentType]
    if not componentTable then return false end

    if componentId then
        return componentTable[componentId] ~= nil
    else
        return next(componentTable) ~= nil
    end
end

--- Get the number of components of a specific type
---@param componentType string The type of components to count
---@return number count Returns the number of components of this type
function Entity:getComponentCount(componentType)
    local componentTable = self.components[componentType]
    if not componentTable then return 0 end

    local count = 0
    for _ in pairs(componentTable) do
        count = count + 1
    end
    return count
end

--- Get all component IDs of a specific type
---@param componentType string The type of components
---@return table ids Returns a table of component IDs
function Entity:getComponentIds(componentType)
    local componentTable = self.components[componentType]
    if not componentTable then return {} end

    local ids = {}
    for id in pairs(componentTable) do
        table.insert(ids, id)
    end
    return ids
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

    for _, compData in ipairs(self._componentList) do
        local component = compData.component
        if component.update then
            component:update(dt)
        end
    end
end

--- Draws all components of the entity that have a draw method
function Entity:draw()
    if not self:hasFlag(Entity.IS_VISIBLE) then return end

    for _, compData in ipairs(self._componentList) do
        local component = compData.component
        if component.draw then
            component:draw()
        end
    end
end

return Entity
