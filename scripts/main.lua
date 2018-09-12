require "nativeapi"
require "tinyclass"
require "util"
require "mainfunction"
local fpsGraph = require "FPSGraph"
bump = require "libs.bump"

local fpsElements = {}
local function loadFps()
    -- fps graph
	local fpsG = fpsGraph.createGraph()
	-- memory graph
	local memG = fpsGraph.createGraph(0, 30)
	-- random graph
    local randomG = fpsGraph.createGraph(0, 60)
    table.insert(fpsElements, fpsG)
    table.insert(fpsElements, memG)
    table.insert(fpsElements, randomG)
end

local function randomUpdate(graph, dt, n)
    local val = love.math.random() * n
    fpsGraph.updateGraph(graph, val, "Random: " .. math.floor(val * 10) / 10, dt)
end

local function updateFps(dt)
    fpsGraph.updateFPS(fpsElements[1], dt)
	fpsGraph.updateMem(fpsElements[2], dt)
	randomUpdate(fpsElements[3], dt, 100)
end

local function drawFps()
    fpsGraph.drawGraphs(fpsElements)
end

function love.load()
    loadFps()
    font = love.graphics.newFont("assets/WRYH.ttf", 16)
    CreateTexture("icon")
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
    updateFps(dt)
end

function love.draw()
    MainDraw()
    drawFps()
end

function love.quit()
end
