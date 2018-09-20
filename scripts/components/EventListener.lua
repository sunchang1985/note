EventListener = Class(function(self, ent)
    self.ent = ent
    self.ent.eventlistener = self
    self.evt = {}
end)

function EventListener:OnRemoveFromEntity()
    self.ent.eventlistener = nil
    self.ent = nil
    self.evt = nil
end

function EventListener:Register(eventname, fn)
    self.evt[eventname] = fn
end

function EventListener:Dispatch(eventname)
    local fn = self.evt[eventname]
    if fn then
        fn(self.ent)
    end
end

return EventListener