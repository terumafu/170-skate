HC = require('HC')
local Entity = require("entity")
local Player = require("player")
local Wall = require("wall")
local Section = require("section")
local speed = 0;
local followRules = {
    ["prototype1_high_high.png"] = {"prototype1_high_high.png", "prototype1_high_low.png", "prototype1_high_med.png"},
    ["prototype1_high_med.png"] = {"prototype1_med_high.png", "prototype1_med_med.png", "prototype1_med_low.png"},
    ["prototype1_high_low.png"] = {"prototype1_low_high.png", "prototype1_low_med.png", "prototype1_low_low.png"},
    ["prototype1_med_high.png"] = {"prototype1_high_high.png", "prototype1_high_low.png", "prototype1_high_med.png"},
    ["prototype1_med_med.png"] = {"prototype1_med_high.png", "prototype1_med_med.png", "prototype1_med_low.png"},
    ["prototype1_med_low.png"] = {"prototype1_low_high.png", "prototype1_low_med.png", "prototype1_low_low.png"},
    ["prototype1_low_high.png"] = {"prototype1_high_high.png", "prototype1_high_low.png", "prototype1_high_med.png"},
    ["prototype1_low_med.png"] = {"prototype1_med_high.png", "prototype1_med_med.png", "prototype1_med_low.png"},
    ["prototype1_low_low.png"] = {"prototype1_low_high.png", "prototype1_low_med.png", "prototype1_low_low.png"},
}
local dataTable = {
    {address = "prototype1_high_high.png", front = "high",back = "high",walls = nil},
    {address = "prototype1_high_med.png", front = "high",back = "med",walls = nil},
    {address = "prototype1_high_low.png",front = "high",back = "low",walls = nil},
    {address = "prototype1_med_high.png", front = "med",back = "high",walls = {{7,64,15,5,0},{40,56,40,5,0},{70,45,30,5,0},{100,25,40,5,-3.14/12},{123,21,10,5,0}}},
    {address = "prototype1_med_med.png", front = "med",back = "med",walls = {{7,64,15,5,0},{21,71,15,5,0},{35,78,15,5,0},{45,83,15,5,0}, {59,89,15,5,0}, {85,83,30,5,0}, {125,83,10,5,0}}},
    {address = "prototype1_med_low.png", front = "med",back = "low",walls = nil},
    {address = "prototype1_low_high.png", front = "low",back = "high",walls = nil},
    {address = "prototype1_low_med.png", front = "low",back = "med",walls = nil},
    {address = "prototype1_low_low.png",front = "low",back = "low",walls = nil},
}

local entities = {}
local levels = {}
local scale = 2
local scrollX = 0
local totalWidth = 0
local screenWidth = 0
local currentSection = nil
local player = nil
function love.load()
    love.keyboard.setKeyRepeat(true)
    love.math.setRandomSeed(os.time())
    screenWidth = love.graphics.getWidth()
    local x = 0
    
    while #levels < 8 do
        local random = return_valid_index()
        currentSection = Section:new(x,0,2,dataTable[random].address)
        table.insert(entities,currentSection)
        local temp = {section = currentSection, initializedwalls = nil}
        if dataTable[random].walls ~= nil then
            temp.initializedwalls = {}
            for index, item in ipairs(dataTable[random].walls) do
                local wall = Wall:new(currentSection.x + item[1],currentSection.y + item[2],item[3],item[4],item[5])
                table.insert(entities,wall)
                table.insert(temp.initializedwalls,wall)
            end
        end
        table.insert(levels, temp)
        x = x + 128
    end
    player = Player:new(10,10,10,10)
    table.insert(entities,player)
end

function return_valid_index()
    local index = love.math.random(#dataTable)
    while true do
        if dataTable[index].walls ~= nil then
            return index
        end
        index = love.math.random(#dataTable)
    end
end

function love.keypressed(key)
    if key == "space" then
        player:pumpSpeed()
    end
end

function love.update(dt)
    if currentSection.x < screenWidth then
        local random = return_valid_index()
        currentSection = Section:new(currentSection.x + 128,0,2,dataTable[random].address)
        table.insert(entities,currentSection)
        local temp = {section = currentSection, initializedwalls = nil}
        if dataTable[random].walls ~= nil then
            temp.initializedwalls = {}
            for index, item in ipairs(dataTable[random].walls) do
                local wall = Wall:new(currentSection.x + item[1],currentSection.y + item[2],item[3],item[4],item[5])
                table.insert(entities,wall)
                table.insert(temp.initializedwalls,wall)
            end
        end
        table.insert(levels, temp)
    end

    for _, entity in ipairs(entities) do
        entity:update(dt)
    end

    diff = 0 
    if false then
        if love.keyboard.isDown('right') then
            diff = -speed 
            for _, level in ipairs(levels) do
                level.section:move(diff,0)
                if level.initializedwalls ~= nil then
                    -- update x on all walls
                    for _, wall in ipairs(level.initializedwalls) do
                        wall:move(diff,0)
                    end
                end
            end
        end
        if love.keyboard.isDown('left') then
            diff = speed
            for _, level in ipairs(levels) do
                level.section:move(diff,0)
                if level.initializedwalls ~= nil then
                    -- update x on all walls
                    for _, wall in ipairs(level.initializedwalls) do
                        wall:move(diff,0)
                    end
                end
            end
        end
    end
    for shape, seperating_vector in pairs(HC.collisions(player.shape)) do
        for  _, entity in ipairs(entities) do
            if entity.type == "wall" then 
                if shape == entity.shape then
                    player:onCollision(seperating_vector)
                end
            end
        end
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scale,scale)
    for _, entity in ipairs(entities) do
        entity:draw()
        if entity.shape ~= nil then
            --entity.shape:draw('fill')
        end
    end
    love.graphics.pop()
end

