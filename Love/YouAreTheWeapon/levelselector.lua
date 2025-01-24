require 'ui.button'
level = require('level')
levelselector = {}
local levelbuttons = {}


local level1 = createButton(35,100,100,50)
table.insert(levelbuttons, level1)
local level2 = createButton(level1.x + level1.width + 5,level1.y,100,50)
table.insert(levelbuttons, level2)
local level3 = createButton(level2.x + level2.width + 5,level2.y,100,50)
table.insert(levelbuttons, level3)
local level4 = createButton(level3.x + level3.width + 5,level3.y,100,50)
table.insert(levelbuttons, level4)
local level5 = createButton(level4.x + level4.width + 5,level4.y,100,50)
table.insert(levelbuttons, level5)
local level6 = createButton(level5.x + level5.width + 5,level5.y,100,50)
table.insert(levelbuttons, level6)


function levelselector.load()
    print("Loaded")

end

function levelselector.keypressed(key)
    
end




function levelselector.mousepressed()

    for btnIdx, button in ipairs(levelbuttons) do
        button.clicked(
            function ()
                print("Level "..btnIdx.." Selected")
                chooseLevel('level-none')
                changeScene('level')
            end
        )
    end


end

function levelselector.draw()
    love.graphics.rectangle('fill',level1.x, level1.y, level1.width, level1.height)
    love.graphics.rectangle('fill',level2.x, level2.y, level2.width, level2.height)
    love.graphics.rectangle('fill',level3.x, level3.y, level3.width, level3.height)
    love.graphics.rectangle('fill',level4.x, level4.y, level4.width, level4.height)
    love.graphics.rectangle('fill',level5.x, level5.y, level5.width, level5.height)
    love.graphics.rectangle('fill',level6.x, level6.y, level6.width, level6.height)
end

function levelselector.update()
end

return levelselector