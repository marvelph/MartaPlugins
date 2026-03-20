plugin {
    id = "org.programmershigh.rename",
    name = "Rename",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

local function prompt()
    local script = 'display dialog "Pattern" with title "Rename with Pattern" default answer "{index:2}-{name}.{extension}" buttons {"Cancel", "Rename"} default button "Rename"'
    local handle = io.popen("osascript -e '" .. script .. "'")
    local result = handle:read("*a")
    handle:close()
    local button, text = result:match("button returned:(.*), text returned:([^\n]*)")
    if button == "Rename" then
        return text
    else
        return nil
    end
end

local function buildName(pattern, index, name, extension)
    return string.gsub(pattern, "{([^}]*)}",
        function(placeholder)
            if placeholder == "index" then
                return tostring(index)
            elseif placeholder:match("^index:%d+$") then
                local digits = placeholder:match("^index:(%d+)$")
                return string.format("%0" .. digits .. "d", index)
            elseif placeholder == "name" then
                return name
            elseif placeholder == "extension" then
                return extension
            else
                return "{" .. placeholder .. "}"
            end
        end
    )
end

action {
    id = "rename.pattern",
    name = "Rename with Pattern",
    apply = function(context)
        local pattern = prompt()
        if not pattern then
            return
        end

        local model = context.activePane.model
        local index = 1
        for _, info in ipairs(model.activeFileInfos) do
            if info.isFile then
                local file = info.file
                local name = buildName(pattern, index, file.nameWithoutExtension, file.extension)
                file:rename(file.parent:resolve(name).path)
            end
        end
    end
}
