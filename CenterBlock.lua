CenterBlock = Class{}


function CenterBlock:init(util, centerBlockTable, tetriminoTable, tetriminoManager, BLOCK_DIMENSION)
    x = util:tocords(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2)
    centerBlockTable[x] = {1,1,1,1}
    self.width = BLOCK_DIMENSION
    self.height = BLOCK_DIMENSION
end

function CenterBlock:update()   

end    

function CenterBlock:up()
    for D1, color in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)
        D2.y = D2.y - BLOCK_DIMENSION
        y = util:tocords(D2.x, D2.y)
        centerBlockTable[D1] = nil
        centerBlockTable[y] = color
    end
end

function CenterBlock:down()
    for D1, color in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)
        D2.y = D2.y + BLOCK_DIMENSION
        y = util:tocords(D2.x, D2.y)
        centerBlockTable[D1] = nil
        centerBlockTable[y] = color
    end
end

function CenterBlock:left()
    for D1, color in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)
        D2.x = D2.x - BLOCK_DIMENSION
        x = util:tocords(D2.x, D2.y)
        centerBlockTable[D1] = nil
        centerBlockTable[x] = color
    end
end

function CenterBlock:right()
    for D1, color in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)
        D2.x = D2.x + BLOCK_DIMENSION
        x = util:tocords(D2.x, D2.y)
        centerBlockTable[D1] = nil
        centerBlockTable[x] = color
    end
end

function CenterBlock:rotate()
    if util:adjacentElements(tetriminoTable, centerBlockTable) then
        centerBlockTable = util:mergeTables(tetriminoTable, centerBlockTable)
    end
end

function CenterBlock:outOfBounds()
    -- detects if center block has gone off screen
    -- if not out of bounds returns false
    for D1 in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)

        if D2.x < 0 then
            return true
        end
    
        if D2.x > VIRTUAL_WIDTH then
            return true
        end
    
        if D2.y < 0 then
            return true
        end
    
        if D2.y > VIRTUAL_HEIGHT then
            return true
        end    
    end

    return false
        
end

function CenterBlock:render()
    for D1, color in pairs(centerBlockTable) do
        D2 = util:parseCoords(D1)
        love.graphics.setColor(color)
        love.graphics.rectangle('fill', D2.x, D2.y, self.width, self.height)
    end
end 
