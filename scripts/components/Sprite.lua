Sprite = Class(function(self, ent)
    self.ent = ent
    self.ent.sprite = self
    self.texture = nil
    self.texWidth = 0
    self.texHeight = 0
end
)

function Sprite:OnRemoveFromEntity()
    self.ent.sprite = nil
    self.ent = nil
    self.texture = nil
end

function Sprite:SetTexture(t)
    self.texture = t
    self.texWidth, self.texHeight = self.texture:getDimensions()
end

return Sprite