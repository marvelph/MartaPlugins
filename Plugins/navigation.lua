plugin {
    id = "org.programmershigh.navigation",
    name = "Navigation",
    apiVersion = "2.0"
}

action {
    id = "change.current.pane.left",
    name = "Change Current Pane to Left",
    apply = function(context)
        if context.window.tabs:getPosition(context.activePane) == "right" then
            context.inactivePane:activateTab()
        end
    end
}

action {
    id = "change.current.pane.right",
    name = "Change Current Pane to Right",
    apply = function(context)
        if context.window.tabs:getPosition(context.activePane) == "left" then
            context.inactivePane:activateTab()
        end
    end
}

action {
    id = "clone.active",
    name = "Clone Current Folder to Acive Pane",
    apply = function(context)
        local folder = context.inactivePane.model.folder
        if folder ~= nil then
            context.activePane.model:load(folder)
        end
    end
}

action {
    id = "clone.inactive",
    name = "Clone Current Folder to Inacive Pane",
    apply = function(context)
        local folder = context.activePane.model.folder
        if folder ~= nil then
            context.inactivePane.model:load(folder)
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
