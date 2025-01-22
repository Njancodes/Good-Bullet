scenes = {}

scenes.levelselector = require('levelselector')
scenes.menu = require('menu')
scene = scenes.menu
-- Problem: This load function only runs once, therefore if I change my scene its going to just run 
-- the update and draw function for that particular state. The load function of any scene will not run 
-- except for the menu scene

function changeScene(newScene)
    scene_name = newScene
    scene = require(newScene)  -- Update the current scene
    if scene and scene.load then
        love.load()  -- Call the new scene's load function
    end
end

function love.load()
    scene.load()
end
function love.keypressed(key)
    scene.keypressed(key)
end

function love.mousepressed()
    scene.mousepressed()
end

function love.update(dt)
    scene.update(dt)
end

function love.draw()
    scene.draw()
end