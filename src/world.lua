local Entity = require("src.entity")

---@class World
local World = class{}

function World:init()
    self.entities = {}
    self.toRemove = {}
end

function World:createEntity(id)
    local entity = Entity(id)
    self:addEntity(entity)
    return entity
end

function World:addEntity(entity)
    self.entities[entity.id] = entity
end

function World:removeEntity(entity)
    self.toRemove[entity.id] = entity
end

function World:_immediateRemove(entity)
    self.entities[entity.id] = nil
end

--- Get an entity by ID
---@param id string Entity ID
---@return Entity|nil
function World:getEntity(id)
    return self.entities[id]
end

-- @return table<string, Entity>
function World:getAllEntities()
    return self.entities
end

--- Update all entities
---@param dt number Delta time
function World:update(dt)
    for _, entity in pairs(self.entities) do
        if entity:hasFlag(Entity.IS_ACTIVE) then
            entity:update(dt)
        end

        if entity:hasFlag(Entity.IS_DEAD) then
            self:removeEntity(entity)
        end
    end

    self:cleanup()
end

--- Draw all entities
function World:draw()
    for _, entity in pairs(self.entities) do
        if entity:hasFlag(Entity.IS_VISIBLE) then
            entity:draw()
        end
    end
end

--- Remove all entities marked for removal
function World:cleanup()
    for _, entity in pairs(self.toRemove) do
        self:_immediateRemove(entity)
    end
    self.toRemove = {}
end

--- Clear all entities from the world
function World:clear()
    self.entities = {}
    self.toRemove = {}
end


--- Print world information
function World:printSnapshot()
    print("=== All Entities ===")
    for _, entity in pairs(self.entities) do
        print(string.format("Entity ID: %s", entity.id))
        local componentTypes = {}
        for type, _ in pairs(entity.components) do
            table.insert(componentTypes, type)
        end
        table.sort(componentTypes)
        print(string.format("  Components: %s", table.concat(componentTypes, ", ")))
        print()
    end
end


return World