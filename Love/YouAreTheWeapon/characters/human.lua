
local bullet = require 'characters.bullet'

local human = {}
local humans = {}
local timer = 0


function human.clashWithMouse(posX, posY)
    local cannotPlaceHuman = false
    for humanIndex, human in ipairs(humans) do
            
        if human.x == posX and human.y == posY then
            cannotPlaceHuman = true
            table.remove(humans, humanIndex)
        end
        print(cannotPlaceHuman)
        if not cannotPlaceHuman and placeItem == 'human' then
            table.insert(humans, {type = placeItem,  x = posX, y = posY })
        elseif not cannotPlaceHuman and placeItem == 'moveHuman' then
            table.insert(humans, {type = placeItem,  x = posX, y = posY, xStart = posX, yStart = posY, xDelta = 0, yDelta = 5 })
        end

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
        if bullet_x == human.x and bullet_y == human.y then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(humanImage, ((human.x - 1) * cellSize) + offset, ((human.y - 1) * cellSize) + offset, 0, scale)
    end
end


function human.update(dt)
    timer = timer + dt
    if timer >= .2 then

        timer = 0
    for humanIndex, human in ipairs(humans) do
            if human.type == 'moveHuman' then
                
            end
        end
    end

    local currPositionOfHeadX, currPositionOfHeadY = bullet.headPosition()
    for humanIndex, human in ipairs(humans) do
        if currPositionOfHeadX == human.x and currPositionOfHeadY == human.y then
            bullet.cannotMove()
        end
    end
end

return human