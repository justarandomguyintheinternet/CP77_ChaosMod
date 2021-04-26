event = {}

function event:new(cM)
	local o = {}

    o.chaosMod = cM

    o.name = "V ded?"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10,
        chance = 1
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    if math.random(1, 100 / self.settings.chance) == 1 then
        Game.GetPlayer():Kill()
    end
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()
    self.settings.chance, changed = ImGui.InputFloat("Chance (%)", self.settings.chance, 1, 100, "%.2f")
    self.settings.chance = math.min(math.max(self.settings.chance, 0), 100)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event