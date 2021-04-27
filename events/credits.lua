event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Roll Credits"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10,
        delay = 2.5
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    self.chaosMod.modules.Cron.After(self.settings.delay, function ()
        local igm = self.chaosMod.observers.inGameMenu.data.igMenu
        if igm then
            igm:SpawnMenuInstanceEvent('OnOpenPauseMenu')
            igm:SpawnMenuInstanceEvent('OnSwitchToCredits')
        end
    end)
end

function event:run(deltaTime)

end

function event:deactivate()

end

function event:drawCustomSettings()
    self.settings.delay, changed = ImGui.InputFloat("Delay", self.settings.delay, 0.1, 5, "%.1f")
    self.settings.delay = math.min(math.max(self.settings.delay, 0.1), 5)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event