-- Configuration
local edgeBundleID = "com.microsoft.edgemac" -- Or com.microsoft.Edge.dev, etc.
local swipeDebug = false -- Set to true for verbose console output
local navigationThreshold = 0.05 -- Minimum swipeX magnitude from 'Began' phase to trigger navigation
                           -- This might need to be small as swipeX at 'Began' can be small.
local navigationActionDelay = 0.06 -- Seconds (60ms). Time to wait after swipe starts.
                                 -- If no scroll detected by then, assume navigation.
                                 -- This needs to be quick to "beat" Edge's own nav.

local swipeActionTimer = nil
local currentSwipeIsActuallyScroll = false -- Flag to track if scroll events occurred for the current swipe

local function isMicrosoftEdgeActive()
    local app = hs.application.frontmostApplication()
    return app and app:bundleID() == edgeBundleID
end

-- Watch for actual scroll events
local scrollEventMonitor = hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(event)
    if not isMicrosoftEdgeActive() then return false end

    -- Check for horizontal scroll
    local deltaX = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
    if deltaX and math.abs(deltaX) > 0.01 then -- Small threshold to detect any genuine horizontal scroll
        if swipeDebug then print("Edge: Horizontal scroll detected, deltaX: " .. deltaX) end
        currentSwipeIsActuallyScroll = true
        if swipeActionTimer then -- If a navigation action was pending, cancel it because we're scrolling
            if swipeDebug then print("Edge: Cancelling pending navigation action due to scroll event.") end
            swipeActionTimer:stop()
            swipeActionTimer = nil
        end
    end
    return false -- IMPORTANT: Let all scroll events pass through to Edge
end)

-- Watch for swipe gestures
local swipeGestureMonitor = hs.eventtap.new({hs.eventtap.event.types.swipe}, function(event)
    if not isMicrosoftEdgeActive() then
        if swipeActionTimer then swipeActionTimer:stop(); swipeActionTimer = nil; end
        return false -- Not in Edge, let event pass
    end

    local gesturePhase = event:getProperty(hs.eventtap.event.properties.NSEventGesturePhase)
    local swipeAxis = event:getProperty(hs.eventtap.event.properties.NSEventGestureAxis)

    if swipeAxis ~= 1 then return false end -- We only care about horizontal swipes

    local swipeX_current = event:getProperty(hs.eventtap.event.properties.NSEventSwipeTrackingX) or 0

    if swipeDebug then
        print(string.format("Edge Swipe: Phase=%s, Axis=%s, X=%.2f, currentSwipeIsScroll=%s",
                            tostring(gesturePhase), tostring(swipeAxis), swipeX_current,
                            tostring(currentSwipeIsActuallyScroll)))
    end

    if gesturePhase == 1 then -- Began
        currentSwipeIsActuallyScroll = false -- Reset for this new gesture
        if swipeActionTimer then swipeActionTimer:stop(); swipeActionTimer = nil; end -- Clear any previous timer

        -- Capture the swipeX from the 'Began' phase, as this is when the gesture intent starts.
        -- The value of swipeX at 'Ended' can often be 0.0.
        local swipeX_at_began = swipeX_current

        swipeActionTimer = hs.timer.doAfter(navigationActionDelay, function()
            if swipeDebug then
                print("Edge: Swipe action timer fired. currentSwipeIsActuallyScroll: " .. tostring(currentSwipeIsActuallyScroll))
            end
            if not currentSwipeIsActuallyScroll then -- If no scroll was detected within the delay
                if swipeX_at_began > navigationThreshold then
                    if swipeDebug then print("Edge: Simulating Forward (Cmd+]) via timer.") end
                    hs.hotkey.post({"cmd"}, "]")
                elseif swipeX_at_began < -navigationThreshold then
                    if swipeDebug then print("Edge: Simulating Back (Cmd+[) via timer.") end
                    hs.hotkey.post({"cmd"}, "[")
                else
                     if swipeDebug then print("Edge: Swipe X (from Began phase) too small on timer, not acting.") end
                end
            else
                if swipeDebug then print("Edge: Timer fired, but swipe was determined to be a scroll. No navigation action.") end
            end
            swipeActionTimer = nil -- Timer has done its job or was irrelevant
        end)
        -- IMPORTANT: DO NOT CONSUME (return false). Let Edge see the swipe event.
        -- This allows Edge to initiate scrolling if appropriate. Our timer races Edge for navigation.
        return false

    elseif gesturePhase == 4 or gesturePhase == 8 then -- Ended or Cancelled
        -- If the swipe gesture ends or is cancelled before our timer fires,
        -- it means the swipe was very short. We should cancel our pending action.
        if swipeActionTimer then
            if swipeDebug then print("Edge: Swipe Ended/Cancelled before timer fired. Stopping timer.") end
            swipeActionTimer:stop()
            swipeActionTimer = nil
        end
        -- Reset the scroll flag just in case, for cleanliness for the next gesture.
        -- currentSwipeIsActuallyScroll = false --  Actually, let the scroll monitor manage this,
                                             -- or a timer that resets it after a scroll gesture finishes.
                                             -- For now, resetting on 'Began' is the primary mechanism.
        return false -- Let Edge handle the end of its animation/scroll.

    elseif gesturePhase == 2 then -- Changed
        -- We could potentially update swipeX_at_began here if we want the "strongest" part of the swipe
        -- local swipeX_latest = event:getProperty(hs.eventtap.event.properties.NSEventSwipeTrackingX)
        -- This is complex because the timer captures the value from 'Began'.
        -- For simplicity, we'll stick to 'Began' swipeX for the timer's decision.
        return false -- Let it pass
    end

    return false -- Default, don't consume
end)

function startEdgeSmartSwipe()
    if scrollEventMonitor:start() and swipeGestureMonitor:start() then
        hs.alert.show("Edge Smart Swipe Loaded")
    else
        hs.alert.show("Error starting Edge Smart Swipe monitors")
    end
end

function stopEdgeSmartSwipe()
    if scrollEventMonitor then scrollEventMonitor:stop() end
    if swipeGestureMonitor then swipeGestureMonitor:stop() end
    if swipeActionTimer then swipeActionTimer:stop(); swipeActionTimer = nil; end
    hs.alert.show("Edge Smart Swipe Stopped")
end

-- Start the monitors
startEdgeSmartSwipe()
