event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Boop"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10
    }

    o.data = {
        timer = 0,
        timerDelay = 3
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()

end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timer = self.data.timer - self.data.timerDelay

        if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
            local vComp = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetVehicleComponent()
            vComp:HonkAndFlash()
        end

        local objs = self.chaosMod.utils.getObjects(999)
        for _, v in pairs(objs) do
            if v:IsVehicle() then
                ---@type VehicleComponent
                local vComp = v:GetVehicleComponent()
                vComp:HonkAndFlash()
            end
        end

    end
end

function event:deactivate() 

end

function event:drawCustomSettings()

end

return event