Mesh = Class(function(self, ent, x, y, w, h, width, height)
    self.ent = ent
    self.quad = API.NewQuad(x, y, w, h, width, height)
end)

function Mesh:OnRemoveFromEntity()
    self.ent = nil
    API.ObjectRelease(self.quad)
    self.quad = nil
end

function Mesh:SetViewport(x, y, w, h)
    self.quad:setViewport(x, y, w, h)
end

Mesh.StaticName = "Mesh"
return Mesh