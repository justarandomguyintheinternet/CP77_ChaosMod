local Cron = require "modules.external.Cron"
event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "What are you doing, step V?"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10
    }
    o.data = {
        pos = nil
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate() 
    self.data.pos = Game.GetPlayer():GetWorldPosition()
end

function event:run()
    Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), self.data.pos, EulerAngles.new(0,0,Game.GetPlayer():GetWorldYaw()))
end

function event:deactivate() 

end

function event:drawCustomSettings()

end

return event
