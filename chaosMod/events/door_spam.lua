event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Spammy doors"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10
    }

    o.data = {
        timer = 0,
        timerDelay = 0.5,
        state = true
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    self.data.state = true
end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timer = self.data.timer - self.data.timerDelay

        if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
            local vPS = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetVehiclePS()
            if self.data.state == true then
                vPS:OpenAllVehDoors()
            else
                vPS:CloseAllVehDoors()
            end 
        end

        local objs = self.chaosMod.utils.getObjects(999)
        for _, v in pairs(objs) do
            if v:IsVehicle() then
                local vPS = v:GetVehiclePS()
                if self.data.state == true then
                    vPS:OpenAllVehDoors()
                else
                    vPS:CloseAllVehDoors()
                end
            end
        end

        self.data.state = not self.data.state

    end
end

function event:deactivate()
    if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
        local vPS = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetVehiclePS()
        vPS:CloseAllVehDoors()
    end

    local objs = self.chaosMod.utils.getObjects(999)
    for _, v in pairs(objs) do
        if v:IsVehicle() then
            local vPS = v:GetVehiclePS()
            vPS:CloseAllVehDoors()
        end
    end
end

function event:drawCustomSettings()

end

return event