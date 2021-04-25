event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Vehicle props"
    o.settings = {
        active = true,
        duration = 75,
        chanceMultiplier = 10
    }

    o.data = {
        timer = 0,
        timerDelay = 0.5
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    self.data.ids = {}
end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timer = self.data.timer - self.data.timerDelay

        if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) ~= nil then
            local vPS = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):GetVehiclePS()
            vPS:DisableAllVehInteractions()
        end

        local objs = self.chaosMod.utils.getObjects(999)
        for _, v in pairs(objs) do
            if v:IsVehicle() then
                if not self.chaosMod.utils.hasEntID(self.data.ids, v:GetEntityID()) then
                    table.insert(self.data.ids, v:GetEntityID())
                end

                local vPS = v:GetVehiclePS()
                vPS:DisableAllVehInteractions()
            end
        end
    end
end

function event:deactivate()
    for _, v in pairs(self.data.ids) do
        local veh = Game.FindEntityByID(v)
        if veh then
            local vPS = veh:GetVehiclePS()
            vPS:ResetVehicleInteractionState()
        end
    end
end

function event:drawCustomSettings()

end

return event