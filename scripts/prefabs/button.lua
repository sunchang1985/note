local function fn(asset)
    local root = mfn:CreateEntity()
    local label = fastfab("label", asset)
    local bg = fastfab("sprite", asset)
    bg:AddComponent("BoxCollider")
    local eventlistener = bg:AddComponent("EventListener")
    eventlistener:Register("mousepressed", asset.mousepressedfn)
    eventlistener:Register("mousereleased", asset.mousereleasedfn)
    eventlistener:Register("mouseclicked", asset.mouseclickedfn)
    bg:AddComponent("State")
    root:AddChild(bg)
    root:AddChild(label)
    bg.transform:SetLocalPosition(0, 0, 0)
    label.transform:SetLocalPosition(0, 0, -0.1)
    return root
end

return Prefab("button", fn)