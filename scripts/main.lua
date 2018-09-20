require "mainfunction"

function love.load()
    mfn:Load()
end

function love.textinput(t)
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousemoved(x, y)
end

function love.mousepressed(x, y, button)
    mfn:MousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
    mfn:MouseReleased(x, y, button)
end

function love.update(dt)
    mfn:Update(dt)
end

function love.draw()
    mfn:Draw()
end

function love.quit()
end
