require 'ui.button'

local gameOver = {}

local isGameOver = false
local levelFailed = nil
local restartButton = createButton("Restart", 250, 400, 200, 50)
local levelSelect = createButton("Level Select", 250, 480, 200, 50)
local levelPassed = nil
local isPassed = false
local isFailed = false

function gameOver.mousepressed()
    restartButton.clicked(function ()
        print("hallo")
        level.restart()
        isGameOver = false
    end)
    levelSelect.clicked(function ()
        isGameOver = false
        changeScene('levelselector')
    end)
end

function gameOver.win()
    isPassed = true
end

function gameOver.lose()
    isFailed = true
end

function gameOver.load()
    levelFailed = love.graphics.newImage('assets/levelFailed.png')
    levelPassed = love.graphics.newImage('assets/levelPassed.png')
end
function gameOver.update(dt)
end

function gameOver.gameOverEnable()
    isGameOver = true
end

function gameOver.draw()
    if isGameOver and isFailed then
        love.graphics.draw(levelFailed, 159,98)
        restartButton.draw(255,0,0)  
        levelSelect.draw(255,255,0)  
        isFailed = false
    elseif isGameOver and isPassed then
        love.graphics.draw(levelPassed, 159,98)
        restartButton.draw(255,0,0)  
        levelSelect.draw(255,255,0) 
        isPassed = false
    end
end


return gameOver
