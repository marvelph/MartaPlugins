local function gitStatus(path)
    local command = "git -C " .. path .. " status -b --porcelain -z"

    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    local conflicted = 0
    local staged = 0
    local unstaged = 0
    local untracked = 0
    for line in string.gmatch(result, "([^\0]*)") do
        local x = line:sub(1, 1)
        local y = line:sub(2, 2)
        if x == "#" and y == "#" then
            
        elseif x == "?" and y == "?" then
            untracked = untracked + 1
        elseif (x == "U" or y == "U") or (x == "A" and y == "A") or (x == "D" and y == "D") then
            conflicted = conflicted + 1
        else
            if x ~= " " then
                staged = staged + 1
            end
            if y ~= " " then
                unstaged = unstaged + 1
            end
        end
    end
    return string.format("conflicted: %d, staged: %d, unstaged: %d, untracked: %d", conflicted, staged, unstaged, untracked)
end

gitStatus("../")
