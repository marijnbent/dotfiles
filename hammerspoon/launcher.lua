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

-- spoon.LeftRightHotkey:bind({"rCmd"}, "j", function()
-- end)

spoon.LeftRightHotkey:bind({"rCmd"}, "k", function()
    hs.application.launchOrFocus("Codex")
end)

spoon.LeftRightHotkey:bind({"rCmd"}, "l", function()
    hs.application.launchOrFocus("T3 Code (Alpha)")
end)

-- spoon.LeftRightHotkey:bind({"rCmd"}, "n", function()
-- end)

spoon.LeftRightHotkey:bind({"rCmd"}, "m", function()
    hs.application.launchOrFocus("Canary Mail")
end)
