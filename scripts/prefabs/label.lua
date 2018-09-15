local function fn(asset)
    local ent = mfn:CreateEntity()
    ent:AddComponent("Text")
    ent:AddComponent("Renderer")
    return ent
end

return Prefab("label", fn)