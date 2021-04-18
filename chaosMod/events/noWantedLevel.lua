event = {}

function event:new(cM) 
    local o = {} 

    o.chaosMod = cM

    o.name = "Good guy V"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10
    }

    o.drawSettings = false
    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.PrevSys_off()
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event