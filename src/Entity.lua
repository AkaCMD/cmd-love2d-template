local class = require("lib.hump.class")
local lume = require("lib.lume")

local Entity = class{}

function Entity:init(id)
    self.id = id or lume.uuid()
end