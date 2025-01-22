local bullet = require "characters.bullet"
local bulletMaster = {
    
}

local bulletMasterImage = nil
local dialogueFont = nil
local currDialogue = 1
local timer = 0
local dialogues = {""} -- Comes from each level 
local split_dialogues = {}
local continueDialogue = false
local showDialogue = ""

function bulletMaster.setDialogues(newDialogues)
    dialogues = newDialogues
end

function bulletMaster.getDialogues()
    return dialogues
end

function bulletMaster.load()
    bulletMasterImage = love.graphics.newImage('assets/bullet-emotions/bullet-neutral.png')
    dialogueFont = love.graphics.newFont( "assets/font/sh-pinscher/SHPinscher-Regular.otf", 50 )
    dialogueFont:setFilter( "nearest", "nearest" )
    local dialogue = dialogues[currDialogue]
    table.insert(split_dialogues, mysplit(dialogue))
end
local i = 0
function bulletMaster.update(dt)
    timer = timer + dt
    if timer >= .1 then
        timer = 0
        i = i + 1
        if currDialogue <= #dialogues then
            bullet.cannotMove()
            if i <= #split_dialogues[currDialogue] then
                showDialogue = string.format(showDialogue .. "%s",split_dialogues[currDialogue][i])
            elseif continueDialogue then
                i = 0
                currDialogue = currDialogue + 1
                showDialogue = ""
                if currDialogue <= #dialogues then
                    local dialogue = dialogues[currDialogue]
                    table.insert(split_dialogues, mysplit(dialogue))   
                end
                continueDialogue = false
            end
        else
            bullet.canMove()
        end
    end
end


function bulletMaster.keypressed(key)
    if key == 'return' then
        continueDialogue = true
    end
end

function mysplit(inputstr)
    local t = {}
    for str in string.gmatch(inputstr, ".") do -- I dont know how this pattern matching works
      table.insert(t, str)
    end
    return t
end
  


function bulletMaster.draw()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bulletMasterImage, 20, 20,0,3,3)
    love.graphics.rectangle('fill', 95, 20, 550, 100)
    love.graphics.setColor(0, 0, 1)
    if currDialogue > 0 and currDialogue <= #dialogues then
        print(showDialogue)
        love.graphics.print(showDialogue, dialogueFont, 100,30)
    end
end


return bulletMaster
