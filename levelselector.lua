require 'ui.button'
level = require('level')
levelselector = {}
local levelbuttons = {}


local level1 = createButton("Level 1",35,100,100,50)
table.insert(levelbuttons, level1)
local level2 = createButton("Level 2",level1.x + level1.width + 5,level1.y,100,50)
table.insert(levelbuttons, level2)
local level3 = createButton("Level 3",level2.x + level2.width + 5,level2.y,100,50)
table.insert(levelbuttons, level3)
local level4 = createButton("Level 4",level3.x + level3.width + 5,level3.y,100,50)
table.insert(levelbuttons, level4)
local level5 = createButton("Level 5",level4.x + level4.width + 5,level4.y,100,50)
table.insert(levelbuttons, level5)
local level6 = createButton("Level 6",level5.x + level5.width + 5,level5.y,100,50)
table.insert(levelbuttons, level6)
local bgImage = nil
local station1 = nil
local station2 = nil
local station3 = nil
local station4 = nil
local station5 = nil
local station6 = nil
local alienship = nil
local asteroid = nil
local x, y = level1.x + level1.width/2,level1.y - 50



function levelselector.load()
    print("Loaded")
    bgImage = love.graphics.newImage("assets/levelSelectorBG.png")
    station1 = love.graphics.newImage("assets/Spaceship-module.png")
    station2 = love.graphics.newImage("assets/Spaceship-module2.png")
    station3 = love.graphics.newImage("assets/Spaceship-module3.png")
    station4 = love.graphics.newImage("assets/Spaceship-module4.png")
    station5 = love.graphics.newImage("assets/Spaceship-module5.png")
    station6 = love.graphics.newImage("assets/Spaceship-module6.png")
    alienship = love.graphics.newImage("assets/alienship.png")
end

function levelselector.keypressed(key)

end



function levelselector.mousepressed()

    for btnIdx, button in ipairs(levelbuttons) do
        button.clicked(
            function ()
                print("Level "..btnIdx.." Selected")
                chooseLevel('level-'..btnIdx)
                changeScene('level')
            end
        )
    end


end

function levelselector.draw()

    love.graphics.draw(bgImage, 0,0)
    love.graphics.draw(station1,level1.x, level1.y)
    love.graphics.draw(station2,level2.x, level2.y)
    love.graphics.draw(station3,level3.x, level3.y)
    love.graphics.draw(station4,level4.x, level4.y)
    love.graphics.draw(station5,level5.x, level5.y)
    love.graphics.draw(station6,level6.x, level6.y)
    love.graphics.draw(alienship,x,y,0,1,1,60/2, 50/2)
end

function levelselector.update(dt)

    for btnIdx, button in ipairs(levelbuttons) do
        button.hover(
            function ()
                x = button.x + button.width/2
                y = button.y - 50
            end
        )
    end
end

return levelselector