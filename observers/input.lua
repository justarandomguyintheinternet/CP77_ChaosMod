observer = {}

function observer:new() 
	local o = {} 

    o.name = "input"
    o.data = {
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

	self.__index = self
   	return setmetatable(o, self)
end

function observer:init()
    Observe('PlayerPuppet', 'OnAction', function(action)
        local actionName = Game.NameToString(action:GetName(action))
        local actionType = action:GetType(action).value
        if actionName == 'Forward' then
            if actionType == 'BUTTON_PRESSED' then
                self.data.forward = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.forward = false
            end
        elseif actionName == 'Back'then
            if actionType == 'BUTTON_PRESSED' then
                self.data.backwards = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.backwards = false
            end
        elseif actionName == 'Right'then
            if actionType == 'BUTTON_PRESSED' then
                self.data.right = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.right = false
            end
        elseif actionName == 'Left'then
            if actionType == 'BUTTON_PRESSED' then
                self.data.left = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.left = false
            end
        elseif actionName == 'ToggleSprint'then
            if actionType == 'BUTTON_PRESSED' then
                self.data.crouch = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.crouch = false
            end
        elseif actionName == 'Jump'then
            if actionType == 'BUTTON_PRESSED' or actionType == 'BUTTON_HOLD_COMPLETE' then
                self.data.jump = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.jump = false
            end
        elseif actionName == 'RangedAttack'then
            if actionType == 'BUTTON_PRESSED'then
                self.data.shoot = true
            elseif actionType == 'BUTTON_RELEASED' then
                self.data.shoot = false
            end
        elseif actionName == 'RangedADS' then
            if actionType == 'BUTTON_HOLD_COMPLETE' then
                self.data.adsComplete = true
            elseif actionType == "BUTTON_RELEASED" then
                self.data.adsComplete = false
            end
        end
    end)
end

return observer
