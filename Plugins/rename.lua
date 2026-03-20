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

local function dialog(text, defaultAnswer, hiddenAnswer, buttons, defaultButton, cancelButton, withTitle, withIcon, givingUpAfter)
    local script = "osascript <<'EOF'\n"
    script = script .. 'display dialog "' .. escape(text) .. '"'
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

local function alert(text, message, as, buttons, defaultButton, cancelButton, givingUpAfter)
    local script = "osascript <<'EOF'\n"
    script = script .. 'display alert "' .. escape(text) .. '"'
    if message then
        script = script .. ' message "' .. escape(message) .. '"'
    end
    if as then
        script = script .. ' as ' .. as
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
    if givingUpAfter then
        script = script .. ' giving up after ' .. givingUpAfter
    end
    script = script .. "\nEOF"

    local handle = io.popen(script)
    local result = handle:read("*a")
    handle:close()

    if result ~= "" then
        if givingUpAfter then
            local button, gaveUp = result:match("button returned:(.*), gave up:(.*)\n")
            return button, gaveUp == "true"
        else
            return result:match("button returned:(.*)\n")
        end
    else
        if givingUpAfter then
            return cancelButton, false
        else
            return cancelButton
        end
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
            elseif placeholder == "name:upper" then
                return name:upper()
            elseif placeholder == "name:lower" then
                return name:lower()
            elseif placeholder == "extension" then
                return extension
            elseif placeholder == "extension:upper" then
                return extension:upper()
            elseif placeholder == "extension:lower" then
                return extension:lower()
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

        local renames = {}
        local model = context.activePane.model
        local index = 1
        for _, info in ipairs(model.activeFileInfos) do
            if info.isFile then
                local file = info.file
                local name = buildName(pattern, index, file.nameWithoutExtension, file.extension)
                table.insert(renames, {info = info, file = file, name = name})
                index = index + 1
            end
        end

        local names = {}
        for _, rename in ipairs(renames) do
            if names[rename.name] then
                local text = "Rename conflict:\n"
                text = text .. names[rename.name] .. " → " .. rename.name .. " ← " .. rename.file.name
                alert(text, nil, "warning", {"Abort"}, "Abort")
                return
            end
            names[rename.name] = rename.file.name
        end

        for _, rename in ipairs(renames) do
            local file = rename.file.parent:resolve(rename.name)
            if rename.file.name:lower() ~= rename.name:lower() and file:exists() then
                local _, info = file:readInfo({"dateModified", "size"})
                local text = "File already exists:\n"
                text = text .. rename.file.name .. " → " .. file.name
                local message = "Existing:\n"
                if info then
                    message = message .. os.date("%Y-%m-%d %H:%M:%S", info.dateModified) .. ", " .. martax.formatSize(info.size) .. "\n"
                else
                    message = message .. "\n"
                end
                message = message .. tostring(file.path) .. "\n\n"
                message = message .. "New:\n"
                message = message .. os.date("%Y-%m-%d %H:%M:%S", rename.info.dateModified) .. ", " .. martax.formatSize(rename.info.size) .. "\n"
                message = message .. tostring(rename.file.path)
                alert(text, message, "informational", {"Abort"}, "Abort")
                return
            end
        end

        for _, rename in ipairs(renames) do
            local file = rename.file.parent:resolve(rename.name)
            local error = rename.file:rename(file.path)
            if error then
                local text = "Can't rename \"" .. rename.file.name .. "\""
                local message = error.description .. "\n\n"
                message = message .. "Full path: " .. tostring(rename.file.path)
                local button = alert(text, message, "warning", {"Skip", "Abort"}, "Abort", "Skip")
                if button == "Abort" then
                    return
                end
            end
        end
    end
}
