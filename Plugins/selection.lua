plugin {
    id = "org.programmershigh.selection",
    name = "Selection",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

local function collectFileNames(Pane)
    local fileNames = {}
    local model = Pane.model
    for i = 0, model.lastIndex do
        local item = model:getItem(i)
        local info = item.info
        if item.kind == "file" and info and info.isFile then
            fileNames[info.name] = true
        end
    end
    return fileNames
end

action {
    id = "select.same.file",
    name = "Select Same Files in Inactive Pane",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local inactiveFileNames = collectFileNames(inactivePane)
            local model = context.activePane.model
            for i = 0, model.lastIndex do
                local item = model:getItem(i)
                local info = item.info
                if item.kind == "file" and info and info.isFile and inactiveFileNames[info.name] then
                    model:select(i)
                end
            end
        end
    end
}

action {
    id = "select.different.file",
    name = "Select Files Not in Inactive Pane",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local inactiveFileNames = collectFileNames(inactivePane)
            local model = context.activePane.model
            for i = 0, model.lastIndex do
                local item = model:getItem(i)
                local info = item.info
                if item.kind == "file" and info and info.isFile and not inactiveFileNames[info.name] then
                    model:select(i)
                end
            end
        end
    end
}

action {
    id = "select.all.file",
    name = "Select All Files Only",
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
    name = "Invert File Selection Only",
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
    name = "Select Files with Same Extension as Current Item",
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
