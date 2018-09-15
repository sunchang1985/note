Prefab = Class(function(self, name, fn)
    self.name = name
    self.fn = fn
end)

function Prefab:Instantiate(asset)
    return self.fn(asset)
end