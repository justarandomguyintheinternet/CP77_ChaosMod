event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Lil bit faster"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        maxSpeed = 5,
        minSpeed = 2
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.SetTimeDilation(1 * math.random(self.settings.minSpeed, self.settings.maxSpeed))
end

function event:run()

end

function event:deactivate()
    Game.SetTimeDilation(0)
end

function event:drawCustomSettings()
    self.settings.minSpeed, changed = ImGui.InputFloat("Minimum Speed", self.settings.minSpeed, 0.1, 49, "%.1f")
    self.settings.minSpeed = math.min(math.max(self.settings.minSpeed, 0.1), 49)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.maxSpeed, changed = ImGui.InputFloat("Maximum Speed", self.settings.maxSpeed, 0.1, 50, "%.1f")
    self.settings.maxSpeed = math.min(math.max(self.settings.maxSpeed, 0.1), 50)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event