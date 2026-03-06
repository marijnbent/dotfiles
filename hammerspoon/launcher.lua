print('🥁 Launcher loaded')

spoon.LeftRightHotkey:bind({"rCmd"}, "i", function()
    hs.application.launchOrFocus("Ghostty")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "o", function()
    hs.application.launchOrFocus("Obsidian")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "p", function()
    hs.application.launchOrFocus("1Password")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "j", function()
    hs.application.launchOrFocus("Tiimo")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "k", function()
    hs.application.launchOrFocus("Codex")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "l", function()
    hs.application.launchOrFocus("/System/Volumes/Data/Users/marijn/Applications/Edge Apps.localized/AI Studio.app")
end)

-- spoon.LeftRightHotkey:bind({"rCmd"}, "n", function()
-- end)

spoon.LeftRightHotkey:bind({"rCmd"}, "m", function()
    hs.application.launchOrFocus("Canary Mail")
end)
