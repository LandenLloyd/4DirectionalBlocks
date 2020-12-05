TetriminoManager = Class{}

function TetriminoManager:init(util, centerBlockTable, tetriminoTable)
    -- "seed" the RNG so that calls to random are always random
    -- use the current time, since that will vary on startup every time
    math.randomseed(os.time())

    local x = 0
    local y = VIRTUAL_HEIGHT / 2
    -- these variables are for keeping track of our velocity on both the 
    -- X and Y axis, since the tetrominoes can move in two dimensions
    local dx = 100
    local dy = math.random(-5, 5)

    -- four sides of screen 
    -- 1 is up
    -- 2 is right
    -- 3 is bottom
    -- 4 is left
    local side = 4

    -- shape = numbers
    -- 'S' is 1
    -- 'Z' is 2
    -- 'J' is 3
    -- 'L' is 4
    -- 'I' is 5
    -- 'O' is 6
    -- 'T' is 7
    local shape = 1

    -- this is for resetting shape angle
    local resetShapeAngle = false

    -- block is 4x4
    local block = 4

    -- distance between blocks
    local blockDst = 0.5   
end

function TetriminoManager:update(dt)
    if side == 1 then -- 1 is up
        -- if we reach the edge of the screen,
        -- go back to start
        if y > VIRTUAL_HEIGHT - block then
            reset()
        else
            x = x + dx * dt
            y = y + dy * dt
        end

    elseif side == 2 then -- 2 is right
        -- if we reach the edge of the screen,
        -- go back to start
        if x < 0 then
            reset()
        else
            x = x + dx * dt
            y = y + dy * dt
        end
    
    elseif side == 3 then -- 3 is bottom
        -- if we reach the edge of the screen,
        -- go back to start
        if y < 0 then
            reset()
        else
            x = x + dx * dt
            y = y + dy * dt
        end
    
    elseif side == 4 then -- 4 is left
        -- if we reach the edge of the screen,
        -- go back to start
        if x > VIRTUAL_WIDTH - block then
            reset()
        else
            x = x + dx * dt
            y = y + dy * dt
        end
    end
    love.graphics.printf('Nothing happened in update', 0, 50, VIRTUAL_WIDTH, 'center')
end

function TetriminoManager:render()
    -- test code
    love.graphics.printf(tostring(x) .. ' ' .. tostring(y) .. ' ' .. tostring(side), 0, 30, VIRTUAL_WIDTH, 'center')
    shapes()
end

-- resets tetromino
function reset()
    resetShapeAngle = true
    side = math.random(1, 4) 
    shape = math.random(1, 7) 

    if side == 1 then -- 1 is up
        x = math.random(0, VIRTUAL_WIDTH - 12)
        y = 0
    
        if x >=0 and x <= 64 then
            dx = 100
            dy = 90
        elseif x >=65 and x <= 128 then
            dx = 100
            dy = 90
        elseif x >= 129 and x <= 192 then
            dx = math.random(-5, 5)
            dy = 90
        elseif x >= 193 and x <= 257 then
            dx = -100
            dy = 90
        elseif x >= 258 and x <= VIRTUAL_WIDTH then
            dx = -100
            dy = 90
        end

    elseif side == 2 then -- 2 is right
        x = VIRTUAL_WIDTH 
        y = math.random(0, VIRTUAL_HEIGHT - 12)
    
        if y >=0 and y <= 60 then
            dx = -100
            dy = 30
        elseif y >=61 and y <= 120 then
            dx = -100
            dy = math.random(-5, 5)
        elseif y >= 121 and y <= VIRTUAL_HEIGHT then
            dx = -100
            dy = -30
        end
    
    elseif side == 3 then -- 3 is bottom
        x = math.random(0, VIRTUAL_WIDTH - 12)
        y = VIRTUAL_HEIGHT
    
        if x >=0 and x <= 64 then
            dx = 100
            dy = -95
        elseif x >=65 and x <= 128 then
            dx = 100
            dy = -95
        elseif x >= 129 and x <= 192 then
            dx = math.random(-5, 5)
            dy = -95
        elseif x >= 193 and x <= 257 then
            dx = -100
            dy = -95
        elseif x >= 258 and x <= VIRTUAL_WIDTH then
            dx = -100
            dy = -95
        end
    
    elseif side == 4 then -- 4 is left
        x = 0
        y = math.random(0, VIRTUAL_HEIGHT - 12)
    
        if y >=0 and y <= 60 then
            dx = 100
            dy = 30
        elseif y >=61 and y <= 120 then
            dx = 100
            dy = math.random(-5, 5)
        elseif y >= 121 and y <= VIRTUAL_HEIGHT then
            dx = 100
            dy = -30
        end
    end
end

-- defining shapes
function shapes()
    if shape == 1 then -- 'S' is 1
        -- setting reg color
        love.graphics.setColor(246/255, 0, 0, 1)
        tetriminoColor = {246/255, 0, 0, 1}
        if resetShapeAngle == true then
            s = math.random(1, 2) 
            resetShapeAngle = false
        end

        if s == 1 then
            ---**--
            --**---
            love.graphics.rectangle('fill', x  + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)

            positionsTable = {[x  + (block * 2) + (2 * blockDst)] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x] = y + (block + blockDst)}
        else 
            --*---
            --**--
            ---*--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block * 2) + (2 * blockDst)}
        end

    elseif shape == 2 then -- 'Z' is 2
        -- setting dark-orange color
        love.graphics.setColor(255/255, 140/255, 0, 1)
        tetriminoColor = {255/255, 140/255, 0, 1}
        if resetShapeAngle == true then
            z = math.random(1, 2) 
            resetShapeAngle = false
        end

        if z == 1 then
            --**---
            ---**--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block * 2) + (2 * blockDst)] = y + (block + blockDst)}
        else 
            ---*--
            --**--
            --*---
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x] = y + (block + blockDst),
                              [x] = y + (block * 2) + (2 * blockDst)}
        end

    elseif shape == 3 then -- 'J' is 3
        -- setting canary-yellow color
        love.graphics.setColor(255/255, 238/255, 0, 1)
        tetriminoColor = {255/255, 238/255, 0, 1}
        if resetShapeAngle == true then
            j = math.random(1, 4) 
            resetShapeAngle = false
        end

        if j == 1 then
            ---*--
            ---*--
            --**--
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block * 2) + (2 * blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block * 2) + (2 * blockDst),
                              [x] = y + (block * 2) + (2 * blockDst)}
        elseif j == 2 then
            --**--
            --*---
            --*---
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x] = y + (block + blockDst),
                              [x] = y + (block * 2) + (2 * blockDst)}
        elseif j == 3 then
            --***--
            ----*--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block * 2) + (2 * blockDst)] = y,
                              [x + (block * 2) + (2 * blockDst)] = y + (block + blockDst)}
        else
            --*----
            --***--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block * 2) + (2 * blockDst)] = y + (block + blockDst)}
        end
 
    elseif shape == 4 then -- 'L' is 4
        -- setting screamin-green color
        love.graphics.setColor(77/255, 233/255, 76/255, 1)
        tetriminoColor = {77/255, 233/255, 76/255, 1}
        if resetShapeAngle == true then
            l = math.random(1, 4) 
            resetShapeAngle = false
        end

        if l == 1 then
            --*---
            --*---
            --**--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x] = y + (block + blockDst),
                              [x] = y + (block * 2) + (2 * blockDst),
                              [x + (block + blockDst)] = y + (block * 2) + (2 * blockDst)}
        elseif l == 2 then
            --**---
            ---*---
            ---*---
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block * 2) + (2 * blockDst)}
        elseif l == 3 then
            --***--
            --*----
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block * 2) + (2 * blockDst)] = y,
                              [x] = y + (block + blockDst)}
        else
            ----*--
            --***--
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x + (block * 2) + (2 * blockDst)] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block * 2) + (2 * blockDst)] = y + (block + blockDst)}
        end

    elseif shape == 5 then -- 'I' is 5
        -- setting brilliant-azure color
        love.graphics.setColor(55/255, 131/255, 255/255, 1)
        tetriminoColor = {55/255, 131/255, 255/255, 1}
        if resetShapeAngle == true then
            i = math.random(1, 2) 
            resetShapeAngle = false
        end
        
        if i == 1 then
            --*--
            --*--
            --*--
            --*--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 3) + (3 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x] = y + (block + blockDst),
                              [x] = y + (block * 2) + (2 * blockDst),
                              [x] = y + (block * 3) + (3 * blockDst)}
        else 
            --****--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 3) + (3 * blockDst), y, block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block * 2) + (2 * blockDst)] = y,
                              [x + (block * 3) + (3 * blockDst)] = y}
        end

    elseif shape == 6 then -- 'O' is 6
            -- setting american-violet color
            love.graphics.setColor(72/255, 21/255, 170/255, 1)
            tetriminoColor = {72/255, 21/255, 170/255, 1}
            --**--
            --**--
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x +(block + blockDst), y + (block + blockDst), block, block)

            postionsTable = {[x] = y,
                             [x + (block + blockDst)] = y,
                             [x] = y + (block + blockDst),
                             [x +(block + blockDst)] = y + (block + blockDst)}

    elseif shape == 7 then -- 'T' is 7
        -- setting cyan color
        love.graphics.setColor(0, 255/255, 255/255, 1)
        tetriminoColor = {0, 255/255, 255/255, 1}
        if resetShapeAngle == true then
            t = math.random(1, 4) 
            resetShapeAngle = false
        end

        if t == 1 then
            --***--
            ---*---
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y, block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x] = y,
                              [x + (block + blockDst)] = y,
                              [x + (block * 2) + (2 * blockDst)] = y,
                              [x + (block + blockDst)]= y + (block + blockDst)}
        elseif t == 2 then
            ---*---
            ---**--
            ---*---
            love.graphics.rectangle('fill', x, y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x, y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x] = y + (block * 2) + (2 * blockDst)}
        elseif t == 3 then
            ---*--
            --**--
            ---*--
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block * 2) + (2 * blockDst), block, block)

            positionsTable = {[x + (block + blockDst)] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block * 2) + (2 * blockDst)}
        else
            ---*---
            --***--
            love.graphics.rectangle('fill', x + (block + blockDst), y, block, block)
            love.graphics.rectangle('fill', x, y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block + blockDst), y + (block + blockDst), block, block)
            love.graphics.rectangle('fill', x + (block * 2) + (2 * blockDst), y + (block + blockDst), block, block)

            positionsTable = {[x + (block + blockDst)] = y,
                              [x] = y + (block + blockDst),
                              [x + (block + blockDst)] = y + (block + blockDst),
                              [x + (block * 2) + (2 * blockDst)] = y + (block + blockDst)}
        end
    end
end

function TetriminoManager:getTable()
    -- Returns a tabular representation of the tetrimino using the format described in main.lua

    tetriminoTable = {}
    for x, y in pairs(positionsTable) do
        tetriminTable[util:toCoords({x, y})] = tetriminoColor
    end

    return tetriminoTable

end
