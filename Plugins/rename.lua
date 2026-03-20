plugin {
    id = "org.programmershigh.rename",
    name = "Rename",
    apiVersion = "2.2",
    author = "Kenji Nishishiro",
    email = "marvel@programmershigh.org",
    url = "https://github.com/marvelph/MartaPlugins"
}

local function escape(text)
    text = text:gsub("\\", "\\\\")
    text = text:gsub("\"", "\\\"")
    return text
end

local function dialog(message, defaultAnswer, hiddenAnswer, buttons, defaultButton, cancelButton, withTitle, withIcon, givingUpAfter)
    local script = "osascript <<'EOF'\n"
    script = script .. 'display dialog "' .. escape(message) .. '"'
    if defaultAnswer then
        script = script .. ' default answer "' .. escape(defaultAnswer) .. '"'
    end
    if hiddenAnswer then
        script = script .. ' hidden answer "' .. tostring(hiddenAnswer) .. '"'
    end
    if buttons then
        local items = {}
        for _, button in ipairs(buttons) do
            table.insert(items, '"' .. escape(button) .. '"')
        end
        script = script .. " buttons {" .. table.concat(items, ", ") .. "}"
    end
    if defaultButton then
        script = script .. ' default button "' .. escape(defaultButton) .. '"'
    end
    if cancelButton then
        script = script .. ' cancel button "' .. escape(cancelButton) .. '"'
    end
    if withTitle then
        script = script .. ' with title "' .. escape(withTitle) .. '"'
    end
    if withIcon then
        script = script .. ' with icon ' .. withIcon
    end
    if givingUpAfter then
        script = script .. ' giving up after ' .. givingUpAfter
    end
    script = script .. "\nEOF"

    local handle = io.popen(script)
    local result = handle:read("*a")
    handle:close()

    if result ~= "" then
        if givingUpAfter then
            local button, text, gaveUp = result:match("button returned:(.*), text returned:(.*), gave up:(.*)\n")
            return button, text, gaveUp == "true"
        else
            return result:match("button returned:(.*), text returned:(.*)\n")
        end
    else
        if givingUpAfter then
            return cancelButton, "", false
        else
            return cancelButton, ""
        end
    end
end

local function alert(message, description)
    message = message:gsub('"', '" & quote & "')
    message = message:gsub('\n', '" & return & "')
    description = description:gsub('"', '" & quote & "')
    description = description:gsub('\n', '" & return & "')
    local script = 'display alert "' .. message .. '" message "' .. description .. '" as warning buttons {"Skip", "Abort"} default button "Abort" cancel button "Skip"'
    local path = os.tmpname()
    local file = io.open(path, "w")
    file:write(script)
    file:close()
    print(script)
    local handle = io.popen("osascript '" .. path .. "'")
    local result = handle:read("*a")
    handle:close()
    local button, text = result:match("button returned:([^\n]*)")
    if button == "Abort" then
        return true
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
        local button, pattern = dialog("Pattern", "{index:2}-{name}.{extension}", nil, {"Cancel", "Rename"}, "Rename", "Cancel", "Rename with Pattern")
        if button == "Cancel" then
            return
        end

        local model = context.activePane.model
        local index = 1
        for _, info in ipairs(model.activeFileInfos) do
            if info.isFile then
                local file = info.file
                local name = buildName(pattern, index, file.nameWithoutExtension, file.extension)
                local error = file:rename(file.parent:resolve(name).path)
                if error then
                    print(error.description)
                    local message = "Can't rename \"" .. file.nameWithoutExtension .. "\""
                    local description = error.description .. "\n\n"
                    description = description .. "Full path: " .. tostring(file.path)
                    local abort = alert(message, description)
                    print(abort)
                    if abort then
                        return
                    end
                end

                index = index + 1
            end
        end
    end
}
