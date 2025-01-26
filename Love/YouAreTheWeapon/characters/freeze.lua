local bullet = require 'characters.bullet'
local bomb = require 'characters.bomb'
local numberCountDown = require 'ui.numberCountDown'


local freeze = {}
local freezes = {}
local timer = 0
local freezeImage = nil


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
    for freezzeIndex, freeze in ipairs(freezes) do
        love.graphics.draw(freezeImage, ((freeze.x - 1) * cellSize) + offset, ((freeze.y - 1) * cellSize) + offset, 0, 1.8)
    end
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
                    -- Another freeze counter should start
                    numberCountDown.freeze()
                    table.remove(freezes, freezeIndex)
                end
            end
        end
    end
end

return freeze
