ClassRegistry = {}

function Class(base, ctor)
    local c = {}
    local cInherited = {}
    if not ctor and type(base) == "function" then
        ctor = base
        base = nil
    elseif type(base) == "table" then
        for k, v in pairs(base) do
            c[k] = v
            cInherited[k] = v
        end
    end
    c.base = base
    c.ctor = ctor
    c.__index = c
    c.instanceOf = function(self, clazz)
        local clz = getmetatable(self)
        while clz do
            if clz == clazz then
                return true
            end
            clz = clz.base
        end
        return false
    end
    local mt = {}
    mt.__call = function(_, ...)
        local instance = {}
        setmetatable(instance, c)
        if c.ctor then
            c.ctor(instance, ...)
        end
        return instance
    end
    setmetatable(c, mt)
    ClassRegistry[c] = cInherited
    return c
end