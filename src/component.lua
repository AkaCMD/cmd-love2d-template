local class = require("lib.hump.class")

---@class Component
local Component = class{}

-- Init the base component
---@param type_name string Identifier for the component type
function Component:init(type_name)
    self.type = type_name or "GenericComponent"
    -- Reference back to the entity will be set by Entity:AddComponent
    self.entityRef = nil
end

return Component