Prefab = Class(function(self, name, fn)
    self.name = name
    self.fn = fn
end)

function Prefab:Instantiate()
    return self.fn()
end