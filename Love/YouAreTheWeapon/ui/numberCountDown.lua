local numberCountdown = {}

local numberCountDownSpriteSheet = nil
local freezeCountSpriteSheet= nil
local timer = 0
local currValue = 10
local freezeValue = 0
local numberTable = {}
local freezeTable = {}
local notFreeze = true
local start = false

-- No need of the last 1 and 0 please do cut it out before submitting the game

function numberCountdown.load()
    numberCountDownSpriteSheet = love.graphics.newImage('assets/numbers/numbers.png')
    freezeCountSpriteSheet = love.graphics.newImage('assets/numbers/freezenumbers.png')
    for i = 0, 9 do
        numberTable[i+1] = {quad = love.graphics.newQuad(30*i,0, 30,30,numberCountDownSpriteSheet:getDimensions())}    
    end
    for i = 0, 2 do
        freezeTable[i+1] = {quad = love.graphics.newQuad(30*i,0, 30,30,freezeCountSpriteSheet:getDimensions())}    
    end
end
function numberCountdown.update(dt)
    timer = timer + dt
    if timer >= 1 then
        timer = 0
        if currValue >= 2 and notFreeze and start then
            currValue = currValue - 1
        elseif not notFreeze and freezeValue >= 1 then
            freezeValue = freezeValue - 1
        elseif currValue >= 2 then
            numberCountdown.unfreeze()
        else
            currValue = 1
        end
    end
end
function numberCountdown.freeze()
    notFreeze = false
    freezeValue = 3
end
function numberCountdown.unfreeze()
    notFreeze = true
    freezeValue = 0
end
function numberCountdown.start()
    start = true
end
function numberCountdown.pause()
    start = false
end

function numberCountdown.getCurrValue()
    return currValue
end


function numberCountdown.setCurrValue(newCurrValue)
    currValue = newCurrValue
end

function numberCountdown.draw()

    love.graphics.setColor(1, 1, 1)
    if currValue >= 1 then
        love.graphics.draw(numberCountDownSpriteSheet,numberTable[currValue].quad, 10, 150,0, 3)
    end
    if freezeValue >= 1 then
        love.graphics.draw(freezeCountSpriteSheet,freezeTable[freezeValue].quad, 10, 250,0, 3)
    end
    -- love.graphics.draw(freezeCountSpriteSheet,freezeTable[3].quad,10,250,0,3)
end


return numberCountdown
