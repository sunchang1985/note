require "entity"

local EntId = 0
UpdatingEntsCount = 0
Ents = {}
UpdatingEnts = {}
NewUpdatingEnts = {}
StopUpdatingCmps = {}
Components = {}

function CreateEntity()
    EntId = EntId + 1
    local ent = Entity()
    ent.id = EntId
    Ents[EntId] = ent
    return ent
end

function LoadComponent(name)
    if Components[name] == nil then
        local path = "components." .. name
        Components[name] = require(path)
        assert(Components[name], "cloud not load component " .. name)
    end
    return Components[name]
end

function MainUpdate(dt)
    ComponentsUpdate(dt)
end

function ComponentsUpdate(dt)
    for entId, ent in pairs(UpdatingEnts) do
        if ent.updatingComponents then
            for cmpInstance in pairs(ent.updatingComponents) do
                if not StopUpdatingCmps[cmpInstance] and cmpInstance.OnUpdate then
                    cmpInstance:OnUpdate(dt)
                end
            end
        end
    end

    if next(NewUpdatingEnts) ~= nil then
        for entId, ent in pairs(NewUpdatingEnts) do
            UpdatingEnts[entId] = ent
        end
        NewUpdatingEnts = {}
    end

    if next(StopUpdatingCmps) ~= nil then
        for cmpInstance, ent in pairs(StopUpdatingCmps) do
            ent:StopUpdatingComponentDone(cmpInstance)
        end
        StopUpdatingCmps = {}
    end
end