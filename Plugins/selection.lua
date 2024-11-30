plugin {
    id = "org.programmershigh.selection",
    name = "Selection",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

function find(inactiveModel, item)
    local info = item.info
    if item.kind == "file" and info and info.isFile then
        for i = 0, inactiveModel.lastIndex do
            local inactiveItem = inactiveModel:getItem(i)
            local inactiveInfo = inactiveItem.info
            if inactiveItem.kind == "file" and inactiveInfo and inactiveInfo.isFile and inactiveInfo.name == info.name then
                return true
            end
        end
    end
    return false
end

action {
    id = "select.same.file",
    name = "Select Same File",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local model = context.activePane.model
            for i = 0, model.lastIndex do
                if find(inactivePane.model, model:getItem(i)) then
                    model:select(i)
                end
            end
        end
    end
}

action {
    id = "select.different.file",
    name = "Select Different File",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local model = context.activePane.model
            for i = 0, model.lastIndex do
                if not find(inactivePane.model, model:getItem(i)) then
                    model:select(i)
                end
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
            local info = item.info
            if item.kind == "file" and info and info.isFile then
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
            local info = item.info
            if item.kind == "file" and info and info.isFile then
                model:invertSelection(i)
            end
        end
    end
}

action {
    id = "select.extension",
    name = "Select Extension",
    apply = function(context)
        local model = context.activePane.model
        if model.hasCurrent then
            local currentItem = model:getItem(model.currentIndex)
            local currentInfo = currentItem.info
            if currentItem.kind == "file" and currentInfo and currentInfo.isFile then
                for i = 0, model.lastIndex do
                    local item = model:getItem(i)
                    local info = item.info
                    if item.kind == "file" and info and info.isFile and info.extension == currentInfo.extension then
                        model:select(i)
                    end
                end
            end
        end
    end
}
