Texture = Class(function(self, ent)
    self.ent = ent
    self.ent.texture = self
    self.rawtexture = nil
    self.texWidth = 0
    self.texHeight = 0
end
)

function Texture:OnRemoveFromEntity()
    self.ent.texture = nil
    self.ent = nil
    self.rawtexture = nil
end

function Texture:SetRawTexture(t)
    self.rawtexture = t
    self.texWidth, self.texHeight = self.rawtexture:getDimensions()
end

return Texture