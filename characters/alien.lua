local bullet = require 'characters.bullet'

local alien = {}
local aliens = {}
local timer = 0
local anotherTimer = 0
local enterAliens = false

function alien.getEnterAliens()
    return enterAliens
end

function alien.setEnterAliens(newEnterAliens)
    enterAliens = newEnterAliens
end

local function drawAliens()
    for i = 1, gridXCount do
        table.insert(aliens, { x = i, y = 1 })
    end
    for i = 1, gridYCount do
        table.insert(aliens, { x = 1, y = i })
    end
    for i = 1, gridXCount do
        table.insert(aliens, { x = i, y = gridYCount })
    end
    for i = 1, gridYCount do
        table.insert(aliens, { x = gridXCount, y = i })
    end
end

function alien.keypressed(key)
    if key == 'g' and not enterAliens then
        print("Enter Aliens")
        enterAliens = true
    elseif key == 'g' and enterAliens then
        enterAliens = false
    end
end

function alien.draw()
    love.graphics.setColor(1, 1, 1)
    local bullet_x, bullet_y = bullet.headPosition()
    for alienIndex, alien in ipairs(aliens) do
        if bullet_x == alien.x and bullet_y == alien.y then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(.7, .4, .09)
        end
        love.graphics.rectangle('fill', ((alien.x - 1) * cellSize) + offset, ((alien.y - 1) * cellSize) + offset,
            cellSize - 1, cellSize - 1)
    end
end

function alien.update(dt)
    timer = timer + dt
    if timer >= .15 then
        timer = 0
        local currPositionOfHeadX, currPositionOfHeadY = bullet.headPosition()
        for alienIndex, alien in ipairs(aliens) do
            if alien.x == currPositionOfHeadX and alien.y == currPositionOfHeadY then
                bullet.cannotMove()
            end
        end
    end

    if enterAliens then
        anotherTimer = anotherTimer + dt
        if anotherTimer >= 1 then
            anotherTimer = 0
            drawAliens()
        end
    end

end

return alien
