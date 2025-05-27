print("🎯 Edge swipe loaded!")

local gestureActive = false
local lastDirection = nil
local gestureTimer = nil
local horizontalThreshold = 2.0  -- Minimum horizontal scroll amount
local verticalToHorizontalRatio = 2.0  -- Horizontal must be at least 2x stronger than vertical

local scrollTap = hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(event)
    local verticalOffset = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
    local horizontalOffset = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2)
    
    if gestureTimer then
    gestureTimer:stop()
    end
    gestureTimer = hs.timer.doAfter(0.5, function()
        gestureActive = false
        lastDirection = nil
    end)
    
    -- Only process if horizontal scroll is significant AND stronger than vertical scroll
    local absHorizontal = math.abs(horizontalOffset)
    local absVertical = math.abs(verticalOffset)
    
    if absHorizontal > horizontalThreshold and absHorizontal > (absVertical * verticalToHorizontalRatio) then
        local currentDirection = horizontalOffset > 0 and "left" or "right"
        
        if not gestureActive or lastDirection ~= currentDirection then
            gestureActive = true
            lastDirection = currentDirection
            
            local flags = event:getFlags()
            local modifiers = {}
            
            if flags.cmd then
                return false
            end
            
            if currentDirection == "left" then
                print("🔄 Scrolling LEFT")
                hs.eventtap.keyStroke({"cmd"}, "[")
            else
                print("🔄 Scrolling RIGHT")
                hs.eventtap.keyStroke({"cmd"}, "]")
            end
        end
    end
    
    return false
end)

scrollTap:start()

print("📡 Scroll detection started - scroll left/right!")

