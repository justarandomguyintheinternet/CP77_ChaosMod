event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "V has a problem"
    o.settings = {
        active = true,
        duration = 0,
        chanceMultiplier = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.ApplyEffectOnPlayer("BaseStatusEffect.Drunk")
end

function event:run()

end

function event:deactivate() 

end

function event:drawCustomSettings()

end

return event