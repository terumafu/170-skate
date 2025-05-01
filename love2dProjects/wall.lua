-- player.lua
-- Player entity derived from base Entity

local HC = require('HC')
local Entity = require("entity")

local Wall = {}
Wall.__index = Wall
setmetatable(Wall, {__index = Entity})

function Wall:new(x, y,width, height,rotation)
    local instance = Entity:new(x, y)
    setmetatable(instance, self)
    
    -- Player-specific properties
    instance.type = "wall"
    instance.color = {1, 0, 0}  -- Green
    
    instance.shape = HC.rectangle(x,y,width,height)
    instance.width = width
    instance.height = height
    instance.rotation = rotation
    instance.shape:rotate(rotation)
    instance.shape:moveTo(x,y)
    return instance
end

function Wall:draw()
    -- Set color and draw rectangle
    love.graphics.push()
    love.graphics.setColor(self.color)
    love.graphics.translate(self.x, self.y) -- move relative (0,0) to (x,y)
    love.graphics.rotate(self.rotation)
    love.graphics.rectangle("fill", -self.width/2, -self.height/2, 
                            self.width, self.height)
    -- Draw entity type
    --love.graphics.setColor(0, 0, 0)
    --love.graphics.print(self.type,  - self.width/2 + 5, - 5)
    
    -- Reset color
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

function Wall:onCollision(other)
    -- Wall-specific collision behavior
end

function Wall:rotate(deg)
    self.shape:rotate(deg)
    self.rotation = deg
end
return Wall
