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

-- Variables for controlling the flow of the game
local timeElapsed = 0
local gameSpeed = 0.25
local minGameSpeed = 0.05

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('4D-Block-Organizer')

    titleFont = love.graphics.newFont('assets/font.ttf', 10)
    scoreFont = love.graphics.newFont('assets/font.ttf', 8)
    love.graphics.setFont(scoreFont)

    sounds = {
        ['backgroundMusic'] = love.audio.newSource('assets/backgroundMusic.mp3', 'static'),
        ['backgroundMusic2'] = love.audio.newSource('assets/backgroundMusic2.mp3', 'static'),
        ['offScreen'] = love.audio.newSource('assets/offScreen.mp3', 'static')
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

    util = Util(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, BLOCK_DIMENSION)
    tetriminoManager = TetriminoManager(util, centerBlockTable, tetriminoTable)
    centerBlock = CenterBlock(util, centerBlockTable,tetriminoManager, BLOCK_DIMENSION, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    gameState = 'start'

    sounds['backgroundMusic']:setLooping(true)
    sounds['backgroundMusic']:play()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    timeElapsed = timeElapsed + dt

    if gameState == 'pause' then
        sounds['backgroundMusic']:pause()
    else
        sounds['backgroundMusic']:play()
    end

    if gameState == 'play' then
        score = score + dt
        scoreDisplay = math.floor(score)
    end

    if timeElapsed > gameSpeed then
        timeElapsed = 0

        if gameState == 'play' then
            tick = tick + 1
            if tick >= 4 then
                -- We want the tetrmino to move slower than the player
                -- so the player can catch up
                tetriminoManager:update(1)
                tick = 0
            end
            -- It is important that tetriminoManager updates before centerBlock
            -- Because centerBlock calls tetriminoManager methods

            -- Player controls for center block
            if love.keyboard.isDown('up') then
                centerBlock:up()
            elseif love.keyboard.isDown('down') then
                centerBlock:down()
            end

            if love.keyboard.isDown('left') then
                centerBlock:left()
            elseif love.keyboard.isDown('right') then
                centerBlock:right()
            end

            if love.keyboard.isDown('space') then
                centerBlock:rotate()
            end

            if centerBlock:outOfBounds() == true then
                -- gameState = 'end'
            end

            centerBlock:update(1)
        else
            -- We want the game to be predictable;
            -- so we want the game to start from the same state everytime
            tick = 0
            timeElapsed = 0
        end
    end

    if gameState == 'play' then
        gameSpeed = math.max(minGameSpeed, gameSpeed - 0.001*dt)
    end

end

function love.keypressed(key)
    if key == 'escape' then
        if gameState == 'pause' then
            love.event.quit()
        elseif gameState ~= 'end' and gameState ~= 'pause' then
            gameState = 'pause'
        end
    end

    if (key == 'enter' or key == 'return') and (gameState == 'start' or gameState == 'pause') then
        gameState = 'play'
    end

end

function love.draw()

    push:apply('start')

    if gameState ~= 'start' then
        centerBlock:render()
        tetriminoManager:render()
    end

    if gameState == 'start' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Welcome To 4D Block Organizer!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Start!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf("Score: " .. tostring(scoreDisplay), 0, 5, VIRTUAL_WIDTH, 'left')
    elseif gameState == 'pause' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('The Game Is Paused, You Are Safe', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Resume!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'end' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Game Over!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Score: ' .. tostring(scoreDisplay), 0, 20, VIRTUAL_WIDTH, 'center')
    end

    local y_print = 10
    for key, value in pairs(tetriminoTable) do
        love.graphics.printf('Tetrimino: ' .. tostring(key), 0, y_print, VIRTUAL_WIDTH, 'right')
        y_print = y_print + 10 
    end
    for key, value in pairs(centerBlockTable) do
         love.graphics.printf('CenterBlock: ' .. tostring(key), 0, y_print, VIRTUAL_WIDTH, 'right')
         y_print = y_print + 10
    end


    push:apply('end')

end
