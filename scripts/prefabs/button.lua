local function fn()
    local root = mfn:CreateEntity()
    local label = fastfab("label")
    
    return root
end

return Prefab("button", fn)