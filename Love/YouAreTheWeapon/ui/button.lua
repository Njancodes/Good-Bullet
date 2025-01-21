
-- The buttons start from top left corner
function createButton( x, y, width, height)
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

    return button
end
