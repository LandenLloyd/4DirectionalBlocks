Util = Class{}

--TODO
function Util:init(VIRUTAL_WIDTH, VIRTUAL_HEIGHT, BLOCK_DIMENSION)
    self.VIRTUAL_WIDTH = VIRTUAL_WIDTH
    self.VIRTUAL_HEIGHT = VIRTUAL_HEIGHT
    self.BLOCK_DIMENSION = BLOCK_DIMENSION
end

function Util:unpack(table)
    -- Used for passing color tables into love.graphics.setColor
    return table[1], table[2], table[3], table[4]
end

function Util:parseCoords(coords)
    -- Converts 1D coords to 2D table (x,y)
    local x = coords % self.VIRTUAL_WIDTH
    local y = math.floor(coords/self.VIRTUAL_WIDTH)
    return {['x']=x, ['y']=y}
end

function Util:toCoords(coords)
    -- Converts 2D table (x,y) to 1D coords
    return self.VIRTUAL_WIDTH * coords[2] + coords[1]
end

function Util:mergeTables(table1, table2)
    --This simple function iterates through table1 then table2,
    --adding key value pairs to table3
    --note that duplicates keys in table2 override table1 values
    --Only works for tables with keys other than positional keys

    local table3 = {}

    for key, value in pairs(table1) do
        table3[key] = value
    end

    for key,value in pairs(table2) do
        table3[key] = value
    end

    return table3
end

function Util:adjacentElements(table1, table2)
    -- Used for collision checking, where the keys are 1D arrays
    -- Returns true is there is a collision, false otherwise

    -- We want the most performance efficient table
    local checkingTable, otherTable
    if #table1 < #table2 then
        checkingTable = table1
        otherTable = table2
    else
        checkingTable = table2
        otherTable = table1
    end

    local minCoord = 0
    local maxCoord = VIRTUAL_WIDTH * VIRTUAL_HEIGHT - 1

    local left, right, up, down

    for key, value in pairs(checkingTable) do
        -- Here we check for adjacencies, by iterating through each key in splittingTable
        -- and checking the coords and the four adjacent coords

        if otherTable[key] ~= nil then return true end

        if key - self.BLOCK_DIMENSION < minCoord then left = key else left = key - self.BLOCK_DIMENSION end
        if otherTable[left] ~= nil then return true end

        if key + self.BLOCK_DIMENSION > maxCoord then right = key else right = key + self.BLOCK_DIMENSION end
        if otherTable[right] ~= nil then return true end

        if key - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION < minCoord then up = key else up = key - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION end
        if otherTable[up] ~= nil then return true end

        if key + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION > maxCoord then down = key else down = key + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION end
        if otherTable[down] ~= nil then return true end

        -- Diagonals
        if key - self.BLOCK_DIMENSION - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION < minCoord then
            upleft = key
        else
            upleft = key - self.BLOCK_DIMENSION - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION
        end
        if otherTable[upleft] ~= nil then return true end

        if key + self.BLOCK_DIMENSION - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION < minCoord then
            upright = key
        else
            upright = key + self.BLOCK_DIMENSION - self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION
        end
        if otherTable[upright] ~= nil then return true end

        if key - self.BLOCK_DIMENSION + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION > maxCoord then
            downleft = key
        else
            downleft = key - self.BLOCK_DIMENSION + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION
        end
        if otherTable[downleft] ~= nil then return true end

        if key + self.BLOCK_DIMENSION + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION > maxCoord then
            downright = key
        else
            downright = key + self.BLOCK_DIMENSION + self.VIRTUAL_WIDTH * self.BLOCK_DIMENSION
        end
        if otherTable[downright] ~= nil then return true end

    end

    -- If we make it past the for loop then no adjacencies detected
    return false
end

function Util:rotateTable(table, pivotX, pivotY)
    -- Rotates the table 90˚ about pivotX, pivotY
    -- In the case of our game, pivotX and pivotY are the x, y coordinates of the centerBLock
    local rotatedTable = {}
    for position, color in pairs(table) do
        position = self:parseCoords(position)
        local dx = position.x - pivotX
        local dy = position.y - pivotY
        local newPosition = {pivotX - dy, pivotY + dx}
        rotatedTable[self:toCoords(newPosition)] = color
    end

    return rotatedTable
end
