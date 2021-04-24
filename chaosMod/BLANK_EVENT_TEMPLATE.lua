event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Name"
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

end

function event:run(deltaTime)

end

function event:deactivate()

end

function event:drawCustomSettings()

end

return event