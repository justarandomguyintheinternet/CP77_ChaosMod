event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "Slippy V"
    o.settings = {
        active = true,
        duration = 45,
        chanceMultiplier = 10,
        recurring = true,
        delayMin = 4,
        delayMax = 10
    }

    o.data = {
        timer = 0,
        timerDelay = 0
    }

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.ApplyEffectOnPlayer("BaseStatusEffect.SecondaryKnockdown")
    self.data.timerDelay = math.random(self.settings.delayMin, self.settings.delayMax)
end

function event:run(deltaTime)
    self.data.timer = self.data.timer + deltaTime
    if (self.data.timer > self.data.timerDelay) then
        self.data.timerDelay = math.random(self.settings.delayMin, self.settings.delayMax)
        self.data.timer = self.data.timer - self.data.timerDelay
        Game.ApplyEffectOnPlayer("BaseStatusEffect.SecondaryKnockdown")
    end
end

function event:deactivate() 

end

function event:drawCustomSettings()
    self.settings.recurring, changed = ImGui.Checkbox("Recurring", self.settings.recurring)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.delayMin, changed = ImGui.InputFloat("Delay Min.", self.settings.delayMin, 2, 100, "%.1f")
    self.settings.delayMin = math.min(math.max(self.settings.delayMin, 2), 100)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.delayMax, changed = ImGui.InputFloat("Delay Max.", self.settings.delayMax, 1, 100, "%.1f")
    self.settings.delayMax = math.min(math.max(self.settings.delayMax, 1), 100)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event