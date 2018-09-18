BoxCollider = Class(function(self, ent)
    self.ent = ent
    self.ent.boxcollider = self
    self.size = {w = 0, h = 0}
end)

function BoxCollider:OnRemoveFromEntity()
    self.ent.boxcollider = nil
    self.ent = nil
end

function BoxCollider:Enter()
end

function BoxCollider:Exit()
end

return BoxCollider