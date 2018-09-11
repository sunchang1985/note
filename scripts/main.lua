require "nativeapi"
require "tinyclass"
require "util"
require "mainfunction"
bump = require "libs.bump"

function love.load()
    font = love.graphics.newFont("assets/WRYH.ttf", 16)
    CreateTexture("tank")
    Start()
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
end

function love.mousereleased(x, y, button)
end

function love.update(dt)
    MainUpdate(dt)
end

function love.draw()
    MainDraw()
end

function love.quit()
end
