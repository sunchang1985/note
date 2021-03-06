require "nativeapi"
require "tinyclass"
require "util"
require "entity"
require "linkedlist"
require "prefab"
require "fastapi"
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
    ColliderList = List(function(n1, n2)
        return n1.data.z < n2.data.z
    end),
    Fonts = {},
    Prefabs = {},
    MouseTarget = nil
}


function mfn:CreateEntity()
    self.EntId = self.EntId + 1
    local ent = Entity()
    ent.id = self.EntId
    self.Ents[self.EntId] = ent
    self.EntsCount = self.EntsCount + 1
    ent:AddComponent("Transform")
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

function mfn:EnterColliderList(node)
    self.ColliderList:Insert(node)
end

function mfn:ExitColliderList(node)
    self.ColliderList:Remove(node)
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

function mfn:MousePressed(x, y, button)
    if button == 1 then
        local iter = self.ColliderList:Iterator()
        while iter.next() do
            local collider = iter.current.data.collider
            if collider:InBounds(x, y) then
                self.MouseTarget = collider.ent
                if self.MouseTarget.state then
                    self.MouseTarget.state.pressed = true
                end
                if self.MouseTarget.eventlistener then
                    self.MouseTarget.eventlistener:Dispatch("mousepressed")
                end
                break;
            end
        end
    end
end

function mfn:MouseReleased(x, y, button)
    if button == 1 then
        local target = nil
        local iter = self.ColliderList:Iterator()
        while iter.next() do
            local collider = iter.current.data.collider
            if collider:InBounds(x, y) then
                target = collider.ent
                break;
            end
        end
        if self.MouseTarget then
            if self.MouseTarget.state then
                self.MouseTarget.state.pressed = false
            end
            if self.MouseTarget.eventlistener then
                self.MouseTarget.eventlistener:Dispatch("mousereleased")
            end
        end
        if target and target == self.MouseTarget then
            if self.MouseTarget.state then
                self.MouseTarget.state.pressed = false
            end
            if self.MouseTarget.eventlistener then
                self.MouseTarget.eventlistener:Dispatch("mouseclicked")
            end
        end
        self.MouseTarget = nil
    end
end

function mfn:Load()
    self:CreateTexture("icon")
    self:Main()
end

function mfn:Main()
    local function TestEntity()
        local label = fastfab("label", {text = "NONE"})
        label.transform:SetWorldPosition(200, 400, 1)
        label:SetActive(true)
        local btn = fastfab("button", {texname = "icon", text = {{1, 0, 0, 1}, "Button"}, mousepressedfn = function() 
            label.text:SetValue("pressed")
        end, mouseclickedfn = function()
            label.text:SetValue("clicked")
        end
        })
        btn.transform:SetWorldPosition(200, 200, 1)
        btn:SetActive(true)
    end
    
    TestEntity()
end
