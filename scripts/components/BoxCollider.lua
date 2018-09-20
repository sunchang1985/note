BoxCollider = Class(function(self, ent, width, height)
    self.ent = ent
    self.ent.boxcollider = self
    self.bounds = {x = 0, y = 0, w = width, h = height}
    self.anchor = {x = 0, y = 0}
    self.mesh = nil
    self.collidernode = nil
end)

function BoxCollider:OnRemoveFromEntity()
    self.ent.boxcollider = nil
    self.ent = nil
    self.mesh = nil
    self:Exit()
end

function BoxCollider:Enter()
    local transform = self.ent.transform
    local quadmesh = self.ent.quadmesh
    local text = self.ent.text
    local mesh = quadmesh or text
    assert(mesh, "no mesh component")
    self.mesh = mesh
    self.anchor.x, self.anchor.y = self.mesh:GetAnchor()
    local meshw, meshh = self.mesh:GetSize()
    if not self.bounds.w then
        self.bounds.w = meshw
    end
    if not self.bounds.h then
        self.bounds.h = meshh
    end
    self:CalcBounds()
    self.collidernode = Node({z = transform.position.z, collider = self})
    mfn:EnterColliderList(self.collidernode)
end

function BoxCollider:Exit()
    if self.collidernode then
        self.collidernode.data.collider = nil
        mfn:ExitColliderList(self.collidernode)
        self.collidernode = nil
    end
end

function BoxCollider:CalcBounds()
    local transform = self.ent.transform
    local offsetx = (self.bounds.w or 0) * self.anchor.x
    local offsety = (self.bounds.h or 0) * self.anchor.y
    self.bounds.x = transform.position.x - offsetx
    self.bounds.y = transform.position.y - offsety
end

function BoxCollider:InBounds(x, y)
    if x >= self.bounds.x and x <= self.bounds.x + self.bounds.w and y >= self.bounds.y and y <= self.bounds.y + self.bounds.h then
        return true
    else
        return false
    end
end

return BoxCollider