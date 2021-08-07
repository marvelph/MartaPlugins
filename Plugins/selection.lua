plugin {
    id = "org.programmershigh.selection",
    name = "Selection",
    apiVersion = "2.0"
}

local function compare(item1, item2)
    local info1 = item1.info
    local info2 = item2.info
    return info1.isFolder == info2.isFolder and info1.name == info2.name and info1.size == info2.size and info1.dateCreated == info2.dateCreated and info1.dateModified == info2.dateModified
end

local function find(model, item)
    for i = 1, model.lastIndex do
        if compare(model:getItem(i), item) then
            return true
        end
    end
    return false
end

action {
    id = "select.same",
    name = "Select Same",
    apply = function(context)
        local model = context.activePane.model
        for i = 1, model.lastIndex do
            local item = model:getItem(i)
            if not item.info.isFolder and find(context.inactivePane.model, item) then
                model:select({from = i, to = i + 1})
            end
        end
    end
}

action {
    id = "select.different",
    name = "Select Different",
    apply = function(context)
        local model = context.activePane.model
        for i = 1, model.lastIndex do
            local item = model:getItem(i)
            if not item.info.isFolder and not find(context.inactivePane.model, item) then
                model:select({from = i, to = i + 1})
            end
        end
    end
}

action {
    id = "select.all.file",
    name = "Select All File",
    apply = function(context)
        local model = context.activePane.model
        for i = 1, model.lastIndex do
            if not model:getItem(i).info.isFolder then
                model:select({from = i, to = i + 1})
            end
        end
    end
}

action {
    id = "select.invert.file",
    name = "Invert Selection File",
    apply = function(context)
        local model = context.activePane.model
        for i = 1, model.lastIndex do
            if not model:getItem(i).info.isFolder then
                model:invertSelection({from = i, to = i + 1})
            end
        end
    end
}
