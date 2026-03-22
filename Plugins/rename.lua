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

local function dialog(text, defaultAnswer, hiddenAnswer, buttons, defaultButton, cancelButton, withTitle, withIcon,
                      givingUpAfter)
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

local function buildName(pattern, index, name, extension, modified)
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
            elseif placeholder:match("^modified:.+$") then
                local datetime = placeholder:match("^modified:(.+)$")
                datetime = datetime:gsub("ss", "%%S")
                datetime = datetime:gsub("mm", "%%M")
                datetime = datetime:gsub("HH", "%%H")
                datetime = datetime:gsub("dd", "%%d")
                datetime = datetime:gsub("MM", "%%m")
                datetime = datetime:gsub("yyyy", "%%Y")
                return os.date(datetime, modified)
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
        local button, pattern = dialog("Pattern",
            "{index:2}-{modified:yyyy-MM-ddTHH:mm:ss}-{name:upper}.{extension:lower}", nil, { "Cancel", "Rename" },
            "Rename",
            "Cancel", "Rename with Pattern")
        if button == "Cancel" then
            return
        end

        local renames = {}
        local model = context.activePane.model
        local index = 1
        for _, info in ipairs(model.activeFileInfos) do
            if info.isFile then
                local file = info.file
                local targetName = buildName(pattern, index, file.nameWithoutExtension, file.extension, info
                    .dateModified)
                local targetFile = file.parent:resolve(targetName)
                table.insert(renames, { info = info, file = file, targetFile = targetFile })
                index = index + 1
            end
        end

        local names = {}
        for _, rename in ipairs(renames) do
            local targetPath = tostring(rename.targetFile.path):lower()
            if names[targetPath] then
                local text = "Rename conflict:\n"
                text = text .. names[targetPath] .. " → " .. rename.targetFile.name:lower() .. " ← " .. rename.file.name
                alert(text, nil, "warning", { "Abort" }, "Abort")
                return
            end
            names[targetPath] = rename.file.name
        end

        for _, rename in ipairs(renames) do
            if rename.file.name:lower() ~= rename.targetFile.name:lower() and rename.targetFile:exists() then
                local _, targetInfo = rename.targetFile:readInfo({ "dateModified", "size" })
                local text = "File already exists:\n"
                text = text .. rename.file.name .. " → " .. rename.targetFile.name
                local message = "Existing:\n"
                if targetInfo then
                    message = message ..
                        os.date("%Y-%m-%d %H:%M:%S", targetInfo.dateModified) ..
                        ", " .. martax.formatSize(targetInfo.size) .. "\n"
                else
                    message = message .. "\n"
                end
                message = message .. tostring(rename.targetFile.path) .. "\n\n"
                message = message .. "New:\n"
                message = message ..
                    os.date("%Y-%m-%d %H:%M:%S", rename.info.dateModified) ..
                    ", " .. martax.formatSize(rename.info.size) .. "\n"
                message = message .. tostring(rename.file.path)
                alert(text, message, "informational", { "Abort" }, "Abort")
                return
            end
        end

        local count = 0
        for _, rename in ipairs(renames) do
            local error = rename.file:rename(rename.targetFile.path)
            if error then
                local text = "Can't rename \"" .. rename.file.name .. "\""
                local message = error.description .. "\n\n"
                message = message .. "Full path: " .. tostring(rename.file.path)
                local button = alert(text, message, "warning", { "Skip", "Abort" }, "Abort", "Skip")
                if button == "Abort" then
                    return
                end
            else
                count = count + 1
            end
        end

        local text
        if count == 0 then
            text = "No files renamed"
        elseif count == 1 then
            text = "1 file renamed"
        else
            text = string.format("%d files renamed", count)
        end
        context.activePane.view:showNotification(text)
    end
}
