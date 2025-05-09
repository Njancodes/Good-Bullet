local bullet = require "characters.bullet"
local numberCountdown = require 'ui.numberCountDown'
local soundfx         = require 'ui.soundfx'
local human           = require 'characters.human'
local gameOver        = require 'ui.gameOver'

local bulletMaster = {}


local dialogueFont = nil
local currDialogue = 1
local timer = 0
local dialogues = {""} -- Comes from each level 
local bulletMasterImages = {}
local split_dialogues = {}
local continueDialogue = false
local showDialogue = ""
local dialogueRunning = false
local i = 0
local startedGame = false
local dialogueBoxOpacity =1
local deltaChange = 0 
local anotherTimer = 0
local emotion = "Happy"


function bulletMaster.setDialogues(newDialogues)
    print("New dialogues acquired")
    dialogues = newDialogues
end

function bulletMaster.getDialogues()
    return dialogues
end

function bulletMaster.load()
    startedGame = false
    dialogueBoxOpacity = 1
    deltaChange = 0
    emotion = "Happy"
    bulletMasterImages["Happy"] = love.graphics.newImage('assets/bullet-emotions/bullet-neutral.png')
    bulletMasterImages["Dissappointed"] = love.graphics.newImage('assets/bullet-emotions/bullet-dissapointed.png')
    bulletMasterImages["Angry"] = love.graphics.newImage('assets/bullet-emotions/bullet-anger.png')
    dialogueBoxImage = love.graphics.newImage('assets/DialogueBox.png')
    dialogueFont = love.graphics.newFont( "assets/font/sh-pinscher/SHPinscher-Regular.otf", 40 )
    dialogueFont:setFilter( "nearest", "nearest" )
    currDialogue = 1
    i = 0
    -- continueDialogue = true
    local dialogue = bulletMaster.getDialogues()[currDialogue]
    split_dialogues = {}
    table.insert(split_dialogues, mysplit(dialogue))
end

function bulletMaster.reset()
    currDialogue = 1
end

function decOpacity()
    dialogueBoxOpacity = dialogueBoxOpacity - 0.1
end

function toCenter()
    local target = WindowHeight/2 - 20 - 40
    if (20+deltaChange) < target then
        deltaChange = deltaChange + 40
    else
        deltaChange = target
    end
end

function bulletMaster.setStartedGame(bool)
    startedGame = bool
end


function bulletMaster.update(dt)
    timer = timer + dt
    anotherTimer = anotherTimer + dt
    if anotherTimer >= 1 then
        anotherTimer = 0
        if gameOver.getWon() then
            emotion = "Happy"
        elseif gameOver.getLose() then
            emotion = "Angry"
        else
            emotion = human.checkIfBulletNear()
        end
    end
    if timer >= .01 then
        timer = 0
        i = i + 1
        if currDialogue <= #dialogues then
            bullet.cannotMove()
            dialogueRunning = (i <= #split_dialogues[currDialogue])
            if dialogueRunning then
                if split_dialogues[currDialogue][i] == 'a' or split_dialogues[currDialogue][i] == 'e' or split_dialogues[currDialogue][i] == 'i' or split_dialogues[currDialogue][i] == 'o' or split_dialogues[currDialogue][i] == 'u' then
                    soundfx.vowel()
                elseif split_dialogues[currDialogue][i] ~= " " then
                    soundfx.consonant()
                end
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
            if not startedGame then
                bullet.canMove()
                numberCountdown.start()
                startedGame = true
                dialogueBoxOpacity = 1
            end
            decOpacity()
            toCenter()
        end
    end
end


function bulletMaster.keypressed(key)
    if key == 'return' and not dialogueRunning then
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
    love.graphics.draw(bulletMasterImages[emotion], 20 + deltaChange, 20,0,3,3)
    love.graphics.setColor(1,1,1,1*dialogueBoxOpacity)
    love.graphics.draw(dialogueBoxImage, 95, 20)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setColor(107/255, 196/255, 23/255,1*dialogueBoxOpacity)
    if currDialogue > 0 and currDialogue <= #dialogues then
        love.graphics.printf(showDialogue, dialogueFont, 120,20,430)
    end
    love.graphics.setColor(107/255, 196/255, 23/255,1)
end


return bulletMaster
