push = require 'push'
Class = require 'Class'

require 'CenterBlock'
require 'TetriminoManager'
require 'Util'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

local score = 0
local scoreDisplay = score
local timeElapsed = 0
local gameSpeed = 1

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('4D-Block-Organizer')

    fonts = {

    }

    sounds = {

    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    util = Util()
    centerBlock = CenterBlock(util, parameters)
    tetriminoManager = TetriminoManager(util, parameters)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    timeElapsed = timeElapsed + dt

    if gameState ~= 'pause' then
        --Play backgroudn music
    end

    if timeElapsed > gameSpeed then
        timeElapsed = 0
        gameSpeed = gameSpeed * 0.95

        if gameState == 'play' then
            score = score + dt
            scoreDisplay = math.floor(score)

            centerBlock:update(dt)
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

        end
    end

end

function love.keypressed(key)
    if key == 'escape' then
        gameState = 'pause'
    end
    
    --Possible bug here at the end of gmae
    if (key == 'enter' or key == 'return') and gameState == 'pause' then
        gameState = 'play'
    end

end

function love.draw()
    if gameState == 'start' then
        --Draw start messge
    elseif gameState == 'play' then
        centerBlock:render()
        tetriminoManager:render()
    elseif gameState == 'pause' then
        --Display pause message
    elseif gameState == 'end' then
        --Display end message
    end
end