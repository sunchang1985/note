require("vector3")

Transform = Class(function(self, ent)
    self.ent = ent
    self.ent.transform = self
    self.position = Vector3(-2147483648, -2147483648, -2147483648)
    self.localposition = Vector3(-2147483648, -2147483648, -2147483648)
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
    if self.ent.parent then
        local pp = self.ent.parent.transform.position
        self.localposition.x = self.position.x - pp.x
        self.localposition.y = self.position.y - pp.y
        self.localposition.z = self.position.z - pp.z
    else
        self.localposition.x = self.position.x
        self.localposition.y = self.position.y
        self.localposition.z = self.position.z
    end
end

function Transform:SetLocalPosition(x, y, z)
    if self.ent.parent then
        local pp = self.ent.parent.transform.position
        self:SetWorldPosition(pp.x + x, pp.y + y, pp.z + z)
    else
        self:SetWorldPosition(x, y, z)
    end
end

return Transform