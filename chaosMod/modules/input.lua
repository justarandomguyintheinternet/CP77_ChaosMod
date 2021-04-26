input = {
    forward = false,
    backwards = false,
    right = false,
    left = false,
    jump = false,
    crouch = false,
    scrollUp = false,
    scrollDown = false,
    shoot = false,
    adsComplete = false
}

function input.startInputObserver()
    Observe('PlayerPuppet', 'OnAction', function(action)
        local actionName = Game.NameToString(action:GetName(action))
        local actionType = action:GetType(action).value
        if actionName == 'Forward' then
            if actionType == 'BUTTON_PRESSED' then
                input.forward = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.forward = false
            end
        elseif actionName == 'Back'then
            if actionType == 'BUTTON_PRESSED' then
                input.backwards = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.backwards = false
            end
        elseif actionName == 'Right'then
            if actionType == 'BUTTON_PRESSED' then
                input.right = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.right = false
            end
        elseif actionName == 'Left'then
            if actionType == 'BUTTON_PRESSED' then
                input.left = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.left = false
            end
        elseif actionName == 'ToggleSprint'then
            if actionType == 'BUTTON_PRESSED' then
                input.crouch = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.crouch = false
            end
        elseif actionName == 'Jump'then
            if actionType == 'BUTTON_PRESSED' or actionType == 'BUTTON_HOLD_COMPLETE' then
                input.jump = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.jump = false
            end
        elseif actionName == 'RangedAttack'then
            if actionType == 'BUTTON_PRESSED'then
                input.shoot = true
            elseif actionType == 'BUTTON_RELEASED' then
                input.shoot = false
            end
        elseif actionName == 'RangedADS' then
            if actionType == 'BUTTON_HOLD_COMPLETE' then
                input.adsComplete = true
            elseif actionType == "BUTTON_RELEASED" then
                input.adsComplete = false
            end
        end
    end)
end

return input