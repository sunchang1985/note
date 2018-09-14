Entity = Class(function(self)
    self.id = 0
    self.components = {}
    self.updatingComponents = nil
    self.children = nil
    self.parent = nil
    self.activeSelf = false
end
)

function Entity:OnRemove()
    if self.parent then
        self.parent:RemoveChild(self)
        self.parent = nil
    end
    if self.children then
        for ent in pairs(self.children) do
            ent:OnRemove()
        end
    end
    for _, cmpInstance in pairs(self.components) do
        if cmpInstance.OnRemoveFromEntity then
            cmpInstance:OnRemoveFromEntity()
        end
    end
    self.updatingComponents = nil
    mfn.NewUpdatingEnts[self.id] = nil
    if mfn.UpdatingEnts[self.id] then
        mfn.UpdatingEnts[self.id] = nil
        mfn.UpdatingEntsCount = mfn.UpdatingEntsCount - 1
    end
    mfn.Ents[self.id] = nil
    mfn.EntsCount = mfn.EntsCount - 1
end

function Entity:AddComponent(name, ...)
    assert(self.components[name] == nil, "component " .. name .. " already existed")
    local Comp = mfn:LoadComponent(name)
    local cmpInstance = Comp(self, ...)
    self.components[name] = cmpInstance
    return cmpInstance
end

function Entity:RemoveComponent(name)
    local cmpInstance = self.components[name]
    if cmpInstance then
        self:StopUpdatingComponent(cmpInstance)
        if cmpInstance.OnRemoveFromEntity then
            cmpInstance:OnRemoveFromEntity()
        end
        self.components[name] = nil
    end
end

function Entity:StartUpdatingComponent(cmpInstance)
    if not self:IsValid() then
        return
    end

    if not self.updatingComponents then
        self.updatingComponents = {}
        mfn.NewUpdatingEnts[self.id] = self
        mfn.UpdatingEntsCount = mfn.UpdatingEntsCount + 1
    end

    if mfn.StopUpdatingCmps[cmpInstance] == self then
        mfn.StopUpdatingCmps[cmpInstance] = nil
    end
    self.updatingComponents[cmpInstance] = cmpInstance or "component"
end

function Entity:StopUpdatingComponent(cmpInstance)
    if self.updatingComponents then
        mfn.StopUpdatingCmps[cmpInstance] = self
    end
end

function Entity:StopUpdatingComponentDone(cmpInstance)
    if self.updatingComponents then
        self.updatingComponents[cmpInstance] = nil
        local num = TableLength(self.updatingComponents)
        if num == 0 then
            self.updatingComponents = nil
            mfn.UpdatingEnts[self.id] = nil
            mfn.NewUpdatingEnts[self.id] = nil
            mfn.UpdatingEntsCount = mfn.UpdatingEntsCount - 1
        end
    end
end

function Entity:RemoveChild(child)
    child.parent = nil
    if self.children then
        self.children[child] = nil
    end
    local childPosition = child.transform.position
    child.transform:SetLocalPosition(childPosition.x, childPosition.y, childPosition.z)
end

function Entity:AddChild(child)
    if child.parent then
        child.parent:RemoveChild(child)
    end

    if not self.children then
        self.children = {}
    end
    self.children[child] = child.name or "entity"
    child.parent = self
    local childPosition = child.transform.position
    child.transform:SetWorldPosition(childPosition.x, childPosition.y, childPosition.z)
end

function Entity:AddDisplayFeature(texname)
    local sp = self:AddComponent("Sprite")
    sp:SetTexture(mfn:GetTexture(texname))
    self:AddComponent("QuadMesh", 0, 0, sp.texWidth, sp.texHeight, sp.texWidth, sp.texHeight, 0.5, 0.5)
    self:AddComponent("Renderer")
end

function Entity:SetActive(active)
    if self.activeSelf and not active then
        local re = self.renderer
        if re then
            re:Exit()
        end
        if self.children then
            for ent in pairs(self.children) do
                ent:SetActive(active)
            end
        end
    elseif not self.activeSelf and active then
        local re = self.renderer
        if re then
            re:Enter()
        end
        if self.children then
            for ent in pairs(self.children) do
                ent:SetActive(active)
            end
        end
    end
    self.activeSelf = active
end

function Entity:IsValid()
    return true
end