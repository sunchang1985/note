API = {}
function API.LoadTexture(path)
    local image = love.graphics.newImage(path)
    return image
end

function API.ObjectRelease(object)
    object:release()
end

function API.NewQuad(x, y, w, h, width, height)
    return love.graphics.newQuad(x, y, w, h, width, height)
end

function API.NewFont(fontname, fontsize)
    local fontfile = string.format("assets/%s.ttf", fontname)
    return love.graphics.newFont(fontfile, fontsize)
end

function API.DrawQuad(texture, quad, transform, origin)
    love.graphics.draw(texture, quad, transform.position.x, transform.position.y, math.rad(transform.rotation), transform.scale.x, transform.scale.y, origin.x, origin.y)
end

function API.DrawText(font, text, transform, align, width, origin)
    love.graphics.setFont(font)
    love.graphics.printf(text, transform.position.x, transform.position.y, width, align, math.rad(transform.rotation), transform.scale.x, transform.scale.y, origin.x, origin.y)
end