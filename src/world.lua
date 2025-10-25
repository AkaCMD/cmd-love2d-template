local Entity = require("src.entity")

---@class World
local World = class {}

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

    self:checkCollisions()

    self:cleanup()
end

function World:checkCollisions()
    local entitiesWithColliders = {}

    for _, en in pairs(self.entities) do
        if en:hasComponent("Collider") then
            table.insert(entitiesWithColliders, en)
        end
    end

    for i = 1, #entitiesWithColliders do
        local entity1 = entitiesWithColliders[i]

        for j = i + 1, #entitiesWithColliders do
            local entity2 = entitiesWithColliders[j]

            if self:checkCollision(entity1, entity2) then
                self:handleCollision(entity1, entity2)
            end
        end
    end
end

function World:checkCollision(entity1, entity2)
    local col1 = entity1:getComponent("Collider")
    local col2 = entity2:getComponent("Collider")

    local aabb1 = col1:getAABB()
    local aabb2 = col2:getAABB()

    return self:collisionAABB(
        aabb1.x, aabb1.y, aabb1.w, aabb1.h,
        aabb2.x, aabb2.y, aabb2.w, aabb2.h
    )
end

function World:collisionAABB(pos1X, pos1Y, size1X, size1Y, pos2X, pos2Y, size2X, size2Y)
    local collisionX = pos1X + size1X >= pos2X and pos2X + size2X >= pos1X
    local collisionY = pos1Y + size1Y >= pos2Y and pos2Y + size2Y >= pos1Y
    return collisionX and collisionY
end

function World:handleCollision(entity1, entity2)
    if entity1.onCollision then
        entity1:onCollision(entity2)
    end

    if entity2.onCollision then
        entity2.onCollision(entity1)
    end
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
