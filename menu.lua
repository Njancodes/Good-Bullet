require 'ui.button'
levelselector = require 'levelselector'

menu = {}


WindowWidth = 700
WindowHeight = 700
love.window.setMode(WindowWidth,WindowHeight)



-- x and y starts from the top left corner
local playButton = createButton("Play", WindowWidth/2-200/2,(WindowHeight/2-70/2)+ 150,200,70)
local optionButton = createButton("Option",playButton.x,playButton.y + 80,playButton.width,playButton.height)

local menubackground = love.graphics.newImage("assets/menu.png")
local menuearth = love.graphics.newImage("assets/menu-earth.png")
local menuPlayImg = love.graphics.newImage("assets/menuPlay.png")
local menuPlayHoverImg = love.graphics.newImage("assets/menuPlayHovert.png")
local earthRotation = 0
local playImg= menuPlayImg


function menu.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function menu.keypressed(key)
    
end


function menu.mousepressed()
    playButton.clicked(function ()
        print("Play Button Clicked")
        changeScene('levelselector')
    end)
    optionButton.clicked(function ()
        print("option Button Clicked")
    end)
end



function menu.update(dt)
    earthRotation = earthRotation + 0.01 * dt
    playButton.hover(
        function ()
            playImg = menuPlayHoverImg
        end,
        function ()
            playImg = menuPlayImg
        end
    )
end

function menu.draw()
    love.graphics.draw(menubackground, 0,0)
    love.graphics.draw(playImg,playButton.x, playButton.y)
    love.graphics.draw(menuearth, 699,699,math.deg(earthRotation),1,1,182/2,188/2)
end

return menu