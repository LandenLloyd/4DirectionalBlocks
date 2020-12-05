-- Thanks to Ulydev for push https://github.com/Ulydev/push
push = require 'push'
-- Thanks to Matthias Richter for Class https://github.com/vrld/hump/blob/master/class.lua
Class = require 'Class'

require 'CenterBlock'
require 'TetriminoManager'
require 'Util'

-- NOTE:
-- In multiple places we pass in actual coords rather than virtual coords
-- This is because we decided against using virtual coords in the end,
-- but we still had functionality for virtual coords,
-- so we just pass in a different value and keep the misleading variable name

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

BLOCK_DIMENSION = 4

-- Because score is based on time which is often fractional,
-- we dispaly a second variable that is certainly an integer
local score = 0
local scoreDisplay = score

local timeElapsed = 0
local gameSpeed = 1
local minGameSpeed = 0.2

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('4D-Block-Organizer')

    fonts = {
        --Note that these font sizes should not be final
        --['titleFont'] = love.graphics.newFont('assets/titleFont.ttf', 8),
        --['scoreFont'] = love.graphics.newFont('assets/scoreFont.ttf', 8)
    }

    --love.graphics.setFont(fonts['titleFont'])

    sounds = {
        --['backgroundMusic'] = love.audio.newSource('assets/backgroundMusic.wav', 'staic')
    }

    -- A table for storing the position of the current tetrimino
    tetriminoTable = {
        --Below are two example entries, I added color because Tetris is multi-color
        --The first digit is the x coordinate, the second is the y coordinate
        --Use Util functions to swap between 2D and 1D coords
        --[100] = {1, 1, 1, 1}, -- access this item with tetriminoTable[1]
        --[137] = {1, 0, 1, 1},
        --[124] = nil --Do this if you need to delete a value
    }

    centerBlockTable = {
        -- Same format as above table
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    util = Util(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    tetriminoManager = TetriminoManager(util, centerBlockTable, tetriminoTable)
    centerBlock = CenterBlock(util, centerBlockTable,tetriminoManager, BLOCK_DIMENSION, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    

    gameState = 'start'

    --sounds['backgroundMusic']:setLooping(true)
    --sounds['backgroundMusic']:play()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    timeElapsed = timeElapsed + dt

    if gameState == 'pause' then
        --sounds['backgroundMusic']:pause()
    else
        --sounds['backgroundMusic']:play()
    end

    if timeElapsed > gameSpeed then
        timeElapsed = 0

        if gameState == 'play' then
            score = score + dt
            scoreDisplay = math.floor(score)

            -- It is important that tetriminoManager updates before centerBlock
            -- Because centerBlock calls tetriminoManager methods
            tetriminoManager:update(dt)

            -- Player controls for center block
            if love.keyboard.isDown('up') then
                centerBlock:up()
            elseif love.keyboard.isDown('down') then
                centerBlock:down()
            elseif love.keyboard.isDown('left') then
                centerBlock:left()
            elseif love.keyboard.isDown('right') then
                centerBlock:right()
            elseif love.keyboard.isDown('space') then
                centerBlock:rotate()
            end

            if centerBlock:outOfBounds() == true then
                -- gameState = 'end'
            end

        end
    end

    if gameState == 'play' then
        gameSpeed = math.max(minGameSpeed, gameSpeed - 0.01*dt)
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end 
    if gameState ~= 'end' then
        if key == 'escape' and gameState ~= 'pause' then
            gameState = 'pause'
        end
    end

    if (key == 'enter' or key == 'return') and gameState == 'start' then
        gameState = 'play'
    end

end

function love.draw()

    push:apply('start')
    love.graphics.printf(tostring(gameSpeed), 0, 20, VIRTUAL_WIDTH, 'center')

    if gameState == 'start' then
        --love.graphics.setFont(fonts['titleFont'])
        love.graphics.printf('Welcome To 4D Block Organizer!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Start!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        centerBlock:render()
        --love.graphics.setFont('scoreFont')
        --love.graphics.printf(tostring(displayScore), 0, 5, VIRTUAL_WIDTH, 'left')
        tetriminoManager:render()
    elseif gameState == 'pause' then
        love.graphics.setFont('titleFont')
        love.graphics.printf('The Game Is Paused, You Are Safe', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Resume!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'end' then
        --love.graphics.setFont('titleFont')
        love.graphics.printf('Game Over!', 0, 10, VIRTUAL_WIDTH, 'center')
        --love.graphics.setFont('scoreFont')
        --love.graphics.printf('Score: ' .. tostring(displayScore), 0, 20, VIRTUAL_WIDTH, 'center')
    end

    push:apply('end')

end
