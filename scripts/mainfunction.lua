require "entity"
require "linkedlist"

local EntId = 0
EntsCount = 0
UpdatingEntsCount = 0
Ents = {}
UpdatingEnts = {}
NewUpdatingEnts = {}
StopUpdatingCmps = {}
Components = {}
Textures = {}
RenderList = List(function(n1, n2)
    return n1.data.z > n2.data.z
end)

function CreateEntity()
    EntId = EntId + 1
    local ent = Entity()
    ent.id = EntId
    Ents[EntId] = ent
    EntsCount = EntsCount + 1
    return ent
end

function RemoveEntity(id)
    local ent = Ents[id]
    if ent then
        ent:OnRemove()
    end
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

function MainDraw()
    local iter = RenderList:Iterator()
    while iter.next() do
        iter.current.data.renderer:Draw()
    end
end

function CreateTexture(name)
    assert(Textures[name] == nil, "texture " .. name .. " already existed")
    local filepath = "assets/" .. name .. ".png"
    local texture = API.LoadTexture(filepath)
    Textures[name] = texture
end

function RemoveTexture(name)
    local texture = Textures[name]
    if texture then
        Textures[name] = nil
        API.ObjectRelease(texture)
    end
end

function GetTexture(name)
    local texture = Textures[name]
    assert(texture, "texture " .. name .. " not exist")
    return texture
end

function Start()
    local function TestEntity()
        local ent = CreateEntity()
        local tf = ent:AddComponent(Transform.StaticName)
        local sp = ent:AddComponent(Sprite.StaticName)
        local re = ent:AddComponent(Renderer.StaticName)
        tf.position = Vector3(100, 100, 0)
        sp:SetTexture(GetTexture("tank"))
        re:Enter()
    end
    
    TestEntity()
end