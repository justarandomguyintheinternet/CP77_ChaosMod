event = {}

function event:new(cM)
	local o = {} 

    o.chaosMod = cM

    o.name = "Time, Dr. Freeman?"
    o.settings = {
        active = true,
        chanceMultiplier = 10,
        duration = 45
    }
    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.SetTimeDilation(0.0001)
    Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(true) 
    self.chaosMod.sharedData.timeDialation = 0.0001
end

function event:run()
    Game.SetTimeDilation(0.0001)
    Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(true) 
end

function event:deactivate()
    Game.SetTimeDilation(0)
    self.chaosMod.sharedData.timeDialation = 1
    Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(false) 
end

function event:drawCustomSettings()

end

return event