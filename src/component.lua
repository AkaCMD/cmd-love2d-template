---@class Component
local Component = class {}

--- Create a component instance by type name
---@param componentType string The component type name
---@param ... any Parameters to pass to component constructor
---@return Component
function Component.create(componentType, ...)
    local success, componentClass = pcall(require, "src.components." .. componentType:lower())
    if not success then
        success, componentClass = pcall(require, componentType)
        if not success then
            error("Component class not found: " .. componentType)
        end
    end

    return componentClass(...)
end

---@param type_name string Identifier for the component type (e.g., "Health", "Physics")
function Component:init(type_name)
    self.type = type_name or "GenericComponent"
    -- Reference back to the entity will be set by Entity:AddComponent
    self.entityRef = nil
end

--- Called when component is added to an entity
function Component:onAdd()
    print(self.type .. " component added")
end

--- Called when component is removed from an entity
function Component:onRemove()
    print(self.type .. " component removed")
end

function Component:update(dt)
end

function Component:draw()
end

--- Helper to get the entity this component belongs to
---@return Entity
function Component:getEntity()
    return self.entityRef
end

return Component
