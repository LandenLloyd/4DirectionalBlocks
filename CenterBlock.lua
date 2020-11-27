CenterBlock = Class{}


function CenterBlock:init(x,y,height,width)
    self.x = x
    self.y = y
    self.height = height
    self.width = height
    self.dy = 0
    self.dx = 0
end

function CenterBlock:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

function CenterBlock:rotate()

end 

function CenterBlock:render()
    love.graphics.square('fill', self.x, self.y, self.width, self.height)
end    