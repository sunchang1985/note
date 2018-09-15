local function fn(asset)
    local ent = mfn:CreateEntity()
    local tex = ent:AddComponent("Texture")
    tex:SetRawTexture(mfn:GetTexture(asset.texname))
    ent:AddComponent("QuadMesh", 0, 0, tex.texWidth, tex.texHeight, tex.texWidth, tex.texHeight)
    ent:AddComponent("Renderer")
    return ent
end

return Prefab("sprite", fn)