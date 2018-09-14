local function fn()
    local ent = mfn:CreateEntity()
    ent:AddComponent("Transform")
    ent:AddComponent("Text")
    ent:AddComponent("Renderer")
    return ent
end

return Prefab("label", fn)