plugin {
    id = "org.programmershigh.movement",
    name = "Movement",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

action {
    id = "move.next.selection",
    name = "Move to Next Selection",
    apply = function(context)
        local model = context.activePane.model
        for i = model.currentIndex + 1, model.lastIndex do
            if model:isSelected(i) then
                model.currentIndex = i
                break
            end
        end
    end
}

action {
    id = "move.previous.selection",
    name = "Move to Previous Selection",
    apply = function(context)
        local model = context.activePane.model
        for i = model.currentIndex - 1, 0, -1 do
            if model:isSelected(i) then
                model.currentIndex = i
                break
            end
        end
    end
}
