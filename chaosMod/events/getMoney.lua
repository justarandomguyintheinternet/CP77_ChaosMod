event = {}

function event:new(cM) 
	local o = {} 

    o.chaosMod = cM

    o.name = "I like money"
    o.settings = {
        active = true,
        duration = 5,
        chanceMultiplier = 10,
        maxMoney = 3333,
        minMoney = 1
    }

    o.data = {}

	self.__index = self
   	return setmetatable(o, self)
end

function event:activate()
    Game.AddToInventory("Items.money", math.random(self.settings.minMoney, self.settings.maxMoney))
end

function event:run()

end

function event:deactivate()

end

function event:drawCustomSettings()
    self.settings.minMoney, changed = ImGui.InputInt("Minimum Money", self.settings.minMoney, 1, 5000)
    self.settings.minMoney = math.min(math.max(self.settings.minMoney, 1), 5000)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end

    self.settings.maxMoney, changed = ImGui.InputInt("Maximum Money", self.settings.maxMoney, 1, 50000)
    self.settings.maxMoney = math.min(math.max(self.settings.maxMoney, 1), 50000)
    if changed then self.chaosMod.fileSys.saveSettings(self.chaosMod) end
end

return event