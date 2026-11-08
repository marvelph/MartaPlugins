plugin {
    id = "org.programmershigh.statusline",
    name = "Statusline",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

listModelHandler {
    locationChanged = function(context)
        context.activePane.view:addStatusText("locationChanged", "org.programmershigh.statusline", "beginning")
    end,
    modelReloaded = function(context)
        context.activePane.view:addStatusText("modelReloaded", "org.programmershigh.statusline", "beginning")
    end,
    modelUpdated = function(context)
        context.activePane.view:addStatusText("modelUpdated", "org.programmershigh.statusline", "beginning")
    end
}
