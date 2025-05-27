print('Spotify module loaded')

local spotify_script = [[
    if application "Spotify" is running then
        tell application "Spotify"
            playpause
        end tell
    else
        tell application "Spotify"
            activate
        end tell
        delay 2
        if application "Spotify" is running then
            tell application "Spotify"
                play
            end tell
        end if
    end if
]]

local playPauseWatcher = hs.eventtap.new({hs.eventtap.event.types.systemDefined}, function(event)
    local systemKeyEvent = event:systemKey()
    if systemKeyEvent and systemKeyEvent.key == "PLAY" and systemKeyEvent.down then
        print("Play/Pause key pressed")
        hs.spotify.playpause()
        -- hs.osascript.applescript(spotify_script)
    end
    return false
end)

playPauseWatcher:start()


