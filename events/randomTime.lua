event = {}

function event:new(cM)
	local o = {} 

    o.chaosMod = cM

    o.name = "Jetlag"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10
    }
    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.GetTimeSystem():SetGameTimeBySeconds(Game.GetTimeSystem():GetGameTimeStamp() + math.random(1, 1000000))
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event