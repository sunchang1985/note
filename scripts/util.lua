function TableLength(t)
    local len = 0
    for k, v in pairs(t) do
        len = len + 1
    end
    return len
end

function DebugTable(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end