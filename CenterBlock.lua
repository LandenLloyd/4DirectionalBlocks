 CenterBlock = Class{}


function CenterBlock:init(util, centerBlockTable, tetriminoTable,x,y,blockHeight,blockWidth)
    self.x = x
    self.y = y
    self.height = blockHeight
    self.width = blockWidth
    self.dy = 0
    self.dx = 0
end

function CenterBlock:update()
    self.y = self.y + self.dy 
    self.x = self.x + self.dx 
end

function CenterBlock:up()
    self.dy = self.dy - self.height
end

function CenterBlock:down()
    self.dy = self.dy + self.height
end 

function CenterBlock:left()
    self.dx = self.dx - self.width
end

function CenterBlock:right()
    self.dx = self.dx + self.width
end

function CenterBlock:rotate()
    centerBlockTable = util:rotate(centerBlockTable)
end 

function CenterBlock:render()
    love.graphics.square('fill', self.x, self.y, self.width, self.height)
end 
