
local bullet = require 'characters.bullet'


local bomb = {}
local bombs = {}
local timer = 0


function bomb.clashWithMouse(posX, posY)
    local cannotPlaceBomb = false
    for bombIndex, bomb in ipairs(bombs) do
        if bomb.x == posX and bomb.y == posY then
            cannotPlaceBomb = true
            table.remove(bombs, bombIndex)
        end
    end
    if not cannotPlaceBomb and placeItem == 'bomb' then
        table.insert(bombs, { x = posX, y = posY })
    end
end

function bomb.getBombs()
    return bombs
end

function bomb.setBombs(newBombs)
    bombs = newBombs
end

function bomb.draw()
    love.graphics.setColor(1, 1, 1)
    for bombIndex, bomb in ipairs(bombs) do
        love.graphics.draw(bombImage, ((bomb.x - 1) * cellSize) + offset, ((bomb.y - 1) * cellSize) + offset, 0, scale)
    end
end



function bomb.update(dt)
    timer = timer + dt
    if timer >= .15 then
        timer = 0

        local currPositionOfHeadX, currPositionOfHeadY = bullet.headPosition()
        for bombIndex, bomb in ipairs(bombs) do
            if currPositionOfHeadX == bomb.x and currPositionOfHeadY == bomb.y then
                if bullet.bulletSegmentsLength() > 1 then
                    bullet.remove(bullet.bulletSegmentsLength())
                    table.remove(bombs, bombIndex)
                end
            end
        end
    end
end

return bomb
