plugin {
    id = "org.programmershigh.selection",
    name = "Selection",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

local function find(inactiveModel, item)
    for i = 0, inactiveModel.lastIndex do
    local inactiveItem = inactiveModel:getItem(i)
        if inactiveItem.kind == "file" and inactiveItem.info.isFile and inactiveItem.info.name == item.info.name then
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
        local currentInfo = model.currentFileInfo
        if currentInfo ~= nil and currentInfo.isFile then
            for i = 0, model.lastIndex do
                local item = model:getItem(i)
                if item.kind == "file" and item.info.isFile and item.info.extension == currentInfo.extension then
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
