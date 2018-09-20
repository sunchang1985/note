Renderer = Class(function(self, ent)
    self.ent = ent
    self.ent.renderer = self
    self.mesh = nil
    self.rendernode = nil
end)

function Renderer:OnRemoveFromEntity()
    self.ent.renderer = nil
    self.ent = nil
    self.mesh = nil
    self:Exit()
end

function Renderer:Draw()
    if not self.mesh.display then return end
    self.mesh:Draw()
end

function Renderer:Enter()
    local transform = self.ent.transform
    local quadmesh = self.ent.quadmesh
    local text = self.ent.text
    local mesh = quadmesh or text
    assert(mesh, "no mesh component")
    self.mesh = mesh
    self.rendernode = Node({z = transform.position.z, renderer = self})
    mfn:EnterRenderList(self.rendernode)
end

function Renderer:Exit()
    if self.rendernode then
        self.rendernode.data.renderer = nil
        mfn:ExitRenderList(self.rendernode)
        self.rendernode = nil
    end
end

return Renderer