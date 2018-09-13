QuadMesh = Class(function(self, ent, x, y, w, h, width, height, anchorx, anchory)
    self.ent = ent
    self.obj = API.NewQuad(x, y, w, h, width, height)
    self.anchor = {x = anchorx, y = anchory}
    self.origin = {x = w * self.anchor.x, y = h * self.anchor.y}
end)

function QuadMesh:OnRemoveFromEntity()
    self.ent = nil
    API.ObjectRelease(self.obj)
    self.obj = nil
end

function QuadMesh:SetViewport(x, y, w, h)
    self.obj:setViewport(x, y, w, h)
    self.origin.x = w * self.anchor.x
    self.origin.y = h * self.anchor.y
end

function QuadMesh:SetAnchor(x, y)
    self.anchor.x = x
    self.anchor.y = y
    _, _, w, h = self.obj:getViewport()
    self.origin.x = w * self.anchor.x
    self.origin.y = h * self.anchor.y
end

function QuadMesh:Draw(texture, transform)
    API.DrawQuad(texture, self.obj, transform, self.origin)
end

return QuadMesh