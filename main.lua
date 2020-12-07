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
score = 0

-- Variables for controlling the flow of the game
local timeElapsed = 0
local gameSpeed = 0.15
local minGameSpeed = 0.05

local endLoopPlayed = false

local keyPresses = {}

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('4D-Block-Organizer')

    titleFont = love.graphics.newFont('assets/font.ttf', 10)
    scoreFont = love.graphics.newFont('assets/font.ttf', 8)
    love.graphics.setFont(scoreFont)

    -- backgroudMusic credit Lion Free Music https://www.youtube.com/watch?v=dLFq9-P1eHQ
    -- offScreen credit Zapsplat.com 
    sounds = {
        ['backgroundMusic'] = love.audio.newSource('assets/backgroundMusic.mp3', 'static'),
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

    if timeElapsed > gameSpeed then
        timeElapsed = 0

        if gameState == 'play' then
            -- Player controls for center block
            if keyPresses['up'] ~= nil then
                centerBlock:up()
            elseif keyPresses['down'] ~= nil then
                centerBlock:down()
            end

            if keyPresses['left'] ~= nil then
                centerBlock:left()
            elseif keyPresses['right'] ~= nil then
                centerBlock:right()
            end

            if keyPresses['space'] ~= nil then
                centerBlock:rotate()
            end

            if centerBlock:outOfBounds() == true then
                gameState = 'end'
            end

            centerBlock:update(1)

            tick = tick + 1
            if tick >= 4 then
                tetriminoManager:update(1)
                tick = 0
            end

            tetriminoManager.hasReset = false
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
    keyPresses = {}
    keyPresses[key] = true

    if key == 'escape' then
        if gameState == 'pause' or gameState == 'end' then
            love.event.quit()
        else
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

    -- We like white font
    love.graphics.setColor(1, 1, 1, 1)

    if gameState == 'start' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Welcome To 4D Block Organizer!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Start!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('You gain control of blocks you collide with.', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('But you lose if you go off screen...', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Use WASD to move, and space to rotate right.', 0, 60, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Build the largest block you can!!!', 0, 70, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf("Score: " .. tostring(score), 0, 5, VIRTUAL_WIDTH, 'left')
    elseif gameState == 'pause' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('The Game Is Paused, You Are Safe', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter Or Return To Resume!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Or press escape to quit the game.', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'end' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Game Over!', 0, 10, VIRTUAL_WIDTH, 'center')
        sounds['backgroundMusic']:stop()
        if not endLoopPlayed then
            sounds['offScreen']:play()
            endLoopPlayed = true
        end
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Score: ' .. tostring(score), 0, 20, VIRTUAL_WIDTH, 'center')
    end

    push:apply('end')

end
