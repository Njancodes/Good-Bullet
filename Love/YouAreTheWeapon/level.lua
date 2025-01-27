local freeze = require "characters.freeze"
level = {}

-- characters
local bullet = require('characters.bullet')
local human = require('characters.human')
local alien = require('characters.alien')
local bomb = require('characters.bomb')
local json = require('dkjson')

-- dialogue system
local bulletMaster = require('dialogue.bullet-master')

-- ui system
local numberCountdown = require('ui.numberCountDown')
local gameOver = require('ui.gameOver')
local soundfx = require('ui.soundfx')

-- images
local background = nil

-- data
local content = ""

gridXCount = 14
gridYCount = 14
cellSize = 30
offset = 140
scale = cellSize / 50

local state = {
    bullet = bullet.getSegments(),
    bombs = bomb.getBombs(),
    humans = human.getHumans(),
    freezes = freeze.getFreezes(),
    alienWall = false,
    accelerators = {},
    dialogues = bulletMaster.getDialogues()
}
local state = {}

function chooseLevel(levelname)
    local file = io.open('YouAreTheWeapon/' .. levelname .. '.json', "r")
    if file then
        content = file:read('*a')
        state = json.decode(content, 1, nil)
        file:close()
        print("State Has Been Read !!!")
    else
        print("File couldnt be open")
    end
end

function level.load()
    timer = 0
    love.graphics.setDefaultFilter("nearest", "nearest")

    soundfx.load()

    background = love.graphics.newImage("assets/background.png")
    spaceShipFloor = love.graphics.newImage("assets/spaceship-floor.png")

    numberCountdown.load()
    numberCountdown.setCurrValue(10)
    numberCountdown.pause()

    love.window.setMode(700, 700) -- Remove this after finishing the game

    bullet.flush()
    bullet.setSegments(state.bullet)
    bulletMaster.reset()
    bulletMaster.setDialogues(state.dialogues)
    human.setHumans(state.humans)
    bomb.setBombs(state.bombs)
    alien.setEnterAliens(state.alienWall)
    freeze.setFreezes(state.freezes)
    accelerators = state.accelerators

    MouseGridPosX = 0
    MouseGridPosY = 0

    placeItem = 'bomb'
    human.load()
    bullet.load()
    gameOver.load()
    bomb.load()
    bulletMaster.load()
    freeze.load()
end

function level.restart()
    timer = 0
    state = json.decode(content, 1, nil)
    soundfx.load()
    human.setIsMoveHuman(true)
    bomb.setBombs(state.bombs)
    bullet.flush()
    bullet.setSegments(state.bullet)
    human.setHumans(state.humans)
    bomb.setBombs(state.bombs)
    alien.setEnterAliens(state.alienWall)
    freeze.setFreezes(state.freezes)
    accelerators = state.accelerators
    numberCountdown.setCurrValue(10)
end

function level.mousepressed()
    gameOver.mousepressed()
end

function level.update(dt)
    timer = timer + dt
    if timer >= 0.15 then
        timer = 0



        dontRemove = false
        MouseX, MouseY = love.mouse.getPosition()

        MouseGridPosX = math.floor((MouseX - 140) / cellSize) + 1
        MouseGridPosY = math.floor((MouseY - 140) / cellSize) + 1



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
    numberCountdown.update(dt)
    human.update(dt)
    bullet.update(dt)
    bulletMaster.update(dt)
    bomb.update(dt)
    alien.update(dt)
    freeze.update(dt)
end

function level.keypressed(key)
    if key == '1' then
        placeItem = 'bomb'
    end

    if key == 'f' then
        bomb.freeze()
    end
    soundfx.keypressed(key)
    alien.keypressed(key)
    bulletMaster.keypressed(key)

    if key == 'e' then
        state.bullet = bullet.getSegments()
        state.bombs = bomb.getBombs()
        state.accelerators = accelerators
        state.humans = human.getHumans()
        state.dialogues = { "Hi Nijo !!", "I am Bullet#909", "And you are going to control..",
            " me for the rest of the game.." }
        state.alienWall = alien.getEnterAliens()
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

function level.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(spaceShipFloor, offset, offset)

    bulletMaster.draw()
    bullet.draw()
    bomb.draw()
    freeze.draw()
    alien.draw()
    numberCountdown.draw()

    love.graphics.setColor(0, 0, 1)
    for acceleratorIndex, accelerator in ipairs(accelerators) do
        love.graphics.rectangle('fill', ((accelerator.x - 1) * cellSize) + offset, ((accelerator.y - 1) * cellSize) +
            offset, cellSize - 1, cellSize - 1)
    end




    human.draw()
    gameOver.draw()
end

return level
