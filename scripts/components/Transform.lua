require("vector3")

Transform = Class(function(self, ent)
    self.ent = ent
    self.ent.transform = self
    self.position = Vector3(-2147483648, -2147483648, -2147483648)
    self.localposition = Vector3(-2147483648, -2147483648, -2147483648)
    self.scale = {x = 1.0, y = 1.0}
    self.localscale = {x = 1.0, y = 1.0}
    self.rotation = 0
    self.localrotation = 0
end
)

function Transform:OnRemoveFromEntity()
    self.ent.transform = nil
    self.ent = nil
end

function Transform:SetWorldPosition(x, y, z)
    local xx, yy, zz = self.position:Get()
    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
    self.position.z = z or self.position.z
    local boxcollider = self.ent.boxcollider
    if boxcollider then
        boxcollider:CalcBounds()
    end
    if zz ~= self.position.z and self.ent.activeSelf then
        local re = self.ent.renderer
        if re then
            re:Exit()
            re:Enter()
        end
        if boxcollider then
            boxcollider:Exit()
            boxcollider:Enter()
        end
    end
    if self.ent.parent then
        self.localposition.x = self.position.x - self.ent.parent.transform.position.x
        self.localposition.y = self.position.y - self.ent.parent.transform.position.y
        self.localposition.z = self.position.z - self.ent.parent.transform.position.z
    else
        self.localposition.x = self.position.x
        self.localposition.y = self.position.y
        self.localposition.z = self.position.z
    end
    if self.ent.children and not (self.position.x == xx and self.position.y == yy and self.position.z == zz) then
        for child in pairs(self.ent.children) do
            local childworldposx = self.position.x + child.transform.localposition.x
            local childworldposy = self.position.y + child.transform.localposition.y
            local childworldposz = self.position.z + child.transform.localposition.z
            child.transform:SetWorldPosition(childworldposx, childworldposy, childworldposz)
        end
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

function Transform:SetRotation(r)
    local rr = self.rotation
    self.rotation = r
    if self.ent.parent then
        self.localrotation = self.rotation - self.ent.parent.transform.rotation
    else
        self.localrotation = self.rotation
    end
    if self.ent.children and rr ~= r then
        for child in pairs(self.ent.children) do
            local childrotation = self.rotation + child.transform.localrotation
            child.transform:SetRotation(childrotation)
        end
    end
end

function Transform:SetLocalRotation(r)
    if self.ent.parent then
        self:SetRotation(self.ent.parent.transform.rotation + r)
    else
        self:SetRotation(r)
    end
end

function Transform:SetScale(x, y)
    local xx = self.scale.x
    local yy = self.scale.y
    self.scale.x = x
    self.scale.y = y
    if self.ent.parent then
        self.localscale.x = self.scale.x / self.ent.parent.transform.scale.x
        self.localscale.y = self.scale.y / self.ent.parent.transform.scale.y
    else
        self.localscale.x = self.scale.x
        self.localscale.y = self.scale.y
    end
    if self.ent.children and not (self.scale.x == xx and self.scale.y == yy) then
        for child in pairs(self.ent.children) do
            local childscalex = self.scale.x * child.transform.localscale.x
            local childscaley = self.scale.y * child.transform.localscale.y
            child.transform:SetScale(childscalex, childscaley)
        end
    end
end

function Transform:SetLocalScale(x, y)
    if self.ent.parent then
        self:SetScale(x * self.ent.parent.transform.scale.x, y * self.ent.parent.transform.scale.y)
    else
        self:SetScale(x, y)
    end
end

return Transform