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

function API.DrawQuad(texture, quad, transform)
    love.graphics.draw(texture, quad, transform.position.x, transform.position.y, transform.rotation, transform.scale.x, transform.scale.y)
end