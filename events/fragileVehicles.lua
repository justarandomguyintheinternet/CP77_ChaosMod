event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Fragile vehicles"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()

end

function event:run(deltaTime)
    if self.chaosMod.observers.vehicleHit.data.hit then
        self.chaosMod.observers.vehicleHit.data.hit = false
        local car = self.chaosMod.observers.vehicleHit.data.car
        local vComp = car:GetVehicleComponent()
        local vPS = car:GetVehiclePS()
        if not car:IsDestroyed() then
            vComp:DestroyVehicle()
            vComp:LoadExplodedState()
            vComp:ExplodeVehicle(Game.GetPlayer())
            vPS:ForcePersistentStateChanged()
        end
    end
end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event