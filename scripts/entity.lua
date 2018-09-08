Entity = Class(function(self)
    self.id = 0
    self.components = {}
    self.updatingComponents = nil
    self.children = nil
    self.parent = nil
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
    NewUpdatingEnts[self.id] = nil
    if UpdatingEnts[self.id] then
        UpdatingEnts[self.id] = nil
        UpdatingEntsCount = UpdatingEntsCount - 1
    end
    Ents[self.id] = nil
    EntsCount = EntsCount - 1
end

function Entity:AddComponent(name)
    assert(self.components[name] == nil, "component " .. name .. " already existed")
    local Comp = LoadComponent(name)
    local cmpInstance = Comp(self)
    self.components[name] = cmpInstance
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
        NewUpdatingEnts[self.id] = self
        UpdatingEntsCount = UpdatingEntsCount + 1
    end

    if StopUpdatingCmps[cmpInstance] == self then
        StopUpdatingCmps[cmpInstance] = nil
    end
    self.updatingComponents[cmpInstance] = cmpInstance.StaticName or "component"
end

function Entity:StopUpdatingComponent(cmpInstance)
    if self.updatingComponents then
        StopUpdatingCmps[cmpInstance] = self
    end
end

function Entity:StopUpdatingComponentDone(cmpInstance)
    if self.updatingComponents then
        self.updatingComponents[cmpInstance] = nil
        local num = TableLength(self.updatingComponents)
        if num == 0 then
            self.updatingComponents = nil
            UpdatingEnts[self.id] = nil
            NewUpdatingEnts[self.id] = nil
            UpdatingEntsCount = UpdatingEntsCount - 1
        end
    end
end

function Entity:RemoveChild(child)
    child.parent = nil
    if self.children then
        self.children[child] = nil
    end
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
end

function Entity:IsValid()
    return true
end