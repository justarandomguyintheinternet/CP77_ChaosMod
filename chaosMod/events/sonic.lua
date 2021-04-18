event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Sanic the hedgefond"
    o.settings = {
        active = true,
        duration = 7.5,
        chanceMultiplier = 10,
        speed = 10
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.SetTimeDilation(self.settings.speed)
end

function event:run()

end

function event:deactivate()
    Game.SetTimeDilation(0)
end

function event:drawCustomSettings()
    self.settings.speed, changed = ImGui.InputInt("Speed", self.settings.speed, 1, 250)
    self.settings.speed = math.min(math.max(self.settings.speed, 1), 250)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event