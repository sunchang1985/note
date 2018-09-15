local function fn(asset)
    local root = mfn:CreateEntity()
    local label = fastfab("label", asset)
    local bg = fastfab("sprite", asset)
    root:AddChild(bg)
    root:AddChild(label)
    bg.transform:SetLocalPosition(0, 0, 0)
    label.transform:SetLocalPosition(0, 0, -0.1)
    return root
end

return Prefab("button", fn)