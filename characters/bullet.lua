local numberCountdown = require "ui.numberCountDown"
local gameOver = require "ui.gameOver"

local bullet = {
    segments = {
        { x = 1, y = 1 }
    }
}

local bulletImage = nil
local fireImage = nil
local midfireImage = nil
local canMove = true
local directionGrid = {}
local directionQueue = { 'right' }
local dontRemove = false
local timer = 0
local isNoMoreBombs = false

function bullet.cannotMove()
    canMove = false
end

function bullet.noMoreBombs()
    isNoMoreBombs = true
end

function bullet.dontRemoveSegment()
    dontRemove = true
end

function bullet.removeSegment()
    dontRemove = false
end

function bullet.canMove()
    if not canMove then
        canMove = true
    end
end

function bullet.remove(index)
    table.remove(bullet.getSegments(), index)
end

function bullet.insert(index, val)
    table.insert(bullet.getSegments(), index, val)
end

function bullet.bulletSegmentsLength()
    return #bullet.getSegments()
end

function bullet.headPosition()
    return bullet.getSegments()[1].x, bullet.segments[1].y
end

function bullet.load()
    bulletImage = love.graphics.newImage('assets/Bullet2.png')
    fireImage = love.graphics.newImage('assets/Fire.png')
    midfireImage = love.graphics.newImage('assets/Mid-Fire.png')

    for i = 1, gridXCount do
        directionGrid[i] = {}
        for j = 1, gridYCount do
            directionGrid[i][j] = "up"
        end
    end
end

local function directionGiver(direction)
    local rotation = 0
    local x = -1
    local y = -1
    if direction == 'up' then
        rotation = -90
        y = 0
    elseif direction == 'down' then
        rotation = 90
        x = 0
    elseif direction == 'left' then
        rotation = 180
        x = 0
        y = 0
    end
    return {
        rotation = rotation,
        x = x,
        y = y
    }
end

-- Assume the min is 1
function checkOutOfBounds(x, y, maxX, maxY)
    if x > maxX then
        return true
    end
    if x < 1 then
        return true
    end
    if y > maxY then
        return true
    end
    if y < 1 then
        return true
    end
end



function bullet.update(dt)
    timer = timer + dt
    if timer >= 0.15 then
        timer = 0
        if canMove then
            local bulletSegments = bullet.getSegments()


            bullet.removeSegment()
            if #bullet.getSegments() == 1 then
                bullet.cannotMove()
            end

            local nextXPosition = bulletSegments[1].x
            local nextYPosition = bulletSegments[1].y

            if #directionQueue > 1 then
                table.remove(directionQueue, 1)
            end
            if directionQueue[1] == 'right' then
                nextXPosition = nextXPosition + 1
            elseif directionQueue[1] == 'left' then
                nextXPosition = nextXPosition - 1
            elseif directionQueue[1] == 'up' then
                nextYPosition = nextYPosition - 1
            elseif directionQueue[1] == 'down' then
                nextYPosition = nextYPosition + 1
            end


            bullet.insert(1, { x = nextXPosition, y = nextYPosition })

            local currPositionOfHeadX, currPositionOfHeadY = bullet.headPosition()
            for acceleratorIndex, accelerator in ipairs(accelerators) do
                if currPositionOfHeadX == accelerator.x and currPositionOfHeadY == accelerator.y then
                    bullet.dontRemoveSegment()
                    table.remove(accelerators, acceleratorIndex)
                end
            end

            if dontRemove then
                return
            else
                bullet.remove(bullet.bulletSegmentsLength())
            end
        end
    end
end

function bullet.draw()
    love.graphics.setColor(1, 1, 1)
    local bullet_x, bullet_y = bullet.headPosition()
    local direction = directionQueue[1]

    for bulletIndex, bulletSegment in ipairs(bullet.getSegments()) do
        local rotation = 0
        local x = -1
        local y = -1
        if direction == 'up' then
            rotation = -90
            y = 0
        elseif direction == 'down' then
            rotation = 90
            x = 0
        elseif direction == 'left' then
            rotation = 180
            x = 0
            y = 0
        end
        if bulletIndex == 1 then
            if (not (checkOutOfBounds(bulletSegment.x, bulletSegment.y, 14, 14))) then
                directionGrid[bulletSegment.x][bulletSegment.y] = direction
                love.graphics.draw(bulletImage, ((bulletSegment.x + x) * cellSize) + offset,
                ((bulletSegment.y + y) * cellSize) + offset, math.rad(rotation), 1.8, 1.8)
            else
                print("Out Of Bounds")
                if isNoMoreBombs then
                    bullet.cannotMove()
                    numberCountdown.pause()
                    gameOver.win()
                    isNoMoreBombs = false
                    gameOver.gameOverEnable()
                else
                    gameOver.lose()
                    gameOver.gameOverEnable()
                    numberCountdown.pause()
                    isNoMoreBombs = false
                    bullet.cannotMove()
                end
            end
        elseif bulletIndex == bullet.bulletSegmentsLength() then
            if (not (checkOutOfBounds(bulletSegment.x, bulletSegment.y, 14, 14))) then
                local dir_table = directionGiver(directionGrid[bulletSegment.x][bulletSegment.y])
                love.graphics.draw(fireImage, ((bulletSegment.x + dir_table.x) * cellSize) + offset,
                    ((bulletSegment.y + dir_table.y) * cellSize) + offset, math.rad(dir_table.rotation), scale + 1.3,
                    scale + 1.3)
            end
        else
            if (not (checkOutOfBounds(bulletSegment.x, bulletSegment.y, 14, 14))) then
                local dir_table = directionGiver(directionGrid[bulletSegment.x][bulletSegment.y])
                love.graphics.draw(midfireImage, ((bulletSegment.x + dir_table.x) * cellSize) + offset,
                    ((bulletSegment.y + dir_table.y) * cellSize) + offset, math.rad(dir_table.rotation), scale + 1.3,
                    scale + 1.3)
            end
        end
    end
end

function bullet.getSegments()
    return bullet.segments
end

function bullet.flush()
    bullet.setSegments({})
    directionQueue = { 'right' }
    bullet.canMove()
end

function bullet.setDirection(direction)
    table.insert(directionQueue, direction)
end

function bullet.keypressed(key)
    if key == 'w' and directionQueue[#directionQueue] ~= 'down' and directionQueue[#directionQueue] ~= 'up' then
        table.insert(directionQueue, 'up')
    elseif key == 's' and directionQueue[#directionQueue] ~= 'up' and directionQueue[#directionQueue] ~= 'down' then
        table.insert(directionQueue, 'down')
    elseif key == 'd' and directionQueue[#directionQueue] ~= 'left' and directionQueue[#directionQueue] ~= 'right' then
        table.insert(directionQueue, 'right')
    elseif key == 'a' and directionQueue[#directionQueue] ~= 'right' and directionQueue[#directionQueue] ~= 'left' then
        table.insert(directionQueue, 'left')
    end

    -- if key == 'space' and not canMove then
    --     bullet.canMove()
    -- end
end

function bullet.setSegments(newSegments)
    print('Created new segments')
    bullet.segments = newSegments
end

return bullet
