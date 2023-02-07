plugin {
    id = "org.programmershigh.selection",
    name = "Selection",
    apiVersion = "2.1",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

local function compare(item1, item2)
    local info1 = item1.info
    local info2 = item2.info
    return info1.name == info2.name and info1.size == info2.size and info1.dateCreated == info2.dateCreated and info1.dateModified == info2.dateModified
end

local function find(anotherModel, item)
    for i = 0, anotherModel.lastIndex do
    local anotherItem = anotherModel:getItem(i)
        if anotherItem.kind == "file" and compare(anotherItem, item) then
            return true
        end
    end
    return false
end

action {
    id = "select.extension",
    name = "Select Extension",
    apply = function(context)
        local model = context.activePane.model
        local currentFile = model.currentFile
        if currentFile ~= nul then
            for i = 0, model.lastIndex do
                local item = model:getItem(i)
                if item.kind == "file" and item.info.pathExtension == currentFile.pathExtension then
                    model:select(i)
                end
            end
        end
    end
}

action {
    id = "select.same.file",
    name = "Select Same File",
    apply = function(context)
        local model = context.activePane.model
        for i = 0, model.lastIndex do
            local item = model:getItem(i)
            if item.kind == "file" and item.info.isFile and find(context.inactivePane.model, item) then
                model:select(i)
            end
        end
    end
}

action {
    id = "select.different.file",
    name = "Select Different File",
    apply = function(context)
        local model = context.activePane.model
        for i = 0, model.lastIndex do
            local item = model:getItem(i)
            if item.kind == "file" and item.info.isFile and not find(context.inactivePane.model, item) then
                model:select(i)
            end
        end
    end
}

action {
    id = "select.all.file",
    name = "Select All File",
    apply = function(context)
        local model = context.activePane.model
        for i = 0, model.lastIndex do
            local item = model:getItem(i)
            if item.kind == "file" and item.info.isFile then
                model:select(i)
            end
        end
    end
}

action {
    id = "select.invert.file",
    name = "Invert Selection File",
    apply = function(context)
        local model = context.activePane.model
        for i = 0, model.lastIndex do
            local item = model:getItem(i)
            if item.kind == "file" and item.info.isFile then
                model:invertSelection(i)
            end
        end
    end
}
