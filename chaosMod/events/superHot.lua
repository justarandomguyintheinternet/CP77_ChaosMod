event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "SuperHot"
    o.settings = {
        active = true,
        chanceMultiplier = 10,
        duration = 45
    }

    o.data = {
        lastPos = Game.GetPlayer():GetWorldPosition()
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:distanceVector(from, to)
    return math.sqrt((to.x - from.x)^2 + (to.y - from.y)^2 + (to.z - from.z)^2)
end

function event:activate()
    self.data.lastPos = Game.GetPlayer():GetWorldPosition()
    Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(true) 
end

function event:run()
    if self:distanceVector(Game.GetPlayer():GetWorldPosition(), self.data.lastPos) > 0 then
        Game.SetTimeDilation(0)
        self.chaosMod.sharedData.timeDialation = 1
    else
        Game.SetTimeDilation(0.01)
        self.chaosMod.sharedData.timeDialation = 0.01
    end
    self.data.lastPos = Game.GetPlayer():GetWorldPosition()
end

function event:deactivate()
    Game.SetTimeDilation(0)
    self.chaosMod.sharedData.timeDialation = 0
    Game.GetTimeSystem():SetIgnoreTimeDilationOnLocalPlayerZero(false) 
end

function event:drawCustomSettings()

end

return event