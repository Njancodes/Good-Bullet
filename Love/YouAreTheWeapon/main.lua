local freeze = require "characters.freeze"
level = {}

local bullet = require('characters.bullet')
local human = require('characters.human')
local bomb = require('characters.bomb')
local json = require('dkjson')


local state = {
    bullet = bullet.getSegments(),
    bombs = bomb.getBombs(),
    humans = human.getHumans(),
    freezes = freeze.getFreezes(),
    accelerators = {},
}

function chooseLevel(levelname)
    local file = io.open('YouAreTheWeapon/'..levelname .. '.json', "r")
    if file then
        local content = file:read('*a')
        state = json.decode(content, 1, nil)
        file:close()
        print("State Has Been Read !!!")
    else
        print("File couldnt be open")
    end
end

function love.load()
    timer = 0
    love.window.setMode(700, 700) -- Remove this after finishing the game
    humanImage = love.graphics.newImage('assets/human.png')
    chooseLevel('leve-tr')
    bullet.setSegments(state.bullet)
    human.setHumans(state.humans)
    bomb.setBombs(state.bombs)
    freeze.setFreezes(state.freezes)
    accelerators = state.accelerators
    MouseGridPosX = 0 
    MouseGridPosY = 0
    placeItem = 'bomb'
    gridXCount = 14
    gridYCount = 14
    cellSize = 36
    offset = 98
    scale = cellSize / 50
    bullet.load()
    bomb.load()
    freeze.load()
end

function love.mousepressed()
end

function love.update(dt)
    timer = timer + dt
    if timer >= 0.15 then
        timer = 0



        dontRemove = false
        MouseX, MouseY = love.mouse.getPosition()

        MouseGridPosX = math.floor((MouseX - 98) / cellSize) + 1
        MouseGridPosY = math.floor((MouseY - 98) / cellSize) + 1


        bullet.update()

        -- Level maker system
        if love.mouse.isDown(2) then
            local cannotPlaceAccelerator = false



           
            for acceleratorIndex, accelerator in ipairs(accelerators) do
                if accelerator.x == MouseGridPosX and accelerator.y == MouseGridPosY then
                    cannotPlaceAccelerator = true
                    table.remove(accelerators, acceleratorIndex)
                end
            end
            human.clashWithMouse(MouseGridPosX, MouseGridPosY)
            bomb.clashWithMouse(MouseGridPosX, MouseGridPosY)
            freeze.clashWithMouse(MouseGridPosX, MouseGridPosY)





            if not cannotPlaceAccelerator and placeItem == 'accelerator' then
                table.insert(accelerators, { x = MouseGridPosX, y = MouseGridPosY })
            end


        end
    end
    
    human.update(dt)
    bomb.update(dt)
    freeze.update(dt)
end

function love.keypressed(key)
    if key == '1' then
        placeItem = 'bomb'
    end

    if key == 'f' then
        bomb.freeze()
    end

    if key == 'e' then
        state.bullet = bullet.getSegments()
        state.bombs = bomb.getBombs()
        state.accelerators = accelerators
        state.humans = human.getHumans()
        for idx, human in ipairs(state.humans) do
            print(human.type)
        end
        local string = json.encode(state, { index = true })
        print(string)
        local file = io.open('YouAreTheWeapon/state.json', 'w')
        file:write(string)
        file:close()
        print("State Has Been Saved !!!")
    end

    if key == '2' then
        placeItem = 'accelerator'
    end

    if key == '3' then
        placeItem = 'human'
    end

    if key == '4' then
        placeItem = 'moveHumanX'
    end
    if key == '5' then
        placeItem = 'moveHumanY'
    end

    if key == '6' then
        placeItem = 'freeze'
    end

    bullet.keypressed(key)
end



function love.draw()
    love.graphics.setColor(0.5, 0, 0.5)
    love.graphics.rectangle('fill', 98, 98, gridXCount * cellSize, gridYCount * cellSize)

    bullet.draw()
    bomb.draw()
    freeze.draw()

    love.graphics.setColor(0, 0, 1)
    for acceleratorIndex, accelerator in ipairs(accelerators) do
        love.graphics.rectangle('fill', ((accelerator.x - 1) * cellSize) + offset, ((accelerator.y - 1) * cellSize) +
        offset, cellSize - 1, cellSize - 1)
    end

    human.draw()



end

-- return level
