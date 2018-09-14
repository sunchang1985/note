require("vector3")

Transform = Class(function(self, ent)
    self.ent = ent
    self.ent.transform = self
    self.position = Vector3(-2147483648, -2147483648, -2147483648)
    self.scale = {x = 1.0, y = 1.0}
    self.rotation = 0
end
)

function Transform:OnRemoveFromEntity()
    self.ent.transform = nil
    self.ent = nil
end

function Transform:SetWorldPosition(x, y, z)
    local zz = self.position.z
    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
    self.position.z = z or self.position.z
    if zz ~= self.position.z and self.ent.activeSelf then
        local re = self.ent.renderer
        if re then
            re:Exit()
            re:Enter()
        end
    end
end

return Transform