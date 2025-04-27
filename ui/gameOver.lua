require 'ui.button'

local gameOver = {}

local isGameOver = false
local levelFailed = nil
local restartButton = createButton("Restart", 250, 400, 200, 50)
local levelSelect = createButton("Level Select", 250, 480, 200, 50)

local restartButtonImg = love.graphics.newImage("assets/restartButton.png")
local hoverRestartButtonImg = love.graphics.newImage("assets/hoverRestartButton.png")
local imageToRenderRestart = restartButtonImg

local levelButtonImg = love.graphics.newImage("assets/levelSelect.png")
local hoverlevelButtonImg = love.graphics.newImage("assets/hoverlevelSelect.png")
local imageToRenderLevel = levelButtonImg


local levelPassed = nil
local isPassed = false
local gameWon = false
local gameLose = false
local isFailed = false

function gameOver.getWon()
    return gameWon
end

function gameOver.getLose()
    return gameLose
end

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
    restartButton.hover(
        function ()
            imageToRenderRestart = hoverRestartButtonImg
        end,
        function ()
            imageToRenderRestart = restartButtonImg
        end
    )
    levelSelect.hover(
        function ()
            imageToRenderLevel = hoverlevelButtonImg
        end,
        function ()
            imageToRenderLevel = levelButtonImg
        end
    )
end

function gameOver.gameOverEnable()
    isGameOver = true
end

function gameOver.draw()
    if isGameOver and isFailed then
        restartButton.setDisabled(false)
        gameLose = true
        levelSelect.setDisabled(false)
        love.graphics.draw(levelFailed, 159,98)
        love.graphics.draw(imageToRenderRestart, restartButton.x, restartButton.y)
        love.graphics.draw(imageToRenderLevel, levelSelect.x, levelSelect.y)
        isFailed = false
    elseif isGameOver and isPassed then
        restartButton.setDisabled(false)
        gameWon = true
        levelSelect.setDisabled(false)
        love.graphics.draw(levelPassed, 159,98)
        love.graphics.draw(imageToRenderRestart, restartButton.x, restartButton.y)
        love.graphics.draw(imageToRenderLevel, levelSelect.x, levelSelect.y)
        isPassed = false
    else
        restartButton.setDisabled(true)
        gameWon = false
        gameLose = false
        levelSelect.setDisabled(true)
    end
end


return gameOver
