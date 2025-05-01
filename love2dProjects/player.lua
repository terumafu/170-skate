-- player.lua
-- Player entity derived from base Entity

local HC = require('HC')
local Entity = require("entity")

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(x, y, width,height)
    local instance = Entity:new(x, y)
    setmetatable(instance, self)
    
    -- Player-specific properties
    instance.type = "player"
    instance.color = {0, 1, 0}  -- Green
    instance.shape = HC.rectangle(x,y,width,height)
    instance.speed = 0
    instance.maxSpeed = 30
    instance.width = width
    instance.height = height
    instance.yvel = 0
    instance.canjump = false

    return instance
end

function Player:update(dt)
    -- Handle player movement with WASD
    if self.canjump == false then
        self.yvel = self.yvel + 2 * dt
    end
    -- apply gravity
    self:move(0,self.yvel)
    if love.keyboard.isDown("up") and self.canjump == true then
        self.canjump = false
        self.yvel = -1.2
    end
    
    if love.keyboard.isDown("right") then
        self:move(self.speed * dt,0)
    end

    if love.keyboard.isDown("left") then
        self:move(-self.speed * dt,0)
    end
    
    self.shape:moveTo(self.x,self.y)
end

function Player:pumpSpeed()
    if self.canjump then
        self.speed = math.min(self.speed + self.speed + 1,self.maxSpeed)
    end
end

function Player:onCollision(vec)
    -- Player-specific collision behavior
    self.shape:move(vec.x,vec.y)
    self.x = self.x + vec.x
    self.y = self.y + vec.y
    if math.abs(vec.y) > math.abs(vec.x) and vec.y < 0 then
        self.canjump = true
    end
end


return Player
