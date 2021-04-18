event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "V the fish"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        stopAfterDuration = true
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.GetPlayer():StartOxygenDecay()
end

function event:run()

end

function event:deactivate()
    if self.settings.stopAfterDuration then
        Game.GetPlayer():StopOxygenDecay()
    end
end

function event:drawCustomSettings()
    self.settings.stopAfterDuration, changed = ImGui.Checkbox("Stop after duration", self.settings.stopAfterDuration)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event