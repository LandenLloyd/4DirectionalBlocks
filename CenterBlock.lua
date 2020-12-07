CenterBlock = Class{}


function CenterBlock:init(util, centerBlockTable, tetriminoManager, BLOCK_DIMENSION, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    local x = util:toCoords({VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2})
    centerBlockTable[x] = {1,0,0,1}
    self.width = BLOCK_DIMENSION
    self.height = BLOCK_DIMENSION

    -- For rotation pivot
    self.px = VIRTUAL_WIDTH/2
    self.py = VIRTUAL_HEIGHT/2
end

function CenterBlock:update(dt)
    if self:handleCollisions() == true then
        return true
    end    
end

function CenterBlock:up()
    self.py  = self.py - BLOCK_DIMENSION
    newCenterBlockTable = {}
    for D1, color in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)
        D2.y = D2.y - BLOCK_DIMENSION
        local y = util:toCoords({D2.x, D2.y})
        newCenterBlockTable[y] = color
    end
    centerBlockTable = newCenterBlockTable
end

function CenterBlock:down()
    self.py = self.py + BLOCK_DIMENSION
    newCenterBlockTable = {}
    for D1, color in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)
        D2.y = D2.y + BLOCK_DIMENSION
        local y = util:toCoords({D2.x, D2.y})
        newCenterBlockTable[y] = color
    end
    centerBlockTable = newCenterBlockTable
end

function CenterBlock:left()
    self.px = self.px - BLOCK_DIMENSION
    newCenterBlockTable = {}
    for D1, color in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)
        D2.x = D2.x - BLOCK_DIMENSION
        local x = util:toCoords({D2.x, D2.y})
        newCenterBlockTable[x] = color
    end
    centerBlockTable = newCenterBlockTable
end

function CenterBlock:right()
    self.px = self.px + BLOCK_DIMENSION
    newCenterBlockTable = {}
    for D1, color in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)
        D2.x = D2.x + BLOCK_DIMENSION
        local x = util:toCoords({D2.x, D2.y})
        newCenterBlockTable[x] = color
    end
    centerBlockTable = newCenterBlockTable
end

function CenterBlock:rotate()
    centerBlockTable = util:rotateTable(centerBlockTable, self.px, self.py)
end

function CenterBlock:handleCollisions()
    if util:adjacentElements(tetriminoTable, centerBlockTable) then
        centerBlockTable = util:mergeTables(tetriminoTable, centerBlockTable)
        tetriminoManager:reset()
        return true
    end
end

function CenterBlock:outOfBounds()
    -- detects if center block has gone off screen
    -- if not out of bounds returns false
    for D1 in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)

        if D2.x < 0 then
            return true
        end
    
        if D2.x > VIRTUAL_WIDTH then
            return true
        end
    
        -- Detecting if the player has wrapped around.
        if D2.y % 4 ~= 2 then
            return true
        end
    end

    return false
        
end

function CenterBlock:render()
    for D1, color in pairs(centerBlockTable) do
        local D2 = util:parseCoords(D1)
        love.graphics.setColor(util:unpack(color))
        love.graphics.rectangle('fill', D2.x, D2.y, self.width, self.height)
    end
end 
