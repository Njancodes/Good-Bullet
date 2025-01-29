
local bullet = require 'characters.bullet'
local gameOver = require 'ui.gameOver'
local numberCountdown = require 'ui.numberCountDown'
local soundfx         = require 'ui.soundfx'

local human = {}
local humans = {}
local timer = 0
local humanImage = nil
local isMoveHuman = true

function human.load()
    isMoveHuman = true
    humanImage = love.graphics.newImage('assets/Uman.png')
end

function human.setIsMoveHuman(value)
    isMoveHuman = value    
end

function human.clashWithMouse(posX, posY)
    local cannotPlaceHuman = false
    for humanIndex, human in ipairs(humans) do  
        if human.x == posX and human.y == posY then
            cannotPlaceHuman = true
            table.remove(humans, humanIndex)
        end
    end
    if not cannotPlaceHuman and placeItem == 'human' then
        table.insert(humans, {type = placeItem,  x = posX, y = posY })
    elseif not cannotPlaceHuman and placeItem == 'moveHumanX' then
        table.insert(humans, {type = placeItem,  x = posX, y = posY, xStart = posX, yStart = posY, xDelta = 5, yDelta = 0, direction = 1 })
    elseif not cannotPlaceHuman and placeItem == 'moveHumanY' then
        table.insert(humans, {type = placeItem,  x = posX, y = posY, xStart = posX, yStart = posY, xDelta = 0, yDelta = 5, direction = 1 })
    end
end

function human.getHumans()
    return humans
end

function human.setHumans(newHumans)
    humans = newHumans
end

function human.draw()
    love.graphics.setColor(1, 1, 1)
    local bullet_x, bullet_y = bullet.headPosition()
    for humanIndex, human in ipairs(humans) do
        love.graphics.draw(humanImage, ((human.x - 1) * cellSize) + offset, ((human.y - 1) * cellSize) + offset, 0, 1.8)
    end
end

local function moveHuman(human)
    if human.xDelta == 0 then
        local yEnd = human.yStart + human.yDelta
        if human.y == human.yStart then
            human.direction = 1
        end
        if human.y == yEnd then
            human.direction = -1
        end
        human.y = human.y + human.direction
    end
    if human.yDelta == 0 then
        local xEnd = human.xStart + human.xDelta
        if human.x == human.xStart then
            human.direction = 1
        end
        if human.x == xEnd then
            human.direction = -1
        end
        human.x = human.x + human.direction
    end
end

function human.update(dt)
    timer = timer + dt
    if timer >= 0.15 and isMoveHuman then
        timer = 0
        for humanIndex, human in ipairs(humans) do
            if human.type == 'moveHumanX' or human.type == 'moveHumanY' then
                moveHuman(human)
            end
        end
    end
    for humanIndex, human in ipairs(humans) do
            for bulletIdx, fire in ipairs(bullet.getSegments()) do
                if fire.x == human.x and fire.y == human.y then
                    isMoveHuman = false
                    numberCountdown.pause()
                    soundfx.humanHurt()
                    gameOver.lose()
                    gameOver.gameOverEnable()
                    bullet.cannotMove()
            end
        end
    end
end

return human