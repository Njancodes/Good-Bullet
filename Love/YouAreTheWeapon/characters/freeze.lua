local bullet = require 'characters.bullet'
local bomb = require 'characters.bomb'


local freeze = {}
local freezes = {}
local timer = 0
local anotherTimer = 0
local freezeImage = nil
local freezeBombs = false
local bombTimer = 0


function freeze.load()
    freezeImage = love.graphics.newImage('assets/freeze.png')
end

function freeze.clashWithMouse(posX, posY)
    local cannotPlaceFreeze = false
    for freezeIndex, freeze in ipairs(freezes) do
        if freeze.x == posX and freeze.y == posY then
            cannotPlaceFreeze = true
            table.remove(freezes, freezeIndex)
        end
    end
    if not cannotPlaceFreeze and placeItem == 'freeze' then
        table.insert(freezes, { x = posX, y = posY })
    end
end

function freeze.getFreezes()
    return freezes
end

function freeze.setFreezes(newFreezes)
    freezes = newFreezes
end

function freeze.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Freeze Timer: ".. math.floor(anotherTimer), 10, 55)
    for freezzeIndex, freeze in ipairs(freezes) do
        love.graphics.draw(freezeImage, ((freeze.x - 1) * cellSize) + offset, ((freeze.y - 1) * cellSize) + offset, 0, scale)
    end
end

function freezeTheBombs()
    freezeBombs = true
end

function freeze.update(dt)
    timer = timer + dt
    if timer >= .15 then
        timer = 0

        local currPositionOfHeadX, currPositionOfHeadY = bullet.headPosition()
        for freezeIndex, freeze in ipairs(freezes) do
            if currPositionOfHeadX == freeze.x and currPositionOfHeadY == freeze.y then
                if bullet.bulletSegmentsLength() > 1 then
                    bullet.remove(bullet.bulletSegmentsLength())
                    table.remove(freezes, freezeIndex)
                    freezeTheBombs()
                end
            end
        end
    end
    anotherTimer = anotherTimer + dt
    if freezeBombs then
        bombTimer = bomb.freeze()
    elseif anotherTimer >= 2 then
        anotherTimer = 0

        bomb.unfreeze(bombTimer)
    end
end

return freeze
