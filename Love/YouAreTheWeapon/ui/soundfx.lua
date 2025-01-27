local soundfx = {}

--The Sounds
local buttonClicksrc = love.audio.newSource("assets/sfx/buttonClick.wav","static")
buttonClicksrc:setVolume(0.5)
local destroyedBombsrc = love.audio.newSource("assets/sfx/destroyBomb.wav","static")
destroyedBombsrc:setPitch(0.5)

local explosionSrc = love.audio.newSource("assets/sfx/explosion.wav","static")
local isExploded = false

local timerSrc = love.audio.newSource("assets/sfx/timer.wav","static")
timerSrc:setVolume(0.4)

local consonantSrc = love.audio.newSource("assets/sfx/consonant.wav","static")
local vowelSrc = love.audio.newSource("assets/sfx/vowel.wav","static")
vowelSrc:setPitch(0.5)


function soundfx.load()
    isExploded = false
end

function soundfx.timer(currValue)
    print(currValue)
    if currValue <= 7 and currValue > 4 then
        timerSrc:setPitch(2)
    elseif currValue <= 4 then
        timerSrc:setPitch(.5)
    else
        timerSrc:setPitch(1)
    end
    timerSrc:play()
end

function soundfx.keypressed(key)
    if key == 'a' or key == 's' or key == 'd' or key == 'w' then
        buttonClicksrc:play()
    end
end

function soundfx.consonant()
    consonantSrc:play()
end

function soundfx.vowel()
    vowelSrc:play()
end

function soundfx.explosion()
   if not isExploded then
    print("Hello")
    explosionSrc:play() 
    isExploded = true
   end 
end

function soundfx.destroyedBomb()
    destroyedBombsrc:play()
end

return soundfx
