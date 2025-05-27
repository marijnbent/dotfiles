require("hs.ipc")
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.dotfiles/hammerspoon/?.lua"

require("main")