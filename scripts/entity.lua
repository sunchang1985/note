Entity = Class(function(self)
    self.id = 0
    self.components = {}
    self.updatingComponents = nil
    self.children = nil
    self.parent = nil
end
)

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

function Entity:IsValid()
    return true
end