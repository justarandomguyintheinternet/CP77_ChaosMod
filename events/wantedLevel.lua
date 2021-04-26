event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Bad boy V"
    o.settings = {
        active = true,
        duration = 5,
		chanceMultiplier = 10,
        stars = 2
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
	self.chaosMod.modules.Cron.Every(1.0, {tick = 0}, function(timer)
    	Game.PrevSys_active()
		if timer.tick < self.settings.stars then
			timer.tick = timer.tick + 1
		else
			timer:Halt()
		end
	end)
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()
    self.settings.stars, changed = ImGui.InputInt("Stars", self.settings.stars, 1, 5)
	self.settings.stars = math.min(math.max(self.settings.stars, 1), 5)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event