
local bullet = require 'characters.bullet'
local human  = require 'characters.human'


local bomb = {}
local bombs = {}
local timer = 0
local blastBombs = true
local bombFreeze = 1
local anotherTimer = 0
local bombImage = nil

function bomb.load()
    bombImage = love.graphics.newImage('assets/Bomb.png')
end


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
        love.graphics.draw(bombImage, ((bomb.x - 1) * cellSize) + offset, ((bomb.y - 1) * cellSize) + offset, 0, 1.8)
    end
end

function bomb.freeze() 
    bombFreeze = 0
    blastBombs = false
end

function bomb.unfreeze()
    bombFreeze = 1
    blastBombs = true
end

function bomb.update(dt)
    timer = timer + dt
    anotherTimer = anotherTimer + (dt * bombFreeze)
    if anotherTimer >= 7 and blastBombs then

        anotherTimer = 0

        if #bombs ~= 0 then
            for bombIdx, bomb in ipairs(bombs) do
                local positions = {
                    {x = bomb.x - 1, y = bomb.y - 1},
                    {x = bomb.x, y = bomb.y - 1},
                    {x = bomb.x + 1, y = bomb.y - 1},
                    {x = bomb.x - 1, y = bomb.y},
                    {x = bomb.x + 1, y = bomb.y},
                    {x = bomb.x - 1, y = bomb.y + 1},
                    {x = bomb.x, y = bomb.y + 1},
                    {x = bomb.x + 1, y = bomb.y + 1},
                }
                for index, value in ipairs(human.getHumans()) do
                    for i = 1, #positions do
                        if positions[i].x == value.x and positions[i].y == value.y then
                            print("Game Over")
                            bullet.cannotMove()
                        end
                    end
                end
            
            end
        end
    end
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
