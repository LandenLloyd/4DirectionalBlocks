Util = Class{}

--TODO
function Util:init(VIRUTAL_WIDTH, VIRTUAL_HEIGHT)
    self.VIRTUAL_WIDTH = VIRTUAL_WIDTH
    self.VIRTUAL_HEIGHT = VIRTUAL_HEIGHT
end

function Util:parseCoords(coords)
    -- Converts 1D coords to 2D table (x,y)
    x = coords % self.VIRTUAL_WIDTH
    y = math.floor(coords/self.VIRTUAL_WIDTH)
    return {x, y}
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

    table3 = {}

    for key, value in pairs(table1) do
        table3[key] = value
    end

    for key,value in pairs(table2) do
        table3[key] = value
    end

    return table3
end

function Util:adjacentElements(table1, table2)
    -- Used for collision checking, where the keys

    if #table1 < #table2 then
        splittingTable = table1
    else
        splittingTable = table2
    end

    --To Be Continued
end
