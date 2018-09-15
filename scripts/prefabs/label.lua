local function fn(asset)
    local ent = mfn:CreateEntity()
    ent:AddComponent("Text")
    ent:AddComponent("Renderer")
    if asset.text then
        ent.text:SetValue(asset.text)
    end
    return ent
end

return Prefab("label", fn)