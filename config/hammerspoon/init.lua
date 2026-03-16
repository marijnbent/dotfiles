require("hs.ipc")
package.path = package.path .. ";" .. hs.configdir .. "/?.lua"

require("main")
