require 'ui.button'
levelselector = require 'levelselector'

menu = {}


WindowWidth = 700
WindowHeight = 700
love.window.setMode(WindowWidth,WindowHeight)



-- x and y starts from the top left corner
local playButton = createButton("Play", WindowWidth/2-200/2,(WindowHeight/2-70/2)+ 100,200,70)
local optionButton = createButton("Option",playButton.x,playButton.y + 80,playButton.width,playButton.height)
local quitButton = createButton("Quit",optionButton.x,optionButton.y + 80,playButton.width,playButton.height)

local menuBackGround = love.graphics.newImage("assets/menu.png")

function menu.load()

end

function menu.keypressed(key)
    
end

function menu.mousepressed()
    playButton.clicked(function ()
        print("Play Button Clicked")
        changeScene('levelselector')
    end)
    optionButton.clicked(function ()
        print("Option Button Clicked")
    end)

    quitButton.clicked(function ()
        print("Quit Button Clicked")
    end)
end




function menu.update(dt)
 
end

function menu.draw()
    love.graphics.draw(menuBackGround, 0,0)
    love.graphics.rectangle('fill',playButton.x, playButton.y, playButton.width, playButton.height)
    love.graphics.rectangle('fill',optionButton.x, optionButton.y, optionButton.width, optionButton.height)
    love.graphics.rectangle('fill',quitButton.x, quitButton.y, quitButton.width, quitButton.height)

end

return menu