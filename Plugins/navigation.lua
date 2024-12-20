plugin {
    id = "org.programmershigh.navigation",
    name = "Navigation",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

action {
    id = "change.current.pane.left",
    name = "Change Current Pane to Left",
    apply = function(context)
        if context.window.tabs:getPosition(context.activePane) == "right" then
            local inactivePane = context.inactivePane
            if inactivePane then
                inactivePane:activateTab()
            end
        end
    end
}

action {
    id = "change.current.pane.right",
    name = "Change Current Pane to Right",
    apply = function(context)
        if context.window.tabs:getPosition(context.activePane) == "left" then
            local inactivePane = context.inactivePane
            if inactivePane then
                inactivePane:activateTab()
            end
        end
    end
}

action {
    id = "clone.active",
    name = "Clone Current Folder to Active Pane",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local folder = inactivePane.model.folder
            if folder then
                context.activePane.model:load(folder)
            end
        end
    end
}

action {
    id = "clone.inactive",
    name = "Clone Current Folder to Inactive Pane",
    apply = function(context)
        local inactivePane = context.inactivePane
        if inactivePane then
            local folder = context.activePane.model.folder
            if folder then
                inactivePane.model:load(folder)
            end
        end
    end
}

action {
    id = "go.root",
    name = "Go to Root",
    apply = function(context)
        context.activePane.model:load(localFileSystem:get("/"))
    end
}

action {
    id = "go.home",
    name = "Go to Home",
    apply = function(context)
        context.activePane.model:load(localFileSystem:get(martax.getHomeDirectory()))
    end
}
