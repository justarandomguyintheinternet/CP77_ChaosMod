event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Calm down"
    o.settings = {
        active = true,
        duration = 7.5,
        chanceMultiplier = 10,
        multiplier = 1
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.SetTimeDilation((0.75 / math.random(1, 50)) * self.settings.multiplier)
end

function event:run()

end

function event:deactivate()
    Game.SetTimeDilation(0)
end

function event:drawCustomSettings()
    self.settings.multiplier, changed = ImGui.InputFloat("Multiplier", self.settings.multiplier, 1, 5, "%.2f")
	self.settings.multiplier = math.min(math.max(self.settings.multiplier, 1), 5)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event