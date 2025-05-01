
local Entity = require("entity")

local Section = {}
Section.__index = Section
setmetatable(Section, {__index = Entity})

function Section:new(x, y, scale, address)
    local instance = Entity:new(x, y)
    setmetatable(instance, self)
    
    -- Player-specific properties
    instance.type = "section"
    --instance.color = {0, 1, 0}  -- Green
    instance.image = love.graphics.newImage("images/" .. address)
    return instance
end

function Section:draw()
    love.graphics.push()
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.pop()
end
return Section