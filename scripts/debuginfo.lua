local debuginfo = {}

function debuginfo:Update()
    self.fps = love.timer.getFPS()
    self.mem = math.floor(collectgarbage("count") * 10) / 10
    self.ents = mfn.EntsCount
    self.updatingents = mfn.UpdatingEntsCount
    self.drawcall = mfn.RenderList.length
end

function debuginfo:Draw()
    love.graphics.print("FPS: " .. self.fps, 0, 0)
    love.graphics.print("Memory (KB): " .. self.mem, 0, 20)
    love.graphics.print("ents: " .. self.ents, 0, 40)
    love.graphics.print("updatingents: " .. self.updatingents, 0, 60)
    love.graphics.print("drawcall: " .. self.drawcall, 0, 80)
end

return debuginfo