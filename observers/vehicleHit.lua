observer = {}

function observer:new() 
	local o = {} 

    o.name = "vehicleHit"
    o.data = {
        hit = false,
        car = nil
    }

	self.__index = self
   	return setmetatable(o, self)
end


function observer:init()
    Observe('VehicleComponent', 'CreateHitEventOnSelf', function(this)
        self.data.car = this:GetVehicle()
        self.data.hit = true
    end)
end

return observer
