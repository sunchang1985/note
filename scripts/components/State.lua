State = Class(function(self, ent)
    self.ent = ent
    self.ent.state = self
    self.pressed = false
end)

function State:OnRemoveFromEntity()
    self.ent.state = nil
    self.ent = nil
    self.pressed = false
end

return State