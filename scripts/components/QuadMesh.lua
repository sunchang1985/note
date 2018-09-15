QuadMesh = Class(function(self, ent, x, y, w, h, width, height, anchorx, anchory)
    self.ent = ent
    self.ent.quadmesh = self
    self.display = true
    self.obj = API.NewQuad(x, y, w, h, width, height)
    self.anchor = {x = anchorx or 0.5, y = anchory or 0.5}
    self.origin = {x = w * self.anchor.x, y = h * self.anchor.y}
end)

function QuadMesh:OnRemoveFromEntity()
    self.ent.quadmesh = nil
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

function QuadMesh:SetDisplay(f)
    self.display = f
end

function QuadMesh:Draw()
    API.DrawQuad(self.ent.texture.rawtexture, self.obj, self.ent.transform, self.origin)
end

return QuadMesh