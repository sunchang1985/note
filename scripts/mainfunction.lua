require "nativeapi"
require "tinyclass"
require "util"
require "entity"
require "linkedlist"
require "prefab"
bump = require "libs.bump"
local debuginfo = require "debuginfo"

mfn = {
    EntId = 0,
    EntsCount = 0,
    UpdatingEntsCount = 0,
    Ents = {},
    UpdatingEnts = {},
    NewUpdatingEnts = {},
    StopUpdatingCmps = {},
    Components = {},
    Textures = {},
    RenderList = List(function(n1, n2)
        return n1.data.z > n2.data.z
    end),
    Fonts = {},
    Prefabs = {}
}


function mfn:CreateEntity()
    self.EntId = self.EntId + 1
    local ent = Entity()
    ent.id = self.EntId
    self.Ents[self.EntId] = ent
    self.EntsCount = self.EntsCount + 1
    return ent
end

function mfn:RemoveEntity(id)
    local ent = self.Ents[id]
    if ent then
        ent:OnRemove()
    end
end

function mfn:LoadComponent(name)
    if self.Components[name] == nil then
        local path = "components." .. name
        self.Components[name] = require(path)
        assert(self.Components[name], "cloud not load component " .. name)
    end
    return self.Components[name]
end

function mfn:LoadPrefab(name)
    if self.Prefabs[name] == nil then
        local path = "prefabs." .. name
        self.Prefabs[name] = require(path)
        assert(self.Prefabs[name], "cloud not load prefab " .. name)
    end
    return self.Prefabs[name]
end

function mfn:Update(dt)
    self:ComponentsUpdate(dt)
    debuginfo:Update()
end

function mfn:ComponentsUpdate(dt)
    for entId, ent in pairs(self.UpdatingEnts) do
        if ent.updatingComponents then
            for cmpInstance in pairs(ent.updatingComponents) do
                if not self.StopUpdatingCmps[cmpInstance] and cmpInstance.OnUpdate then
                    cmpInstance:OnUpdate(dt)
                end
            end
        end
    end

    if next(self.NewUpdatingEnts) ~= nil then
        for entId, ent in pairs(self.NewUpdatingEnts) do
            self.UpdatingEnts[entId] = ent
        end
        self.NewUpdatingEnts = {}
    end

    if next(self.StopUpdatingCmps) ~= nil then
        for cmpInstance, ent in pairs(self.StopUpdatingCmps) do
            ent:StopUpdatingComponentDone(cmpInstance)
        end
        self.StopUpdatingCmps = {}
    end
end

function mfn:EnterRenderList(node)
    self.RenderList:Insert(node)
end

function mfn:ExitRenderList(node)
    self.RenderList:Remove(node)
end

function mfn:Draw()
    local iter = self.RenderList:Iterator()
    while iter.next() do
        iter.current.data.renderer:Draw()
    end

    debuginfo:Draw()
end

function mfn:CreateTexture(name)
    assert(self.Textures[name] == nil, "texture " .. name .. " already existed")
    local filepath = "assets/" .. name .. ".png"
    local texture = API.LoadTexture(filepath)
    self.Textures[name] = texture
end

function mfn:RemoveTexture(name)
    local texture = self.Textures[name]
    if texture then
        self.Textures[name] = nil
        API.ObjectRelease(texture)
    end
end

function mfn:GetTexture(name)
    local texture = self.Textures[name]
    assert(texture, "texture " .. name .. " not exist")
    return texture
end

function mfn:GetFont(fontname, fontsize)
    local fontkey = string.format("%s%s", fontname, fontsize)
    local font = self.Fonts[fontkey]
    if not font then
        font = API.NewFont(fontname, fontsize)
        self.Fonts[fontkey] = font
    end
    return font
end

function mfn:Load()
    self:CreateTexture("icon")
    self:Main()
end

function mfn:Main()
    local function TestEntity()
        local ent = self:CreateEntity()
        ent:AddDisplayFeature("icon")
        ent.transform:SetWorldPosition(200, 200, 0)
        ent:SetActive(true)
        local label = self:LoadPrefab("label"):Instantiate()
        label.transform:SetWorldPosition(200, 200, -1)
        label.transform.rotation = 45
        label.text:SetAnchor(0.5, 0.5)
        label.text:SetSize(100, 100)
        label.text:SetAlign("left")
        label.text:SetValue("中国中国中国中国中国中国中国")
        label:SetActive(true)
    end
    
    TestEntity()
end
