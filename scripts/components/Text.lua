Text = Class(function(self, ent, textvalue, fontname, fontsize, align, width, anchorx, anchory)
    fontname = fontname or "WRYH"
    fontsize = fontsize or 16
    self.ent = ent
    self.ent.text = self
    self.display = true
    self.value = textvalue or "--+--"
    self.font = mfn:GetFont(fontname, fontsize)
    self.align = align or "center"
    self.w = width or 100
    self.h = fontsize
    self.anchor = {x = anchorx or 0.5, y = anchory or 0.5}
    self.origin = {x = self.w * self.anchor.x, y = self.h * self.anchor.y}
end
)

function Text:OnRemoveFromEntity()
    self.ent.text = nil
    self.ent = nil
end

function Text:SetDisplay(f)
    self.display = f
end

function Text:SetAnchor(x, y)
    self.anchor.x = x
    self.anchor.y = y
    self.origin.x = self.w * self.anchor.x
    self.origin.y = self.h * self.anchor.y
end

function Text:SetSize(w, h)
    self.w = w
    self.h = h
    self.origin.x = self.w * self.anchor.x
    self.origin.y = self.h * self.anchor.y
end

function Text:SetValue(textvalue)
    self.value = textvalue
end

function Text:SetAlign(align)
    self.align = align
end

function Text:Draw()
    API.DrawText(self.font, self.value, self.ent.transform, self.align, self.w, self.origin)
end

function Text:GetSize()
    return self.w, self.h
end

function Text:GetAnchor()
    return self.anchor.x, self.anchor.y
end

return Text