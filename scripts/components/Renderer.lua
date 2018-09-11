Renderer = Class(function(self, ent)
    self.ent = ent
    self.transform = nil
    self.sprite = nil
    self.mesh = nil
    self.rendernode = nil
end)

function Renderer:OnRemoveFromEntity()
    self.ent = nil
    self.transform = nil
    self.sprite = nil
    self.mesh = nil
    self:Exit()
end

function Renderer:Draw()
    if not self.sprite.display then return end
    API.DrawQuad(self.sprite.texture, self.mesh.quad, self.transform)
end

function Renderer:Enter()
    local transform = self.ent.components[Transform.StaticName]
    assert(transform, "no transform component")
    local sprite = self.ent.components[Sprite.StaticName]
    assert(sprite, "no sprite component")
    local mesh = self.ent.components[Mesh.StaticName]
    assert(mesh, "no mesh component")
    self.transform = transform
    self.sprite = sprite
    self.mesh = mesh
    self.rendernode = Node({z = transform.position.z, renderer = self})
    RenderList:Insert(self.rendernode)
end

function Renderer:Exit()
    if self.rendernode then
        RenderList:Remove(self.rendernode)
        self.rendernode.data.renderer = nil
        self.rendernode.data = nil
        self.rendernode.prev = nil
        self.rendernode.next = nil
        self.rendernode = nil
    end
end

Renderer.StaticName = "Renderer"
return Renderer