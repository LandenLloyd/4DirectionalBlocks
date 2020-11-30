CenterBlock = Class{}


function CenterBlock:init(util, centerBlockTable, tetriminoTable, x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.dx = 0
    VIRTUAL_WIDTH = 320
    VIRTUAL_HEIGHT = 180
end

function CenterBlock:update(dt)
    -- moves center block along with keys
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end    

function CenterBlock:outOfBounds()
    -- detects if center block has gone off screen
    -- if not out of bounds returns false
    if self.x < 0 then
        return true
    end
    
    if self.x > VIRTUAL_WIDTH then
        return true
    end
    
    if self.y < 0 then
        return true
    end
    
    if self.y > VIRTUAL_HEIGHT then
        return true
    end    

    return false
end

function CenterBlock:render()
    love.graphics.setColor(0, 128/255, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end    
