-- The buttons start from top left corner
function createButton(text, x, y, width, height)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
    }

    button.hover =  function (hoverFunction, notHoverFunction)
        local mouseX, mouseY = love.mouse.getPosition()
        if mouseX > x and mouseX < x + width and mouseY > y and mouseY < y + height then
            hoverFunction()
        else
            notHoverFunction()
        end
    end
    button.clicked = function (clickedFunction)
        local mouseX, mouseY = love.mouse.getPosition()
        if mouseX > x and mouseX < x + width and mouseY > y and mouseY < y + height and love.mouse.isDown(1) then
            clickedFunction()
        end
    end
    button.draw = function (r,g,b)
        love.graphics.setColor(r/255,g/255,b/255)
        love.graphics.rectangle('fill', x, y, width, height)  
        love.graphics.setColor(1,1,1)
        love.graphics.print(text, x+ width/2,y+height/2)
    end
    
    
    return button
end
