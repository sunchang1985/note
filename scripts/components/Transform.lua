require("vector3")

Transform = Class(function(self, ent)
    self.ent = ent
    self.position = Vector3()
    self.scale = Vector3(1, 1, 1)
    self.rotation = 0
end
)

function Transform:OnRemoveFromEntity()
    self.ent = nil
end

Transform.StaticName = "Transform"
return Transform